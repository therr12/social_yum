load(
    "@io_bazel_rules_docker//container:container.bzl",
    "container_pull",
    "container_push",
)
load("@io_bazel_rules_docker//python:image.bzl", "py_image")
load("@server_deps//:requirements.bzl", "requirement")

py_image(
    name = "server_image",
    srcs = ["server.py"],
    main = "server.py",
    base = "@py3_base//image",
    deps = [
            requirement("flask"),
            requirement("google-cloud-firestore"),
            requirement("google-cloud-secret-manager"),
            requirement("firebase-admin"),
            requirement("grpcio"),
            requirement("googlemaps"),
    ],
)

container_push(
  name = "api_container",
  format = "Docker",
  registry = "gcr.io",
  repository = "chowwow/api",
  image = ":server_image",
)
