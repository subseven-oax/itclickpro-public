#!/bin/bash

# This script changes the creation date and time of a file based on its filename, this is useful when you copied photos/videos from online sources
# as the files will have the creation date as the day and time when they were downloaded.  The script assumes the filename is in the following format:
# yyyymmdd_hhmmss.xxx i.e. 20241109_163451.jpg
#
# To use this script:
# Save it to a file, for example, change-creation-date.sh
# Make the script executable by running chmod +x change-creation-date.sh
# Run the script with the files you want to change as arguments, like this:
# ./change-creation-date.sh 20240807_171958.jpg


# Function to change the file creation date
change_creation_date() {
    local file="$1"
    local filename=$(basename "$file")
    
    # Extract date and time from the filename
    local date_part=${filename:0:8}
    local time_part=${filename:9:6}
    
    # Format date and time
    local formatted_date="${date_part:0:4}-${date_part:4:2}-${date_part:6:2}"
    local formatted_time="${time_part:0:2}:${time_part:2:2}:${time_part:4:2}"
    
    # Combine date and time
    local new_creation_date="${formatted_date} ${formatted_time}"
    
    # Change the file creation date
    sudo touch -t "$(date -j -f "%Y-%m-%d %H:%M:%S" "$new_creation_date" +"%Y%m%d%H%M.%S")" "$file"
}

# Loop through all files passed as arguments
for file in "$@"; do
    change_creation_date "$file"
done