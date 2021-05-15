
load(
    "@io_bazel_rules_docker//container:container.bzl",
    "container_pull",
    "container_push",
)




load("@io_bazel_rules_docker//python:image.bzl", "py_image")

#container_image(
#    name = "passwd_image",
#    base = "@py_image_base//image",
#    tars = [":passwd_tar"],
#    user = "nonroot",
#)

load("@server_deps//:requirements.bzl", "requirement")

py_image(
    name = "foo_image",
    srcs = ["foo.py"],
    main = "foo.py",
    base = "@py3_base//image",
deps = [
        requirement("flask"),
        requirement("google-cloud-firestore"),
        requirement("firebase-admin"),
],
)

container_push(
  name = "foo_container",
  format = "Docker",
  registry = "gcr.io",
  repository = "chowwow/foo",
  image = ":foo_image",
)

