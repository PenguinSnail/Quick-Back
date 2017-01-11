#!/bin/sh

read_dom () {
    local IFS=\>
    read -d \< ENTITY CONTENT
}

while read_dom; do
    if [[ $ENTITY = "$1" ]]; then
        echo $CONTENT
        exit
    fi
done

#run by piping xml file into script where $1 is the tag you want the content of