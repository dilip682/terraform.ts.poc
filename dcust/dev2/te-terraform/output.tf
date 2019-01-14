#This file will evaluate output.

output "public_ip_Bastion" {
  value = "${aws_instance.example.public_ip}"
}

output "private_ip_App1" {
  value = "${aws_instance.app1.private_ip}"
}

output "private_ip_Index1" {
  value = "${aws_instance.index1.private_ip}"
}

output "private_ip_Oracle_Tools" {
  value = "${aws_instance.oracle.private_ip}"
}

output "lb_address" {
  value = "${aws_alb.alb.dns_name}"
}
