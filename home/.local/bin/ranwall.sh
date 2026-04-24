#!/bin/bash
WALLPAPER_DIRECTORY=$HOME/Pictures/walls/
WALLPAPER_SUB_DIRECTORY=""
WALLPAPER="/usr/share/hypr/wall2.png"
SHORT_OPTS=c,r,u,m:,s:,h,i,l:,d:,f:
LONG_OPTS=cron,run,update,main-path:,sub-path:,help,install,lifespan:,device:,from:

MONITOR_DEVICE="eDP-1"
GIT_WALLPAPERS_REPOSITORY="https://github.com/dharmx/walls"
WALLPAPER_LIFESPAN=600
IS_SIMPLE_RUN=0
IS_SHOW_HELP=0
IS_INSTALL=0
IS_UPDATE=0
IS_CRON=0
IS_NO_ARGUMENT=1

# Function
usage() {
  cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Options:
  -c, --cron                Run in cron mode (change wallpaper periodically)
  -r, --run                 Simple run: pick and set one wallpaper (default)
  -u, --update              Update wallpapers (git repository only)
  -m, --main-path DIR       Set main wallpaper directory (default: $HOME/Pictures/walls/)
  -s, --sub-path DIR        Set subdirectory within main path
  -h, --help                Show this help message and exit
  -i, --install             Clone wallpaper repository into main path (git repository only)
  -l, --lifespan SEC        Set change interval in seconds (default: $WALLPAPER_LIFESPAN)
  -d, --device NAME         Set target monitor device (default: $MONITOR_DEVICE)
  -f, --from URL            Set custom git repository URL (default: $GIT_WALLPAPERS_REPOSITORY)

Examples:
  $(basename "$0") -r
      # Pick and set one random wallpaper

  $(basename "$0") -c -l 300
      # Run in cron mode with 5-minute interval (300 seconds)

  $(basename "$0") -i -f https://github.com/dharmx/walls
      # Install wallpapers from a custom repository

  $(basename "$0") -m "$HOME/Pictures/walls" -s "anime" -r
      # Pick one wallpaper from the 'anime' subdirectory
EOF
}

choose_wallpaper() {
  local dir="$WALLPAPER_DIRECTORY$WALLPAPER_SUB_DIRECTORY"
  if [[ ! -d "$dir" ]];then
    echo "Error: Cannot access directory '$dir'" >&2
    return 1
  fi
  
  local wallpaper
  wallpaper=$(find "$dir" -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.jxl' -o -iname '*.webp' \) -print0 2>/dev/null | shuf -z -n 1 | tr -d '\0')
  
  if [[ -z "$wallpaper" ]]; then
    echo "Error: No supported wallpapers found in '$dir'" >&2
    return 1
  fi
  printf '%s' "$wallpaper"
}

change_wallpaper() {
  if [[ -z "$WALLPAPER" ]]; then
    echo "Error: Invalid or missing wallpaper path: '$WALLPAPER'" >&2
    return 1
  fi

  hyprctl hyprpaper wallpaper "$MONITOR_DEVICE,$WALLPAPER"
  hyprctl hyprpaper unload unused
}

wallpaper_cron() {
  while true; do
    WALLPAPER=$(choose_wallpaper)
    change_wallpaper
    echo "sleep $WALLPAPER_LIFESPAN" >> /tmp/ranwall.txt
    sleep $WALLPAPER_LIFESPAN
  done
}

update_walls() {
  if [[ ! -d "$WALLPAPER_DIRECTORY/.git" ]]; then
    echo "Error: '$WALLPAPER_DIRECTORY' is not a git repository" >&2
    exit 1
  fi
  echo "Updating wallpapers from repository..."
  (cd "$WALLPAPER_DIRECTORY" && git pull) || {
    echo "Warning: Failed to update repository" >&2
  }
}

install_wallpapers_repository() {
  if [[ -e "$WALLPAPER_DIRECTORY" ]]; then
    echo "Error: '$WALLPAPER_DIRECTORY' already exists. Remove it or use --update" >&2
    return 1
  fi

  echo "Cloning repository: $GIT_WALLPAPERS_REPOSITORY to $WALLPAPER_DIRECTORY"
  git clone "$GIT_WALLPAPERS_REPOSITORY" "$WALLPAPER_DIRECTORY" || {
    echo "Error: Failed to clone repository. Check URL and network" >&2
    exit 1
  }
  update_walls
}

# Main script
OPTIONS=$(getopt -o $SHORT_OPTS --long $LONG_OPTS -- "$@")

if [[ $? -ne 0 ]]; then
  echo "Error: Invalid option provided" >&2
  exit 1
fi

eval set -- "$OPTIONS"

if [[ $# -eq 1 ]]; then
  IS_NO_ARGUMENT=1
else
  IS_NO_ARGUMENT=0
fi

while true;do 
  case $1 in
    -c|--cron)
      IS_CRON=1
      shift
      ;;
    -r|--run)
      IS_SIMPLE_RUN=1
      shift
      ;;
    -u|--update)
      IS_UPDATE=1 
      shift
      ;;
    -m|--main-path)
      WALLPAPER_DIRECTORY="${2%/}/"
      shift 2
      ;;
    -s|--sub-path)
      WALLPAPER_SUB_DIRECTORY="${2%/}/"
      shift 2
      ;;
    -h|--help)
      IS_SHOW_HELP=1 
      shift
      ;;
    -i|--install)
      IS_INSTALL=1
      shift
      ;;
    -l|--lifespan)
      if ! [[ "$2" =~ ^[0-9]+$ ]] || [[ "$2" -le 0 ]]; then
        echo "Error: --lifespan must be a positive integer" >&2
        exit 1
      fi
      WALLPAPER_LIFESPAN="$2"
      shift 2
      ;;
    -d|--device)
      MONITOR_DEVICE="$2"
      shift 2
      ;;
    -f|--from)
      GIT_WALLPAPERS_REPOSITORY="$2"
      shift 2
      ;;
    --)
      shift
      break
      ;;
    *)
      echo "Error: Unknown option: $1" >&2
      exit 1
      ;;
  esac
done


if [[ $IS_SHOW_HELP -eq 1 ]]; then
  usage
  exit
fi

if [[ $IS_INSTALL -eq 1 ]]; then
  install_wallpapers_repository
fi

if [[ $IS_SIMPLE_RUN -eq 1 || $IS_NO_ARGUMENT -eq 1 ]]; then
  WALLPAPER=$(choose_wallpaper)
  change_wallpaper
fi

if [[ $IS_UPDATE -eq 1 ]]; then
  update_walls
fi


if [[ $IS_CRON -eq 1 ]]; then
  wallpaper_cron
fi
