<?php
    $conn = pg_connect("host="insert_aws_db_instance.endpoint_here" port=5432 dbname="insert db name here" user="insert_user" password="insert_password_here"");
if (!$conn) {
 echo "An error occurred.\n";
 exit;
}
?>
