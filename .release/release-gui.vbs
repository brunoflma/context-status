Option Explicit

Dim fso, shell, scriptDir, ps1File

Set shell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

scriptDir = fso.GetParentFolderName(WScript.ScriptFullName)
ps1File = fso.BuildPath(scriptDir, "release-gui.ps1")

If Not fso.FileExists(ps1File) Then
    MsgBox "Não encontrei release-gui.ps1 em:" & vbCrLf & scriptDir, vbCritical, "Context Status Release"
    WScript.Quit 1
End If

' Executa o PowerShell de forma oculta (sem janela preta) contornando políticas de execução
shell.Run "powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File """ & ps1File & """", 0, False
