# Define variables
$repoUrl = "https://github.com/redcanaryco/atomic-red-team.git"
$repoDirectory = "$pwd\AtomicRedTeam"  # Change this to your desired directory

$repoUrlps = "https://github.com/redcanaryco/invoke-atomicredteam.git"
$repoDirectoryps = "$pwd\InvokeAtomicRedTeam"

# Example list of Atomic tests to run (replace with actual test names)
$testList = @(
    "T1003.001",
    "T1218.010"
)


# Install powershell yaml dependencie

function Install-Dependencies {
    Write-Output "Installing dependencies..."
    Install-Module -Name powershell-yaml -Force
}

# Function to clone the Atomic Red Team repository
function Clone-AtomicRedTeamRepository {
    Write-Output "Cloning Atomic Red Team repository from $repoUrl..."
    git clone $repoUrl $repoDirectory
}

# Function to clone the Atomic Red Team repository
function Clone-AtomicRedTeamRepositoryps {
    Write-Output "Cloning Atomic Red Team repository from $repoUrlps..."
    git clone $repoUrlps $repoDirectoryps
}


# Function to import the Invoke-AtomicRedTeam module
function Import-AtomicRedTeamModule {
    Write-Output "Installing Invoke Atomic Red Team...."
    Import-Module "$repoDirectoryps\Invoke-AtomicRedTeam.psd1"
}

# Function to run Atomic tests from a specified list
function Run-AtomicTests {
    param(
        [string]$testName
    )
    $PSDefaultParameterValues = @{"Invoke-AtomicTest:PathToAtomicsFolder"="$pwd\AtomicRedTeam\atomics"}

    Write-Output "Running Atomic test: $testName"

    try {
        Invoke-AtomicTest $testName
        Write-Output "Successfully ran test: $testName"
    }
    catch {
        Write-Error "Failed to run test: $testName. $_"
    }
}

# Main script

#Install deps
Install-Module -Name powershell-yaml -Force

# Step 1: Clone Atomic Red Team repository
Clone-AtomicRedTeamRepository

Clone-AtomicRedTeamRepositoryps

# Step 2: Import Invoke-AtomicRedTeam module
Import-AtomicRedTeamModule

# Step 3: Run tests from the predefined list
foreach ($test in $testList) {
    Run-AtomicTests -testName $test
}
