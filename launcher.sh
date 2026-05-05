#!/bin/bash

shopt -s nullglob
SCRIPTROOT=$(dirname "$(realpath "$0")") # path like /usr/path

#echo "Script source path: $SCRIPTROOT";

generic_convert() {
    local kind="$1"; # compress, log2rec709, log2prores
    local type="$2"; # file, folder, recursive
    local file="$3"; # <file> if type=="file"

    local trash_path=$PWD/.converted;
    mkdir -p $trash_path

    while [[ -z "$kind" ]]; do
        echo -n "- What type of conversion you want? [compress, compresshq, edit, log2rec709, compresslog2rec709, log2prores]: ";
        read -p "" kind;
    done
    while [[ -z "$type" ]]; do
        echo -n "- What is your target? [file, folder, recursive]: ";
        read -p "" type;
    done
    while [[ "$type" == "file" && ! -f "$file" ]]; do
        echo -n "- Type file path/name: ";
        read -e -p "" file;
    done

    echo "Working with arguments:";
    [[ -n "$kind" ]] && echo "- Kind: $kind";
    [[ -n "$type" ]] && echo "- Type: $type";
    [[ -n "$file" ]] && echo "- File: $file";

    # Capture possible custom args on call
    local jpg_cq="$CQP"; # for jpg
    local vid_cq="$QUALITY"; # cqp
    local vid_pr="$PRESET"; # preset
    local vid_tn="$TUNE"; # tune
    local vid_pf="$PROFILE"; # profile
    local vid_sc="$SCALE"; # scaling presets
    local vid_la="$LOOKAHEAD"; # lookahead
    local vid_ak="$AUDIO_KBPS"; # audio kbps
    local vid_am="$AUDIO_MIX"; # downmix
    local vid_px="$PIXFMT"; # pixel format (optional)
    local vid_ext="mp4";
    local vid_fil=(); # extra filters (optional)
    local vid_cls=""; # colorspace (optional)
    local vid_cpr=""; # color_primaries (optional)
    local vid_trc=""; # color_trc (optional)
    local HAS_NVIDIA=false

    if command -v nvidia-smi &> /dev/null && nvidia-smi -L &> /dev/null; then
        if [[ "$USE_CPU" != "true" ]]; then
            echo "NVIDIA GPU detected. It will be used for encoding."
            HAS_NVIDIA=true
        else
            echo "NVIDIA GPU detected, but USE_CPU set to true. Using x264 encoding."
            HAS_NVIDIA=false
        fi
    else
        echo "NVIDIA GPU not found or drivers not responding. Falling back to CPU."
        HAS_NVIDIA=false
    fi

    # By kind, set profiles for x264
    case "$kind" in
        "compresshq")
            if [[ $HAS_NVIDIA == true ]]; then
                [[ -z "$vid_cq" ]] && vid_cq=35;
                [[ -z "$vid_pr" ]] && vid_pr="p7";
                [[ -z "$vid_tn" ]] && vid_tn="hq";
                [[ -z "$vid_pf" ]] && vid_pf="main";
            else
                [[ -z "$vid_cq" ]] && vid_cq=29;
                [[ -z "$vid_pr" ]] && vid_pr="slow";
                [[ -z "$vid_tn" ]] && vid_tn="film";
                [[ -z "$vid_pf" ]] && vid_pf="high";
            fi

            [[ -z "$jpg_cq" ]] && jpg_cq=55;
            [[ -z "$vid_sc" ]] && vid_sc="8";
            [[ -z "$vid_ak" ]] && vid_ak="160";
            [[ -z "$vid_am" ]] && vid_am="false";
        ;;
        "compress")
            if [[ $HAS_NVIDIA == true ]]; then
                [[ -z "$vid_cq" ]] && vid_cq=37;
                [[ -z "$vid_pr" ]] && vid_pr="p7";
                [[ -z "$vid_tn" ]] && vid_tn="hq";
                [[ -z "$vid_pf" ]] && vid_pf="main";
            else
                [[ -z "$vid_cq" ]] && vid_cq=31; # Higher CRF = More compression
                [[ -z "$vid_pr" ]] && vid_pr="slow";
                [[ -z "$vid_tn" ]] && vid_tn="film";
                [[ -z "$vid_pf" ]] && vid_pf="high";
            fi

            [[ -z "$jpg_cq" ]] && jpg_cq=40;
            [[ -z "$vid_sc" ]] && vid_sc="9";
            [[ -z "$vid_ak" ]] && vid_ak="128";
            [[ -z "$vid_am" ]] && vid_am="false";
        ;;
        "edit")
            if [[ $HAS_NVIDIA == true ]]; then
                [[ -z "$vid_cq" ]] && vid_cq=24;
                [[ -z "$vid_pr" ]] && vid_pr="p7";
                [[ -z "$vid_tn" ]] && vid_tn="hq";
                [[ -z "$vid_pf" ]] && vid_pf="main";
            else
                [[ -z "$vid_cq" ]] && vid_cq=18;
                [[ -z "$vid_pr" ]] && vid_pr="slow";
                [[ -z "$vid_tn" ]] && vid_tn="film";
                [[ -z "$vid_pf" ]] && vid_pf="high";
            fi

            [[ -z "$jpg_cq" ]] && jpg_cq=70;
            [[ -z "$vid_sc" ]] && vid_sc="0";
            [[ -z "$vid_ak" ]] && vid_ak="256";
            [[ -z "$vid_am" ]] && vid_am="false";
        ;;
        "compresslog2rec709")
            if [[ $HAS_NVIDIA == true ]]; then
                [[ -z "$vid_cq" ]] && vid_cq=37;
                [[ -z "$vid_pr" ]] && vid_pr="p7";
                [[ -z "$vid_tn" ]] && vid_tn="hq";
                [[ -z "$vid_pf" ]] && vid_pf="main";
            else
                [[ -z "$vid_cq" ]] && vid_cq=31;
                [[ -z "$vid_pr" ]] && vid_pr="slow";
                [[ -z "$vid_tn" ]] && vid_tn="film";
                [[ -z "$vid_pf" ]] && vid_pf="high";
            fi

            [[ -z "$jpg_cq" ]] && jpg_cq=40;
            [[ -z "$vid_sc" ]] && vid_sc="9";
            [[ -z "$vid_la" ]] && vid_la="40";
            [[ -z "$vid_ak" ]] && vid_ak="128";
            [[ -z "$vid_am" ]] && vid_am="false";
            vid_px="yuv420p";
            vid_cls="bt709";
            vid_cpr="bt709";
            vid_trc="bt709";
            vid_fil=("format=gbrpf32le" "lut3d='$SCRIPTROOT/lut.cube'" "hue=s=1.00" "format=yuv420p" "setparams=color_primaries=bt709:color_trc=bt709:colorspace=bt709")
        ;;
        "log2rec709")
            if [[ $HAS_NVIDIA == true ]]; then
                [[ -z "$vid_cq" ]] && vid_cq=24;
                [[ -z "$vid_pr" ]] && vid_pr="p7";
                [[ -z "$vid_tn" ]] && vid_tn="hq";
                [[ -z "$vid_pf" ]] && vid_pf="main";
            else
                [[ -z "$vid_cq" ]] && vid_cq=18;
                [[ -z "$vid_pr" ]] && vid_pr="slow";
                [[ -z "$vid_tn" ]] && vid_tn="film";
                [[ -z "$vid_pf" ]] && vid_pf="high";
            fi

            [[ -z "$jpg_cq" ]] && jpg_cq=70;
            [[ -z "$vid_sc" ]] && vid_sc="0";
            [[ -z "$vid_la" ]] && vid_la="40";
            [[ -z "$vid_ak" ]] && vid_ak="256";
            [[ -z "$vid_am" ]] && vid_am="false";
            vid_px="yuv420p";
            vid_cls="bt709";
            vid_cpr="bt709";
            vid_trc="bt709";
            vid_fil=("format=gbrpf32le" "lut3d='$SCRIPTROOT/lut.cube'" "hue=s=1.00" "format=yuv420p" "setparams=color_primaries=bt709:color_trc=bt709:colorspace=bt709")
        ;;
        "log2prores")
            vid_ext="mov";
        ;;
    esac

    if [[ "$vid_ext" == "mov" ]]; then # no tuning for prores output
        CMD_FFMPEG_BEG=(-hide_banner -loglevel error -progress - -y -i)
        CMD_FFMPEG_END=(-c:v prores_ks -vsync 0 -profile:v 1 -pix_fmt yuv422p10le -c:a copy)
    else # non prores
        # Begin arguments for ffmpeg
        if [[ $HAS_NVIDIA == true ]]; then
            CMD_FFMPEG_BEG=(-hide_banner -loglevel error -hwaccel cuda -progress - -y -i)
            CMD_FFMPEG_END=(-c:v hevc_nvenc -vsync 0)
        else
            CMD_FFMPEG_BEG=(-hide_banner -loglevel error -progress - -y -i)
            CMD_FFMPEG_END=(-c:v libx264 -vsync 0)
        fi

        # Get special mappings
        [[ "$vid_am" == "true" ]] && CMD_FFMPEG_END+=(-vol 256 -af "pan=stereo|c0=0.5*c2+0.707*c0+0.707*c4+0.5*c3|c1=0.5*c2+0.707*c1+0.707*c5+0.5*c3");
        
        case "$vid_sc" in
            1)  vid_fil+=("scale=in_w*0.5:in_h*0.5") ;;
            2)  vid_fil+=("scale=in_w*0.333:in_h*0.333") ;;
            3)  vid_fil+=("scale=in_w*0.25:in_h*0.25") ;;
            4)  vid_fil+=("scale=in_w*0.166:in_h*0.166") ;;
            5)  vid_fil+=("scale=in_w*0.125:in_h*0.125") ;;
            6)  vid_fil+=("scale=h='if(gt(iw\,ih)\,2160\,-2)':w='if(gt(iw\,ih)\,-2\,2160)'") ;;
            7)  vid_fil+=("scale=h='if(gt(iw\,ih)\,1440\,-2)':w='if(gt(iw\,ih)\,-2\,1440)'") ;;
            8)  vid_fil+=("scale=h='if(gt(iw\,ih)\,1080\,-2)':w='if(gt(iw\,ih)\,-2\,1080)'") ;;
            9)  vid_fil+=("scale=h='if(gt(iw\,ih)\,720\,-2)':w='if(gt(iw\,ih)\,-2\,720)'") ;;
            16) vid_fil+=("crop=h='if(gt(iw\,ih)\,2160\,3840)':w='if(gt(iw\,ih)\,3840\,2160)'") ;;
            17) vid_fil+=("crop=h='if(gt(iw\,ih)\,1440\,2560)':w='if(gt(iw\,ih)\,2560\,1440)'") ;;
            18) vid_fil+=("crop=h='if(gt(iw\,ih)\,1080\,1920)':w='if(gt(iw\,ih)\,1920\,1080)'") ;;
            19) vid_fil+=("crop=h='if(gt(iw\,ih)\,720\,1280)':w='if(gt(iw\,ih)\,1280\,720)'") ;;
        esac

        VIDEO_FORMAT=$(IFS=,; echo "${vid_fil[*]}");

        if [[ -n "$VIDEO_FORMAT" ]]; then
            CMD_FFMPEG_END+=(-vf "$VIDEO_FORMAT")
        fi

        # Map to ffmpeg
        if [[ $HAS_NVIDIA == true ]]; then
            CMD_FFMPEG_END+=(
                -b:a "${vid_ak}k"
                -preset "$vid_pr"
                -tune "$vid_tn"
                -profile:v "$vid_pf"
                -rc "constqp"
                -qp "$vid_cq"
                -bf 0
                -rc-lookahead "40"
                -gpu any
                -spatial-aq 1
                -aq-strength 15
            )
        else
            CMD_FFMPEG_END+=(
                -b:a "${vid_ak}k"
                -preset "$vid_pr"
                -tune "$vid_tn"
                -profile:v "$vid_pf"
                -crf "$vid_cq"
    #            -x264-params "rc-lookahead=$vid_la" # This passes the lookahead value to x264
                -pix_fmt yuv420p
            )
        fi
        
        [[ -n "$vid_px" ]] && CMD_FFMPEG_END+=(-pix_fmt "$vid_px");
        [[ -n "$vid_cls" ]] && CMD_FFMPEG_END+=(-colorspace "$vid_cls");
        [[ -n "$vid_cpr" ]] && CMD_FFMPEG_END+=(-color_primaries "$vid_cpr");
        [[ -n "$vid_trc" ]] && CMD_FFMPEG_END+=(-color_trc "$vid_trc");
    fi # non pro res

    # Aux functions
    line_status() { local msg="$*"; echo -ne "\r$msg$(tput el)"; }
    get_duration_ms() { ffprobe -v error -select_streams v:0 -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$1" | awk '{printf "%d\n", $1 * 1000}'; }
    print_progress() {
        local duration=$1
        local filename=$2
        local cqp_ref=$3
        local scale_ref=$4
        local last_percent=-1
        local line

        while read -r line; do
            if [[ $line == out_time_us=* ]]; then
                local out_time_us=${line#out_time_us=}
                if [[ "$out_time_us" == "N/A" ]]; then out_time_us=$duration; fi;
            local percent=$((out_time_us / duration / 10))
            local percent_dot=$(((out_time_us * 100 / duration) % 1000))

                if [[ $percent -ne $last_percent ]]; then
                    local bar_size=50
                    local done=$((percent * bar_size / 100))
                    local left=$((bar_size - done))
                    local bar=""
                    if [[ $done -gt 0 ]]; then
                        bar+=$(printf "%0.s#" $(seq 1 $done))
                    fi
                    if [[ $done -lt $bar_size ]]; then
                        bar+=$(printf "%0.s-" $(seq 1 $left))
                    fi
                    echo -ne "[$bar] $percent.$percent_dot% - $filename @ CQP=$cqp_ref SC=$scale_ref   \r"
                    last_percent=$percent
                fi
            fi
        done
        echo -e "[##################################################] 100.00% - $filename @ CQP=$cqp_ref SC=$scale_ref    "
    }

    # Known extensions for mapping
    declare -a FFMPEG_SUPPORTED=("mp4" "avi" "mov" "mkv" "flv" "webm" "mpeg" "asf" "ogv" "mxf")
    declare -a MAGICK_SUPPORTED=("png" "jpg" "jpeg" "bmp" "gif" "ppm" "pgm" "tiff" "tga" "svg" "heic" "heif" "dng")

    FFMPEG_LIST=();
    MAGICK_LIST=();

    case "$type" in
        "file")
            local file_ext="${file##*.}"
            local file_ext_lower="${file_ext,,}"

            if [[ " ${MAGICK_SUPPORTED[*],,} " =~ " ${file_ext_lower} " ]]; then
                MAGICK_LIST+=($file);
            elif [[ " ${FFMPEG_SUPPORTED[*],,} " =~ " ${file_ext_lower} " ]]; then
                FFMPEG_LIST+=($file);
            else
                echo "No matched valid options for file extension. Abort.";
                exit 1;
            fi
        ;;
        "folder")
            for ext in "${FFMPEG_SUPPORTED[@]}"; do
                for file in *."$ext"; do
                    [[ -e "$file" ]] && FFMPEG_LIST+=("$file")
                done
            done

            for ext in "${MAGICK_SUPPORTED[@]}"; do
                for file in *."$ext"; do
                    [[ -e "$file" ]] && MAGICK_LIST+=("$file")
                done
            done
        ;;
        "recursive")
            for ext in "${FFMPEG_SUPPORTED[@]}"; do
                while IFS= read -r -d '' file; do
                    FFMPEG_LIST+=("$file")
                done < <(find . -type f -iname "*.${ext}" -print0)
            done

            for ext in "${MAGICK_SUPPORTED[@]}"; do
                while IFS= read -r -d '' file; do
                    MAGICK_LIST+=("$file")
                done < <(find . -type f -iname "*.${ext}" -print0)
            done
        ;;
    esac

    local video_len="${#FFMPEG_LIST[@]}";
    local photo_len="${#MAGICK_LIST[@]}";

    echo "Working on $video_len video(s) and $photo_len photo(s)...";

    if [[ "$photo_len" > 0 ]]; then
        local counter=1
        for item in "${MAGICK_LIST[@]}"; do
            printf "Working on $item ($counter of $photo_len)...\n"

            COMMAND=( magick "$item" -quality "$jpg_cq%" "$item"_conv.jpg );

            echo -ne "[--------------------------------------------------] 0.00% - $item @ Q=$jpg_cq%   \r"

            #echo "Command: ${COMMAND[@]}";

            "${COMMAND[@]}" 2>/dev/null

            echo -e  "[##################################################] 100.00% - $item @ Q=$jpg_cq%   "

            mv "$item" "$trash_path/"

            counter=$((counter + 1))
        done
    fi
    if [[ "$video_len" > 0 ]]; then
        local counter=1
        for item in "${FFMPEG_LIST[@]}"; do
            printf "Working on $item ($counter of $video_len)...\n"

            COMMAND=(ffmpeg "${CMD_FFMPEG_BEG[@]}" "$item" "${CMD_FFMPEG_END[@]}" "$item"_conv."$vid_ext")

            DURATION_MS=$(get_duration_ms "$item")

            #echo "Command: ${COMMAND[@]}";

            "${COMMAND[@]}" 2>/dev/null | print_progress "$DURATION_MS" "$item" "$vid_cq" "$vid_sc"
            mv "$item" "$trash_path/"

            counter=$((counter + 1))
        done

    fi
}

automatic_sort() {
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
        fi
    done
}

case "$1" in
    "minessh")
        ssh -i "$MINECRAFT_KEY_FILE_PATH" "$MINECRAFT_CONNECTION_ADDR"
    ;;
#    "minessh_transfer")
#        scp -i "$MINECRAFT_KEY_FILE_PATH" "$2" "$MINECRAFT_CONNECTION_ADDR":"$3/$2"
#    ;;
    "minessh_mount")
        mkdir -p /media/lohk/AzureMinecraftHost
        sshfs -o IdentityFile="$MINECRAFT_KEY_FILE_PATH" "$MINECRAFT_CONNECTION_ADDR":/home/lohk /media/lohk/AzureMinecraftHost
    ;;
    "convert")
        generic_convert "$2" "$3" "$4";
    ;;
    "sort_samsung")
        automatic_sort;
    ;;
    *)
        echo "Try one of the following:";
        echo "- minessh: Connect to Minecraft VPN though SSH";
#        echo "- minessh_transfer: Transfer file to Minecraft VPN though SSH";
        echo "- minessh_mount: Mounts Minecraft VPN to /media folder";
        echo "- convert <compress, compresshq, edit, log2rec709, log2prores> <file, folder, recursive> <file?>: Convert anything";
        echo "- sort_samsung: sorts ALL files to folders.";
    ;;
esac
