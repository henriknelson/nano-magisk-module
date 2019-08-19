#!/system/bin/sh
# Do NOT assume where your module will be located.
# ALWAYS use $MODDIR if you need to know where this script
# and module is placed.
# This will make sure your module will still work
# if Magisk change its mount point in the future
MODDIR=${0%/*};

cp_man() {
   man_dir=$1;
   echo $man_dir;
   if [[ ! -d "/system/usr/share/man/$man_dir" ]]; then
      mkdir -p /system/usr/share/man/$man_dir;
   fi

   for man_file in $MODDIR/system/usr/share/man/$man_dir/*; do
      cp -f $MODDIR/system/usr/share/man/$man_dir/$man_file /system/usr/share/man/$man_dir;
      chown 0:0 /system/usr/share/man/$man_dir/$man_file;
      chmod 644 /system/usr/share/man/$man_dir/$man_file;
   done
}

mount -o rw,remount /system/usr/share;

for dir in $MODDIR/system/usr/share/man/man*/; do
    dir="${dir%/}";
    dir="${dir##*/}";
    cp_man $dir;
done

if [[ -s "/system/bin/mandoc" ]]; then
  makewhatis /system/usr/share/man;
fi

mount -o ro,remount /system/usr/share;
