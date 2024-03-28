#!/bin/bash

# Check if correct number of arguments is provided
if [ $# -ne 3 ]; then
    echo "Usage: $0 source_directory destination_directory file_extension"
    exit 1
fi

# Function to copy files from source to destination directory
copy_files() {
    local src_dir="$1"
    local dest_dir="$2"
    local ext="$3"

    # Find all files with the specified extension in the source directory
    find "$src_dir" -type f -name "*.$ext" -print0 |
    while IFS= read -r -d '' file; do
        # Extract only the filename
        filename=$(basename "$file")

        # Remove everything between '[' and ']' from the filename
        new_filename=$(echo "$filename" | sed 's/\[[^]]*\]//g')

        # Extract the directory name containing the file
        dir=$(dirname "$file")

        # Extract only the immediate parent directory
        parent_dir=$(basename "$dir")

        # Create corresponding directory structure in the destination directory
        mkdir -p "$dest_dir/$parent_dir"

        # Copy the file and its parent directory to the destination directory
        cp "$file" "$dest_dir/$parent_dir/$new_filename"
    done
}

# Source directory provided as first argument
source_dir="$1"

# Destination directory provided as second argument
destination_dir="$2"

# File extension provided as third argument
file_extension="$3"

# Create destination directory if it doesn't exist
mkdir -p "$destination_dir"

# Copy files from source to destination directory
copy_files "$source_dir" "$destination_dir" "$file_extension"

echo "Files with .$file_extension extension copied successfully."