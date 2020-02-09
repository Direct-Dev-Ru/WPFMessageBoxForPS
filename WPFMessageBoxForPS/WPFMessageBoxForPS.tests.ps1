Import-Module "$PSScriptRoot\WPFMessageBoxForPS.psm1" -Force;

Show-WpfMessageBoxDialog -MessageHeader "Message from Powershell" -MessageBody "Additional information may comes here ..." -ButtonsTexts "Ok,Exit"