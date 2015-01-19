# virtuoso-rpm-builder
Virtuoso RPM builder will build an RPM for centos/redhat using the latest code from github (default is the develop/7 branch). The RPM should work on Centos 7 & Red Hat Enterprise Linux 7. Use the following command to generate the RPM.

``` sh
  docker run -v /local/path/to/rpm:/home/rpmbuild/RPMS tenforce/virtuoso-rpm-builder 
```

Optionally a different branch can be selected, the following example will build an RPM of the latest stable.

``` sh
  docker run -v /local/path/to/rpm:/home/rpmbuild/RPMS -e VIRT_BRANCH=stable/7 tenforce/virtuoso-rpm-builder 
```

# contributing
1. Fork the repo on GitHub
2. Commit changes to a branch in your fork
3. Pull request "upstream" with your changes

NOTE: Be sure to merge the latest from "upstream" before making a pull request!

# copyright and licensing
Copyright 2015 TenForce bvba

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.