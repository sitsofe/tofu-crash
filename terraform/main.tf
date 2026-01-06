variable "mirror" {
  type    = string
  default = "mirror"
}

resource "openstack_compute_instance_v2" "instance_1" {
  name = "name"
  user_data = templatefile(
    "user_data.tftpl",
    {
      mirror = "${var.mirror}"
    }
  )
}
