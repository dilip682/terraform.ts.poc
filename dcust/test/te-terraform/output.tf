#This file will evaluate output.


output "private_ip_App1" {
  value = "${aws_instance.app1.private_ip}"
}

output "private_ip_Index1" {
  value = "${aws_instance.index1.private_ip}"
}

