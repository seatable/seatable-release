## SeaTable Docker Compose Releases
This repository contains a docker compose project to deploy SeaTable Server and addtional services like the Python Pipeline or Only Office.

Releases will be referenced in the [SeaTable Admin Manual](https://admin.seatable.io/). Distribution Method will be git clone or wget | tar download of a release.

### Releases
The releases are named after the SeaTable version they are based on.
The tag `latest` will always point to the latest release.

### Usage
- Develop on "wip/" branches, merge back into main
#### To prepare a new release:
- Clone this repository & Checkout a new branch with the Naming Convention `release-v*.*.*` (e.g. `release-v4.1.9`)
- Use compose-var.py to check variables in the compose/.yml files
- Make changes, commit and push your changes -> a release is being created
- Bugfixes needing other SeaTable image versions get their own new relase branch
- Bugfixes concerning only the deployment can be done in the correspondign release branch
- All files in the 'compose/' directory will be uploaded to the release as the tarbal <seatbale-compose.tar.gz> and the release will be tagged with the branchname / version

```bash
git clone <this_repo>
cd <this_repos_directory>
git checkout -b <new_branch> #e.g. release-v4.1.9
```
```bash
# print all ${} or only IMAGE variables in the release/.yml files
python compose-var.py
python compose-var.py -image
```
```bash
git add <relevant_changes>
git commit -m "<commit_message>"
git push
```
### Reference Releases
The `latest` tag will always point to the latest release.
To download the latest tarball you can use this url:
[https://github.com/seatable/seatable-release/releases/latest/download/seatable-compose.tar.gz](https://github.com/seatable/seatable-release/releases/latest/download/seatable-compose.tar.gz)\
\
To download a specific release you can use these types of urls (example):\
[https://github.com/seatable/seatable-release/releases/download/v4.1.9/seatable-compose.tar.gz](https://github.com/seatable/seatable-release/releases/download/v4.1.9/seatable-compose.tar.gz)
