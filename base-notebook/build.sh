#!/bin/bash

image="jupyter"
PS3='Select a user: '
options=("jovyan" "release" "giuliano")
select opt in "${options[@]}"
do
    case $opt in
        "jovyan")
	    docker build -t $image --build-arg NB_USER=$opt --build-arg NB_UID=1000 --build-arg NB_GID=100 .
	    break
            ;;
        "release")
	    docker build -t $image --build-arg NB_USER=$opt --build-arg NB_UID=3007 --build-arg NB_GID=3007 .
	    break
            ;;
        "giuliano")
	    docker build -t $image --build-arg NB_USER=$opt --build-arg NB_UID=501 --build-arg NB_GID=20 .
	    break
            ;;
        *) echo "invalid option";;
    esac
done
