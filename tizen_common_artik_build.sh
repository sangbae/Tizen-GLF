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
# please make sure that you followed both 
# 1) Tizen Development Environment Setup 
#    guide: https://source.tizen.org/ko/documentation/developer-guide/environment-setup?langredirect=1
# 2) Installing Development Tools 
#    guide:  https://source.tizen.org/ko/documentation/developer-guide/getting-started-guide/installing-development-tools
# tip: please use ssh to download source codes, not http. (download speed will be very significant)

# account information in review.tizen.org
echo "Enter your id for review.tizen.org>"
read userid
#userid="your account id"  # here, please modify your id of review.tizen.org

# Step1: working environment
work_dir=./tizen_common_artik
base_dir=./tizen_base

if [ -f $work_dir ]; then
	echo "work directory exists already [$work_dir]"
else 
	mkdir -p $work_dir
	echo "work directory for Tizen-common for ARTIK-10 = $work_dir"
fi

if [ -f $base_dir ]; then
	echo "base directory exists already [$base_dir]"
else 
	mkdir -p $base_dir
	echo "base directory for Tizen-common for ARTIK-10 = $base_dir"
fi

# Step1: repo sync
cd $work_dir
manifest_url=ssh://$userid@review.tizen.org:29418/scm/manifest
repo init -u $manifest_url -b tizen -m common.xml
#repo init -u ssh://$userid@review.tizen.org:29418/scm/manifest -b tizen -m common.xml


cp ../Tizen-GLF/tizen-common-artik_20160721.17_platform.xml .repo/manifests/common/
cp ../Tizen-GLF/common.xml .repo/manifests/

repo sync -f -q
cd ..

# Step 2: Tizen Base-packages download
cd $base_dir
wget --directory-prefix=./ --mirror --reject index.html* -r -nH --no-parent --cut-dirs=8 http://download.tizen.org/snapshots/tizen/base/latest/repos/arm/packages


# Step 3: build Tizen-Common locally
cp
