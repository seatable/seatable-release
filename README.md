#### Docker Compose Deploy
This repository contains the definition of a docker compose file to deploy the SeaTable Server and addtional services like the Python Pipeline or Only Office.

Releases will be directly referenced from the SeaTable Admin Manual and also be used to deploy dedicated instances of SeaTable.

##### Todo

- [ ] Switch to Github Issues/Story instead of Readme Todo ?
- [ ] Explore GitHub Tags/Releases (defined set of versioned images)
- [ ] transfer the picture diagramms into mermaid flow form or encode them as highly compressed images
[mermaid diagrams](https://mermaid.js.org/syntax/examples.html)

- [ ] Modify SeaTable Health Check / Currently commented out -> always unhealthy
- [ ] Check MariaDB Health Check / Reported problems with longer running systems / larger databases (just a timing Problem?)
  - temporary fix in those cases was to not use su-mysql and innodb_initalized

- [ ] Implement an automatic test to check a given combination of services
- [ ] Implement a basic yaml syntax check (lint) on pushs/prs
