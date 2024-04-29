$username = "ubuntu"
$hostname = "82.157.118.175"
$localFolder = "C:\path\to\your\local\folder"
$remoteFolder = "/path/to/your/remote/folder"

# 连接到SFTP服务器
$sftpSession = New-PSSession -ComputerName $hostname -Credential (Get-Credential) -UseSSL

# 切换到远程目录
Set-Location (Get-PSSession) -Session $sftpSession

# 切换到本地目录
Set-Location $localFolder

# 传输文件
Copy-Item -Path * -Destination $remoteFolder -ToSession $sftpSession -Recurse

# 关闭会话
Remove-PSSession -Session $sftpSession