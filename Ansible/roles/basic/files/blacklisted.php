<?php
 
require 'DB_Connection.php';
 
$result = pg_query($conn, "SELECT * FROM blocked_ips");
if (!$result) {
 echo "An error occurred.\n";
 exit;
}

echo "Full List of blocked IPs<br />\n<br />\ Your current IP: $ipaddress<br />\n";
while ($row = pg_fetch_row($result)) {
 echo "ID: $row[0]  IP: $row[1] Date: $row[2]";
 echo "<br />\n";
}
 
?>