
$reminderFile = "C:\dev_scripts\reminder-queue.txt";#change
$tempFile = "C:\dev_scripts\reminder-temp.txt";#change

$reminderContent = [IO.File]::ReadAllText($reminderFile);
$amountOfEntries = [IO.File]::ReadAllLines($reminderFile).length;

$signatureContent = [IO.File]::ReadAllText("C:\Users\AndrewJ\AppData\Roaming\Microsoft\Signatures\BasicSig.htm"); #change
$totalHours = 0;

$password = [IO.File]::ReadAllText("C:\dev_scripts\credentials.txt"); #change

if ($amountOfEntries -gt 0){
	for ($i = 0; $i -lt $amountOfEntries; $i++){
		$thisReminderContent = [IO.File]::ReadAllLines($reminderFile)[$i];

		$formattedReminderContent = "$($formattedReminderContent)$($thisReminderContent) <br />";
		
		$thisLine = [IO.File]::ReadAllLines($reminderFile)[$i];
	}
	$oDate = Get-Date;
	if ($oDate.minute -lt 10){
		$minute = "0$($oDate.minute)";
	} else {
		$minute = $oDate.minute;
	}
	
	$now = "$($oDate.hour):$($minute)";

	$smtp = new-object Net.Mail.SmtpClient("exch01")#change

	$credentials = new-object Net.NetworkCredential("andrewj", $password)
	$smtp.Credentials = $credentials
	$smtp.EnableSsl = "true"

	$objMailMessage = New-Object System.Net.Mail.MailMessage
	$objMailMessage.IsBodyHTML = $true
	$objMailMessage.From = "myemail" #change
	$objMailMessage.To.Add("myemail") #change
	$objMailMessage.Subject = "Lata-base Reminder $($now)"
	$objMailMessage.Body = "
		<h2>Here are your current lata-base reminder(s)</h2>
		$($formattedReminderContent)
		<br />
		<br />
		<a href='C:\dev_scripts\reminder-requeue.ps1'>Remind me again</a>
		<br />
		<br />		
		$($signatureContent)
		"

	$smtp.send($objMailMessage)

	
	$reminderContent | Out-File $tempFile;
	Out-File -filepath $reminderFile;
	
} else {
	echo 'Empty Reminder file...';
}
exit;