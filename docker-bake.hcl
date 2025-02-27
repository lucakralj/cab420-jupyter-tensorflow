variable "RELEASE" {
    default = "latest"
}

target "default" {
  dockerfile = "Dockerfile"
  tags = ["lucakralj/cab420-jupyter-tensorflow:${RELEASE}"]
}
