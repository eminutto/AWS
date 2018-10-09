#Output references
output "public_ip"{
    value = "${aws_eip.ip.public_ip}"
}
output "private_ip"{
    value = "${aws_instance.Debian_App.private_ip}"
}
