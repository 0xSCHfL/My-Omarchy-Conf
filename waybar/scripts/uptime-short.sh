#!/bin/sh
# ~/.config/waybar/scripts/uptime-short.sh
s=$(uptime -p | sed 's/^up //')
[ -z "$s" ] && { echo "0m"; exit 0; }

echo "$s" | awk '{
  for(i=1;i<=NF;i+=2){
    val=$(i);
    unit=$(i+1);
    gsub(/,$/,"",unit);
    if(unit ~ /day/)    printf "%sd", val;
    else if(unit ~ /hour/)   printf "%sh", val;
    else if(unit ~ /minute/) printf "%sm", val;
  }
}'

