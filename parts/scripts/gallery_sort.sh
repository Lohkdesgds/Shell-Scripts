
for file in *; do
    # Extract date parts from filename
    if [[ "$file" =~ ^([0-9]{4})([0-9]{2})([0-9]{2})_.*$ ]]; then
        year="${BASH_REMATCH[1]}"
        month="${BASH_REMATCH[2]}"
        day="${BASH_REMATCH[3]}"

        # Create destination directory
        dest_dir="$year/$month/$day"
        mkdir -p "$dest_dir"

        # Move file
        mv -- "$file" "$dest_dir/"
        echo "[1] Moved '$file' to '$dest_dir'"
    elif [[ "$file" =~ ^([0-9]{2})([0-9]{2})([0-9]{2})_.*$ ]]; then
        year="20${BASH_REMATCH[1]}"
        month="${BASH_REMATCH[2]}"
        day="${BASH_REMATCH[3]}"

        # Create destination directory
        dest_dir="$year/$month/$day"
        mkdir -p "$dest_dir"

        # Move file
        mv -- "$file" "$dest_dir/"
        echo "[2] Moved '$file' to '$dest_dir'"
    elif [[ "$file" =~ ^A[0-9]{3}_([0-9]{2})([0-9]{2}).*$ ]]; then
        year="UNKNOWN"
        month="${BASH_REMATCH[1]}"
        day="${BASH_REMATCH[2]}"

        # Create destination directory
        dest_dir="$year/$month/$day"
        mkdir -p "$dest_dir"

        # Move file
        mv -- "$file" "$dest_dir/"
        echo "[3] Moved '$file' to '$dest_dir'"
    elif [[ "$file" =~ ^P_([0-9]{4})([0-9]{2})([0-9]{2})_.*$ ]]; then
        year="${BASH_REMATCH[1]}"
        month="${BASH_REMATCH[2]}"
        day="${BASH_REMATCH[3]}"

        # Create destination directory
        dest_dir="$year/$month/$day"
        mkdir -p "$dest_dir"

        # Move file
        mv -- "$file" "$dest_dir/"
        echo "[4] Moved '$file' to '$dest_dir'"
    elif [[ "$file" =~ ^VID_([0-9]{4})([0-9]{2})([0-9]{2})_.*$ ]]; then
        year="${BASH_REMATCH[1]}"
        month="${BASH_REMATCH[2]}"
        day="${BASH_REMATCH[3]}"

        # Create destination directory
        dest_dir="$year/$month/$day"
        mkdir -p "$dest_dir"

        # Move file
        mv -- "$file" "$dest_dir/"
        echo "[4] Moved '$file' to '$dest_dir'"
    elif [[ "$file" =~ ^V_([0-9]{4})([0-9]{2})([0-9]{2})_.*$ ]]; then
        year="${BASH_REMATCH[1]}"
        month="${BASH_REMATCH[2]}"
        day="${BASH_REMATCH[3]}"

        # Create destination directory
        dest_dir="$year/$month/$day"
        mkdir -p "$dest_dir"

        # Move file
        mv -- "$file" "$dest_dir/"
        echo "[4] Moved '$file' to '$dest_dir'"
    elif [[ "$file" =~ ^IMG_([0-9]{4})([0-9]{2})([0-9]{2})_.*$ ]]; then
        year="${BASH_REMATCH[1]}"
        month="${BASH_REMATCH[2]}"
        day="${BASH_REMATCH[3]}"

        # Create destination directory
        dest_dir="$year/$month/$day"
        mkdir -p "$dest_dir"

        # Move file
        mv -- "$file" "$dest_dir/"
        echo "[5] Moved '$file' to '$dest_dir'"
    elif [[ "$file" =~ ^PXL_([0-9]{4})([0-9]{2})([0-9]{2})_.*$ ]]; then
        year="${BASH_REMATCH[1]}"
        month="${BASH_REMATCH[2]}"
        day="${BASH_REMATCH[3]}"

        # Create destination directory
        dest_dir="$year/$month/$day"
        mkdir -p "$dest_dir"

        # Move file
        mv -- "$file" "$dest_dir/"
        echo "[6] Moved '$file' to '$dest_dir'"
    elif [[ "$file" =~ ^ProShot_([0-9]{4})([0-9]{2})([0-9]{2})_.*$ ]]; then
        year="${BASH_REMATCH[1]}"
        month="${BASH_REMATCH[2]}"
        day="${BASH_REMATCH[3]}"

        # Create destination directory
        dest_dir="$year/$month/$day"
        mkdir -p "$dest_dir"

        # Move file
        mv -- "$file" "$dest_dir/"
        echo "[6] Moved '$file' to '$dest_dir'"
    elif [[ "$file" =~ ^photo_([0-9]{4})([0-9]{2})([0-9]{2})_.*$ ]]; then
        year="${BASH_REMATCH[1]}"
        month="${BASH_REMATCH[2]}"
        day="${BASH_REMATCH[3]}"

        # Create destination directory
        dest_dir="$year/$month/$day"
        mkdir -p "$dest_dir"

        # Move file
        mv -- "$file" "$dest_dir/"
        echo "[6] Moved '$file' to '$dest_dir'"
    elif [[ "$file" =~ ^[0-9]{3}-VIDEO_[0-9]{2}mm-([0-9]{2})([0-9]{2})([0-9]{2})_.*$ ]]; then
        year="20${BASH_REMATCH[1]}"
        month="${BASH_REMATCH[2]}"
        day="${BASH_REMATCH[3]}"

        # Create destination directory
        dest_dir="$year/$month/$day"
        mkdir -p "$dest_dir"

        # Move file
        mv -- "$file" "$dest_dir/"
        echo "[6] Moved '$file' to '$dest_dir'"
    elif [[ "$file" =~ ^[0-9]{3}-VIDEO_[0-9]{3}mm-([0-9]{2})([0-9]{2})([0-9]{2})_.*$ ]]; then
        year="20${BASH_REMATCH[1]}"
        month="${BASH_REMATCH[2]}"
        day="${BASH_REMATCH[3]}"

        # Create destination directory
        dest_dir="$year/$month/$day"
        mkdir -p "$dest_dir"

        # Move file
        mv -- "$file" "$dest_dir/"
        echo "[6] Moved '$file' to '$dest_dir'"
    fi
done