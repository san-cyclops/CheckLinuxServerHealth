
$ip = "104.211.226.117"
$port = "20" 

try {
    $socket = New-Object System.Net.Sockets.TcpClient($ip, $port)

    if($socket.Connected) {
        "success"
        $socket.Close()
    }
} catch {
    "error"
}