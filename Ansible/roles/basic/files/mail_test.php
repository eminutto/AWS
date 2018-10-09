<?php
    ini_set( 'display_errors', 1 );
    error_reporting( E_ALL );
    $from = "test@testmail.com";
    $to = "test@domain.com";
    $subject = "New blocked IP Address";
    $message = "This IP address has been blocked: $ipaddress";
    $headers = "From:" . $from;
    mail($to,$subject,$message, $headers);
    echo "The email message was sent.";
?>