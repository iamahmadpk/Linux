#!/bin/bash

# Check if the argument is a directory
read -p "enter dir name:" dir
if [[ -d $dir ]]; then
    ls $dir   # Use 'ls' if it's a directory
else
    more $dir
fi

