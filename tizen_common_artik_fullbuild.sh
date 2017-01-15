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
builddir=./tizen_common_artik
base_name=tizen_base
base_dir=./$base_name
if [ -d $builddir ]; then
	echo "work directory exists already [$builddir]" 
else 
	mkdir -p $builddir
	echo "work directory for Tizen-common for ARTIK-10 = $builddir"
fi 


# Step1: repo sync
cd $builddir

repoinit()
{
	manifest_url=ssh://$userid@review.tizen.org:29418/scm/manifest
	repo init -u $manifest_url -b tizen -m common.xml
	#repo init -u ssh://$userid@review.tizen.org:29418/scm/manifest -b tizen -m common.xml


}

reposync()
{
echo "-----------------------------------------------------------------------"
echo "Syncing Repository based on tizen-common-artik_20170111.3_arm-wayland.xml"
echo "-----------------------------------------------------------------------"
	cp ../Tizen-GLF/tizen-common-artik_20170111.3_arm-wayland.xml .repo/manifests/common/ca-projects.xml
	cp ../Tizen-GLF/common.xml .repo/manifests/
	repo sync -f -q
	echo " ended repo sync "
echo "-----------------------------------------------------------------------"
}
if [ -d .repo ]; then
	echo "repo init has already done before"
	echo "do you want to run repo sync again?>"
	read yorno
	if [ $yorno = "Y" ]; then 
		reposync
	else 
		echo "skip repo sync"
	fi
	
else 
	repoinit
	reposync
fi 

cd ..


#for debugging this script
#echo "do you want to continue to download base packages? >"
#read yorno
#if [ $yorno = "Y" ]; then 
#  echo "continue"
#else 
#  echo "stop by you"
#  exit 1
#fi
#

# Step 2: Tizen Base-packages download
echo "------------------------------------------------------------------"
echo "                       BASE PACKAGES"
echo "------------------------------------------------------------------"
base_download()
{
	cd $base_dir
	echo " start downloading base packages from public repository"
	wget --directory-prefix=./ --mirror --reject index.html* -r -nH --no-parent --cut-dirs=8 http://download.tizen.org/snapshots/tizen/base/latest/repos/arm/packages
	echo " end downloading base packages from public repository"
	createrepo --update ./
	cd ..
}

if [ -d $base_dir ]; then
	echo "$base_dir exist already"
	echo "do you want to download base packages?"
	echo " [Y]es? >"
	read yorn
	if [ $yorn = "Y" ]; then 
		sudo \rm -r $base_dir/*
		base_download
	fi
else 
	mkdir -p $base_dir
	base_download
fi
echo "------------------------------------------------------------------"


# Step 3: build Tizen-Common locally
copy_gbsconf()
{
	rm -rf $builddir/.gbs.conf
	cp ./Tizen-GLF/gbs_conf_artik_local_full_build $builddir/.gbs.conf
	sed -i '8d' $builddir/.gbs.conf
	sed -i '7a 'url=$(pwd)'/'$base_name'/' $builddir/.gbs.conf
	sed -i '14d' $builddir/.gbs.conf
	sed -i '13a 'url=$(pwd)'/GBS-ROOT/local/repos/tizen3.0_common_artik/armv7l/RPMS/' $builddir/.gbs.conf
	sed -i '24d' $builddir/.gbs.conf
	sed -i '23a buildroot='$(pwd)'/GBS-ROOT'  $builddir/.gbs.conf
	
}

echo "------------------------------------------------------------------"
echo "                       START: build  Common packages"
echo "------------------------------------------------------------------"

echo " working directory: $(pwd)"

	echo "do you want to copy .gbs.conf?"
	echo "you must sure that you didn't change base_dir"
	echo " [Y]es? >"
	read yorn
	if [ $yorn = "Y" ]; then 
		copy_gbsconf
	fi
	echo "do you want to build 3.0 packages?" 
	echo " [Y]es? >"
	read yorn
	if [ $yorn = "Y" ]; then 
		cd $builddir
		time gbs build -A armv7l --baselibs --clean --clean-once 
	fi
echo "------------------------------------------------------------------"
echo "                       DONE: build  Common packages"
echo "------------------------------------------------------------------"


# Step 4: create boot image
echo "------------------------------------------------------------------"
echo "                       creating boot image for ARTIK-10"
echo "------------------------------------------------------------------"
time sudo mic cr auto ../Tizen-GLF/common-boot-armv7l-artik10.ks --logfile=./log -o ./mic_images --tmpfs
# Step 3: create platform image 
echo "------------------------------------------------------------------"
echo "                   creating platform common image for ARTIK"
echo "------------------------------------------------------------------"
time sudo mic cr auto ../Tizen-GLF/common-artik-platform-armv7l.ks --logfile=./log -o ./mic_images --tmpfs
echo "------------------------------------------------------------------"
