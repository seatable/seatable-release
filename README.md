### Docker Compose Deploy
This repository contains a docker compose project to deploy SeaTable Server and addtional services like the Python Pipeline or Only Office.

Releases will be referenced in the [SeaTable Admin Manual](https://admin.seatable.io/). Distribution Method will be git clone or wget | tar download of a release.

#### Releases
The releases are named after the SeaTable version they are based on.
The tag `latest` will always point to the latest release.

#### Usage
To prepare a new release, you can use these steps:

- Clone this repository & Checkout a new branch with the Naming Convention `v*.*.*` (e.g. `v4.1.9`)
- Make changes, commit and push your changes
- Create a pull request
- All files in the 'release/' directory will be uploaded to the release as a tarbal <seatbale-compose.tar.gz> and the release will be tagged with the  branchname / version

```bash
git clone <this_repo>
cd <this_repos_directory>
git checkout -b <new_branch> #e.g. v4.1.9
```
```bash
git add <relevant_changes>
git commit -m "<commit_message>"
git push
```

### Reference Releases
The latest tag will always point to the latest release.
To download the latest tarball you can use this url:
[https://github.com/seatable/seatable-compose/releases/latest/download/seatable-compose.tar.gz](https://github.com/seatable/seatable-compose/releases/latest/download/seatable-compose.tar.gz)

To download a specific release you can use this scheme of url:
[https://github.com/seatable/seatable-compose/releases/tag/v4.1.9/seatable-compose.tar.gz](https://github.com/seatable/seatable-compose/releases/tag/v4.1.9/seatable-compose.tar.gz)
