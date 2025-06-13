## SeaTable Docker Compose Releases

This repository contains a docker compose project to deploy SeaTable Server and additional services like the Python Pipeline or OnlyOffice. These releases are being referenced in the [SeaTable Admin Manual](https://admin.seatable.com/). Distribution Method is a release tar download from GitHub.

It is recommended to follow the instructions of the Admin Manual for the installation of SeaTable.

### Releases

Releases are named after the SeaTable version they're based on. The `latest` tag always points to the most recent release, including pre-releases.)

### Preparing a New Release

1. Checkout a commit from the main branch.
2. Create a lightweight tag on the commit in the format `v*.*.*` (full release) or `pre-v*.*.*` (pre-release) and push the tag to origin.
3. All files in the 'compose/' directory will be uploaded to the release as a tarball (`seatable-compose.tar.gz`), and the release will be tagged with the version number from the git tag.

```bash
git tag v*.*.*
git push origin v*.*.*
```

### Reference Releases

This `latest` URL and API call will point to the **_latest full, non-pre, non-draft release._**\
These are the recommended methods to get the latest stable, tested SeaTable release.\
\
**https://github.com/seatable/seatable-release/releases/latest/download/seatable-compose.tar.gz**

```bash
curl -s https://api.github.com/repos/seatable/seatable-release/releases/latest | \
jq -r '.assets[0].browser_download_url'
```

---

#### Download a specific Release (examples)

https://github.com/seatable/seatable-release/releases/download/v4.3.10/seatable-compose.tar.gz\
https://github.com/seatable/seatable-release/releases/download/pre-v4.4.4/seatable-compose.tar.gz

#### Development/Test Installation from Main Branch

This method is not recommended for production use, as the main branch is for development and may contain untested or broken code.

```bash
mkdir -p /opt/seatable-compose && cd /opt/seatable-compose && \
git clone https://github.com/seatable/seatable-release.git && \
mv seatable-release/compose/* seatable-release/compose/.* -t . && rm -r seatable-release/ && \
cp -n .env-release .env
```
