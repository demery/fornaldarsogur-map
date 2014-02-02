#!/bin/sh

this_dir=`dirname $0`

names_dir=$this_dir/../xml/names
all_names=$names_dir/ALL_NAMES.xml

echo "<blergl>" > $all_names
# sed -n '/^<name /p' $names_dir/*-names.xml >> $all_names
sed -n '/^<name /p' $names_dir/AM02*-names.xml >> $all_names
echo "</blergl>" >> $all_names

echo "Wrote $all_names"
