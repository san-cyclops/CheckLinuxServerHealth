Param([string]$ip)
$port = "22" 
try {
    $socket = New-Object System.Net.Sockets.TcpClient($ip, $port)

    if($socket.Connected) {
        $socket.Close()
        return [string] "Success Connection"
    }
} catch {
    return [string] "Error Connection"
}