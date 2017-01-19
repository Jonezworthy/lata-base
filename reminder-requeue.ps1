$reminderFile = "C:\dev_scripts\reminder-queue.txt"; #change
$tempFile = "C:\dev_scripts\reminder-temp.txt"; #change

$reminderContent = [IO.File]::ReadAllText($reminderFile);

[IO.File]::ReadAllText($tempFile) | Out-File $reminderFile;

Out-File $tempFile;



