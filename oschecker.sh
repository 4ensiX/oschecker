# !/bin/sh
# oschecker.sh

# argument check
if [ $# -ne 1 ]; then
	echo "Invalid argument"
	exit 1
fi

if [ "$1" = "-h" ]; then
	echo "Usage: oschecker.sh [-h] [imagefile]"
	echo ""
	echo "-h     print description"
	echo ""
	echo "This script can determine Windows Version (above windows 95) from offline disk image!"
	echo "However, only the raw format is supported."
	echo "In addition, tools must be pre-instaled."
	echo ""
	echo 'Tools:'
	echo "  The Sleuth Kit"
	echo "       (https://www.sleuthkit.org/sleuthkit/)"
	echo ""
	echo "  hivex "
	echo "       ex) sudo apt install libhivex-bin"
	echo ""
	echo ""
	echo "Have a nice DFIR!"
	exit 0	
fi

if [ -f "$1" -a -r "$1" ]; then
	echo "$1"
else
	echo "File Error"
	exit 1
fi

# image open setting
ver="ntfs"

img_type=`img_stat -t "$1"`

partition_s=`mmls "$1" | grep -i FAT`

tmp=`echo "$partition_s" | grep NTFS`
if [ -z "$tmp" ]; then
	ver="fat"
fi

if [ `echo "$partition_s" | grep -c ''` = 2 ]; then
	partition_s=`echo "$partition_s" | grep "003:"`
fi

# image open
str="$partition_s"
ary=(`echo $str`)   # store array

partition_addr=`echo ${ary[2]}`
analyze_s=`fsstat -i "$img_type" -f "$ver" -o "$partition_addr" "$1"`

if [ -z "$analyze_s" ]; then
	echo "file open Error\n please restart"
	exit 1
fi

# search inode number of registry hive
if [ "$ver" = "fat"  ]; then
	tmp=`fls -i "$img_type" -f "$ver" -o "$partition_addr" "$1" | grep -i WINDOWS`
	str="$tmp"
	ary=(`echo $str`)
	target_inode=`echo ${ary[1]} | sed -e 's/://g' | sed -e 's/-.*//'`

	tmp=`fls -i "$img_type" -f "$ver" -o "$partition_addr" "$1" "$target_inode" | grep -i SYSTEM.DAT`
	str="$tmp"
	ary=(`echo $str`)
	target_inode=`echo ${ary[1]} | sed -e 's/://g' | sed -e 's/-.*//'`

	icat -i "$img_type" -f "$ver" -o "$partition_addr" "$1" "$target_inode" > SYSTEM.DAT
	tmp=`strings SYSTEM.DAT | egrep 'ProductName' | uniq | sed -e 's/ProductName//g' | grep "Microsoft Windows"`
	echo '"ProductName"="'"${tmp}"'"'
	rm SYSTEM.DAT

elif [ "$ver" = "ntfs"  ]; then
	tmp=`fls -i "$img_type" -f "$ver" -o "$partition_addr" "$1" | grep -i WINDOWS`
	str="$tmp"
	ary=(`echo $str`)
	target_inode=`echo ${ary[1]} | sed -e 's/://g' | sed -e 's/-.*//'`
	
	tmp=`fls -i "$img_type" -f "$ver" -o "$partition_addr" "$1" "$target_inode" | grep -i system32`
	str="$tmp"
	ary=(`echo $str`)
	target_inode=`echo ${ary[1]} | sed -e 's/://g' | sed -e 's/-.*//'`

	tmp=`fls -i "$img_type" -f "$ver" -o "$partition_addr" "$1" "$target_inode" | grep d/d | grep config`
	str="$tmp"
	ary=(`echo $str`)
	target_inode=`echo ${ary[1]} | sed -e 's/://g' | sed -e 's/-.*//'`

	tmp=`fls -i "$img_type" -f "$ver" -o "$partition_addr" "$1" "$target_inode" | grep -i software | grep -v LOG`
	str="$tmp"
	ary=(`echo $str`)
	target_inode=`echo ${ary[1]} | sed -e 's/://g' | sed -e 's/-.*//'`

	icat -i "$img_type" -f "$ver" -o "$partition_addr" "$1" "$target_inode" > software
	hivexget software 'Microsoft\Windows NT\CurrentVersion' | egrep 'ProductName|CSDVersion|ReleaseId|"ProductId'
	rm software

else
	echo "now making"
fi
