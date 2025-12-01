# Abiotic Factor Dedicated Server Container

A way to run an Abiotic Factor server as a container.

## Useful Guides

- [How to find Steam Manifests](./docs/manifest-id.md)

> **Note on Builds:** The current Dockerfile is configured to use `app_update` to allow for anonymous login. This means the build will always fetch the **latest version** of the Abiotic Factor server. If you need a specific version (e.g., using a Manifest ID), you will need to modify the Dockerfile to use `download_depot` and provide the `STEAM_MANIFEST_ID` build argument, but this may require a licensed Steam account login.

## Helpful Sources

https://github.com/DFJacob/AbioticFactorDedicatedServer/issues/3#issuecomment-2094369127
https://github.com/Pleut/abiotic-factor-linux-docker/tree/main
https://github.com/DFJacob/AbioticFactorDedicatedServer/wiki/Guide-%E2%80%90-Quickstart
