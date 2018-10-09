#Setting up the provider parameters
provider "aws"{
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region = "${var.region}"
}

#RDS#################################### 
#DB Master
resource "aws_db_instance" "dbmaster" {
  
  allocated_storage        = 5 # gigabytes
  backup_retention_period  = 1   # in days
  #db_subnet_group_name     = "default" #"${var.rds_public_subnet_group}"
  engine                   = "postgres"
  engine_version           = "10.3"
  identifier               = "postgredb1"
  instance_class           = "db.t2.micro"
  multi_az                 = false
  name                     = "dbMaster" #DB Name
  password                 = "${var.RDS_password}"
  port                     = 5432
  publicly_accessible      = true
  storage_encrypted        = false
  storage_type             = "gp2"
  username                 = "${var.RDS_username}"
  #security_group_names     = ["${aws_security_group.allow-db.name}"]
  vpc_security_group_ids   = ["${aws_security_group.allow-db.id}"]
  skip_final_snapshot      = true
}

#Lets create a Database to block some users
resource "null_resource" "setup_db" {
  depends_on = ["aws_db_instance.dbmaster"]
  provisioner "local-exec" {
    command = "PGPASSWORD=${var.RDS_password} psql -U ${var.RDS_username} -h ${aws_db_instance.dbmaster.address} -p 5432 postgres < file.sql"
  }
}

#DB Slave
resource "aws_db_instance" "dbslave" {
  allocated_storage        = 5 # gigabytes
  #backup_retention_period  = No need for slave instance
  #db_subnet_group_name     = "default" #"${var.rds_public_subnet_group}"


  engine                   = "postgres"
  engine_version           = "10.3"
  identifier               = "postgredb2"
  instance_class           = "db.t2.micro"
  multi_az                 = false
  name                     = "db2Slave" #DB name
  #password                 = Set up on MasterDB
  port                     = 5432
  publicly_accessible      = true
  storage_encrypted        = false
  storage_type             = "gp2"
  #username                 = Set up on MasterDB
  #security_group_names     = ["${aws_security_group.allow-db.name}"]
  vpc_security_group_ids   = ["${aws_security_group.allow-db.id}"]
  skip_final_snapshot      = true

  replicate_source_db      = "${aws_db_instance.dbmaster.id}"
  
}


#Debian Server Instance#################################
resource "aws_instance" "Debian_App"{
    instance_type = "t2.micro"
    ami = "${lookup(var.amis, var.region)}"
    availability_zone = "eu-central-1a"
    key_name = "${var.debian_key_name}"
    vpc_security_group_ids = [
    "${aws_security_group.allow-ssh.id}",
  ]

    tags{
        Name = "Debian_App"
        Location = "Tallinn"
    }

#NGinx Service UP and running
    provisioner "remote-exec" {
    inline = [
      "sudo apt-get -y update",
      "sudo apt-get -y install nginx",
      "sudo apt-get -y install php7.0-fpm php-pgsql",
      "sudo apt-get -y install postgresql-client",
      "sudo apt-get -y install sendmail",
      "sudo service nginx start",
      "sudo service php7.0-fpm start",
      "sudo service sendmail start"
    ]
    }

#Uploading some code
    provisioner "remote-exec" {
    inline = [
        #Remove default index page
        "sudo rm /var/www/html/index.nginx-debian.html",
        #Create a PHP info page, to check the php conf
        "sudo echo '<?php phpinfo(); ?>' | sudo tee /var/www/html/test.php",
        #Create custom index Page... because we have to say hello to the world
        "sudo echo 'Hello world' | sudo tee /var/www/html/index.html"
    ]
    }

#Connection to the instance properties
    connection {
      type        = "ssh"
      user        = "${var.instance_username}"
      private_key = "${file(var.private_key_path)}" #Path to the private_key
    }
}
#Setup the elastic IP
resource "aws_eip" "ip"{
    instance = "${aws_instance.Debian_App.id}"
}

#Setting up Security Groups
#Security Group HTTP & SSH
resource "aws_security_group" "allow-ssh" {
    #vpc_id = "${aws_vpc.main.id}"
    name = "allow_ports"
    description = "security group that allows ssh and all egress traffic"
    
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    } 

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port=80
        to_port =80
        protocol="tcp"
        cidr_blocks=["0.0.0.0/0"]
    }
    tags {
        Name = "Allow_ssh_http"
    }
}

#Secutiry Group DB
resource "aws_security_group" "allow-db" {
  name = "allow_DB_ports"
  description = "RDS postgresql servers"
  #vpc_id = "${var.rds_vpc_id}"

  # Only postgres in
  ingress {
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic.
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags{
      Name = "Allow_Postgresql_Port"
  }

}