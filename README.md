Description
===========

Installs [Atlassian Crowd](https://www.atlassian.com/software/crowd/overview), a single-sign on system for Atlassian products.

Requirements
============

## Platforms

* Red Hat/CentOS/Scientific (6.0+ required) - "EL6-family"

"EL5-family" might work, but is untested.

## Cookbooks

* database
* openssl
* postgresql

Attributes
==========

This cookbook assumes Crowd is to be installed in /opt, but this can be configured. Most users usually leave this alone, however.

* `node['crowd']['datadir']` - sets the data directory for Crowd, often /var/crowd-home

Recipes
=======

default
-------

Does nothing.

server
------

Installs Crowd Server.

local_database
--------------

Sets up a PostgreSQL database for Crowd on the local machine.

Roadmap
=======

* Support mysql as a database.

License and Author
==================

- Author:: Julian Dunn (<jdunn@secondmarket.com>)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
