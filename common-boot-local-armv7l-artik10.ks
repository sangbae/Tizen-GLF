# -*-mic2-options-*- -f loop --pack-to=@NAME@.tar.gz -*-mic2-options-*-

# 
# Do not Edit! Generated by:
# kickstarter.py
# 

lang en_US.UTF-8
keyboard us
timezone --utc America/Los_Angeles
part /lib/modules --fstype="ext4" --size=20 --ondisk=mmcblk0 --active --label modules --fsoptions=defaults,noatime

rootpw tizen 
xconfig --startxonboot
bootloader  --timeout=3  --append="rw vga=current splash rootwait rootfstype=ext4"   --ptable=gpt --menus="install:Wipe and Install:systemd.unit=system-installer.service:test"

desktop --autologinuser=guest  
user --name guest  --groups audio,video --password 'tizen'


repo --name=common-wayland_armv7l_local --baseurl=file:///home/sblee/Tizen/artik-gbs/GBS-ROOT/local/repos/tizen3.0_common_artik/armv7l/ --ssl_verify=no --priority=1
repo --name=common-wayland_armv7l_public --baseurl=http://download.tizen.org/releases/milestone/tizen/3.0.m2/common_artik/tizen-common-artik_20170111.3/repos/arm-wayland/packages/ --ssl_verify=no --priority=99

%packages

# @ Common Boot Artik 10
arm-artik10-linux-kernel
arm-artik10-linux-kernel-modules
u-boot-artik10
# Others




%end


%attachment
/boot/exynos5422-artik10.dtb
/boot/zImage
/boot/u-boot/params.bin
/boot/u-boot/u-boot.bin
%end

%post

%end

%post --nochroot

%end