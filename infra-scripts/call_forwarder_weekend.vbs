Dim MyFileSystemObj, readFile, fileline

Set MyFileSystemObj = CreateObject("Scripting.FileSystemObject")
Set readFile = MyFileSystemObj.OpenTextFile("D:\Infratel\server_scripts\script2\call_forwarder_weekend.txt")
fileline = readFile.ReadAll

Select Case fileline
Case "0"
	branch = 0
Case "1"
	branch = 1
Case "2"
	branch = 2
Case "3"
	branch = 3
Case "4"
	branch = 4
Case "5"
	branch = 5
Case "6"
	branch = 6
Case "7"
        branch = 7 
Case "8"
        branch = 8 
Case "9"
        branch = 9 
Case "10"
        branch = 10
End Select

readFile.Close
