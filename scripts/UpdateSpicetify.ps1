# Define the commands to be executed
$commands = @(
    "spicetify",
    "spicetify backup",
    "spicetify upgrade",
    "spicetify restore backup apply"
)

# Execute each command
foreach ($command in $commands) {
    Write-Host "Executing: $command"
    Start-Process cmd -ArgumentList "/c $command" -Wait
}

# Prompt to continue
Write-Host "Press any key to continue..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyUp")
