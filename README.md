# sidero-custom-endpoint-hack
A custom Sidero image to allow for loading directly to the Sidero environment, without having to chainload PXE loaders. This can be because you have a simple DHCP server that can only provide a single DHCP boot option for TFTP.

## Tools
- Docker
- A container registry (DockerHub, Quay.io, GitHub Container Registry, etc)

## Use
When following the [Sidero Bootstrapping guide](https://www.sidero.dev/docs/v0.2/guides/bootstrapping/#bootstrapping), once Sidero is installed, but before patching, you can build the custom Sidero image with the hardcoded Sidero bootloader.

## Example
If you have a DockerHub account, you would do something like the following:

    $ make image push patch REGISTRY=docker.io USERNAME=me SIDERO_IP=$PUBLIC_IP

Make sure to replace your container registery, username, etc with valid values. The `$PUBLIC_IP` is the same one from following the Sidero Bootstrapping Guide mentioned above.
