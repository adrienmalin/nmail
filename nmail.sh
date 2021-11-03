#! /bin/sh

###
#
# nmail v0.1
# Author : adrien@malingrey.fr
#
# Scan targets with nmap,
# compare with previous scan
# and send result by mail
#
# Dependencies : nmap, ndiff and xsltproc
#
###

targets="192.168.0.0/24"
options=""
path=.
mailto=mail@address.com
message="Send by nmail.sh"

if [ -f "$path/new_scan.xml" ]
then
    mv -f "$path/new_scan.xml" "$path/prev_scan.xml"
fi

nmap $options $targets -oX "$path/new_scan.xml"

if [ -f "$path/prev_scan.xml" ]
then
    ndiff --xml "$path/prev_scan.xml" "$path/new_scan.xml" | xsltproc nmail.xsl - | while read -r line
    do
        echo $message | mail $mailto -s "$line"   
    done
fi
