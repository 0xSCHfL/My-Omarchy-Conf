#!/bin/sh
# ~/.config/waybar/scripts/uptime-short.sh

s=$(uptime -p | sed 's/^up //')
[ -z "$s" ] && { echo "0m"; exit 0; }

echo "$s" | awk '{
  first=1
  for(i=1;i<=NF;i+=2){
    val=$(i);
    unit=$(i+1);
    gsub(/,$/,"",unit);

    # Format output without leading commas
    if(unit ~ /day/) {
      if (first) { printf "%sd", val; first=0 }
      else { printf ",%sd", val }
    }
    else if(unit ~ /hour/) {
      if (first) { printf "%sh", val; first=0 }
      else { printf ",%sh", val }
    }
    else if(unit ~ /minute/) {
      if (first) { printf "%sm", val; first=0 }
      else { printf ",%sm", val }
    }
  }
  printf "\n"
}'

