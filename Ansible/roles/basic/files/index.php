<?php
 
require'DB_Connection.php';

function getUserIP()
{
    // Get real visitor IP
    if (isset($_SERVER["HTTP_CF_CONNECTING_IP"])) {
              $_SERVER['REMOTE_ADDR'] = $_SERVER["HTTP_CF_CONNECTING_IP"];
              $_SERVER['HTTP_CLIENT_IP'] = $_SERVER["HTTP_CF_CONNECTING_IP"];
    }
    $client  = @$_SERVER['HTTP_CLIENT_IP'];
    $forward = @$_SERVER['HTTP_X_FORWARDED_FOR'];
    $remote  = $_SERVER['REMOTE_ADDR'];

    if(filter_var($client, FILTER_VALIDATE_IP))
    {
        $ip = $client;
    }
    elseif(filter_var($forward, FILTER_VALIDATE_IP))
    {
        $ip = $forward;
    }
    else
    {
        $ip = $remote;
    }

    return $ip;
}

$ipaddress = getUserIP();

$countIps = pg_query($conn, "SELECT * FROM blocked_ips WHERE ip_address = '$ipaddress'");

$columns = pg_num_rows($countIps);

if (!$countIps) {
	
	echo "An error occurred.\n";
 	
	exit;

} if($columns >= 1){
	
    echo "Your IP: $ipaddress has been BLOCKED<br />\n";
	
    include 'mail_test.php';
    
    header("Location: blacklisted.php");
	
	}else{
		
		echo "Enjoy this fibonacci sequence. Your IP has been registered. Next time, if you enter with the same IP address, you will be blacklisted<br />\n<br />\n";
		echo "Your IP: $ipaddress<br />\n";
		
		include'fibonacci.php';
	
		$addIp = pg_query($conn, "INSERT INTO blocked_ips(ip_address, date_block) VALUES ('$ipaddress', now())");		
		
		
	}
 
?>