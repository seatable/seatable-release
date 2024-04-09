## SeaTable Docker Compose Releases
This repository contains a docker compose project to deploy SeaTable Server and addtional services like the Python Pipeline or Only Office.

Releases will be referenced in the [SeaTable Admin Manual](https://admin.seatable.io/). Distribution Method will be git clone or wget | tar download of a release.

### Dev/Test Installing from main branch
This is not reccomended for production use. The main branch is the development branch and can contain untested or broken code.
```bash
mkdir -p /opt/seatable-compose && cd /opt/seatable-compose && \
git clone https://github.com/seatable/seatable-release.git && \
mv seatable-release/compose/* seatable-release/compose/.* -t . && rm -r seatable-release/ && \
cp -n .env-release .env
```

### Releases
The releases are named after the SeaTable version they are based on.
The tag `latest` will always point to the latest release.

### Usage
- Develop on "wip/" branches, merge back into main
#### To prepare a new release:
- Checkout a commit from main
- Create a `release-v*.*.*` tag on the commit & Push the Tag to orign
- All files in the 'compose/' directory will be uploaded to the release as a tar-ball <seatbale-compose.tar.gz> and the release will be tagged with vesion number from the git tag

```bash
git tag release-v*.*.*
git push origin release-v*.*.*
```
### Reference Releases
The `latest` tag will always point to the latest release.
To download the latest tarball you can use this url:
[https://github.com/seatable/seatable-release/releases/latest/download/seatable-compose.tar.gz](https://github.com/seatable/seatable-release/releases/latest/download/seatable-compose.tar.gz)\
\
To download a specific release you can use these types of urls (example):\
[https://github.com/seatable/seatable-release/releases/download/v4.1.9/seatable-compose.tar.gz](https://github.com/seatable/seatable-release/releases/download/v4.1.9/seatable-compose.tar.gz)
