# AnyKernel3 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
kernel.string=Flash Kernel for the OnePlus3/3T by @ahmedradaideh
do.devicecheck=1
do.modules=0
do.systemless=0
do.cleanup=1
do.cleanuponabort=1
device.name1=oneplus3
device.name2=oneplus3t
device.name3=OnePlus3
device.name4=OnePlus3T
supported.versions=10
supported.patchlevels=
'; } # end properties

# shell variables
block=/dev/block/bootdevice/by-name/boot;
is_slot_device=0;
ramdisk_compression=auto;

## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. tools/ak3-core.sh;

## AnyKernel file attributes
# set permissions/ownership for included ramdisk files
set_perm_recursive 0 0 755 644 $ramdisk/*;
set_perm_recursive 0 0 750 750 $ramdisk/init* $ramdisk/sbin;
set_perm 0 0 750 $ramdisk/init.flash_power.sh;

## AnyKernel install
dump_boot;

# begin ramdisk changes

# Import flashkernel.rc
insert_line init.rc "init.flashkernel.rc" after "import /init.usb.configfs.rc" "import /init.flashkernel.rc";

# end ramdisk changes

write_boot;
## end install
