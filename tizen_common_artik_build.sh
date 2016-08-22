#!/bin/sh

# Tizen GBS Local Build Script
#
# Copyright (C) 2016 Linux Foundation
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

#
# Normally this is called as './tizen_common_artik_build.sh <opt1>'
#
#
# please make sure that you followed both 1) Tizen Development Environment Setup 
# and 2) Installing Development Tools 
# 1) guides are here: https://source.tizen.org/ko/documentation/developer-guide/environment-setup?langredirect=1
# 2) guides are here: https://source.tizen.org/ko/documentation/developer-guide/getting-started-guide/installing-development-tools
# tip: please use ssh to download source codes, not http. (download speed will be very significant)

# account information in review.tizen.org
userid="your account id"
# Step1: repo sync
repo init -u ssh://$userid@review.tizen.org:29418/scm/manifest -b tizen -m common.xml

# Tizen Base-packages download
mkdir -p ./BASE
cd ./BASE
wget --directory-prefix=./ --mirror --reject index.html* -r -nH --no-parent --cut-dirs=8 http://download.tizen.org/snapshots/tizen/base/latest/repos/arm/packages
