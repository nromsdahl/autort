# Define variables
$repoUrl = "https://github.com/redcanaryco/atomic-red-team.git"
$repoDirectory = "$pwd\AtomicRedTeam"  # Change this to your desired directory
$testListDirectory = "$pwd\AtomicTests"  # Directory where your test lists are stored

# Function to clone the Atomic Red Team repository
function Clone-AtomicRedTeamRepository {
    Write-Output "Cloning Atomic Red Team repository from $repoUrl..."
    git clone $repoUrl $repoDirectory
}

# Function to import the Invoke-AtomicRedTeam module
function Import-AtomicRedTeamModule {
    Write-Output "Importing Invoke-AtomicRedTeam module..."
    Import-Module "$repoDirectory\atomics\Invoke-AtomicRedTeam\Invoke-AtomicRedTeam.psd1"
}

# Function to run Atomic tests from a specified list
function Run-AtomicTests {
    param(
        [string]$testListFile
    )

    Write-Output "Running Atomic tests listed in $testListFile..."

    # Read the test list file
    $tests = Get-Content $testListFile

    foreach ($test in $tests) {
        try {
            Invoke-AtomicTest -Path "$repoDirectory\atomics\$test"
            Write-Output "Successfully ran test: $test"
        }
        catch {
            Write-Error "Failed to run test: $test. $_"
        }
    }
}

# Main script

# Step 1: Clone Atomic Red Team repository
Clone-AtomicRedTeamRepository

# Step 2: Import Invoke-AtomicRedTeam module
Import-AtomicRedTeamModule

# Step 3: Get list of test files from specified directory
$testLists = Get-ChildItem $testListDirectory -Filter "*.yaml" | Select-Object -ExpandProperty FullName

# Step 4: Run tests from each test list file
foreach ($testList in $testLists) {
    Run-AtomicTests -testListFile $testList
}
