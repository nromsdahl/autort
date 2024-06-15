# Define variables
$repoUrl = "https://github.com/redcanaryco/atomic-red-team.git"
$repoDirectory = "C:\AtomicRedTeam"  # Change this to your desired directory

# Example list of Atomic tests to run (replace with actual test names)
$testList = @(
    "T1003.001",
    "T1003.002",
    "T1059.001",
    "T1218.010"
)

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
        [string]$testName
    )

    Write-Output "Running Atomic test: $testName"

    try {
        Invoke-AtomicTest -Path "$repoDirectory\atomics\$testName"
        Write-Output "Successfully ran test: $testName"
    }
    catch {
        Write-Error "Failed to run test: $testName. $_"
    }
}

# Main script

# Step 1: Clone Atomic Red Team repository
Clone-AtomicRedTeamRepository

# Step 2: Import Invoke-AtomicRedTeam module
Import-AtomicRedTeamModule

# Step 3: Run tests from the predefined list
foreach ($test in $testList) {
    Run-AtomicTests -testName $test
}
