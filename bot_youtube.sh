#!/bin/bash
#Set temp file location
bot_files="/home/admin/projects/discord_bots/youtube"
#Collect all required channels
channels=$(sqlite3 /home/admin/projects/discord_bots/hooks.db "select subreddit from clients where source = 'youtube' and enabled = 'yes';")
for channel in ${channels[@]}; do
        #Collect hooks that need this subreddit
        hooks=$(sqlite3 /home/admin/projects/discord_bots/hooks.db "select discord_webhook from clients where subreddit = '$channel' and enabled = 'yes';")
        #Make cache directories/files
        for hook in ${hooks[@]}; do
                #Parse out discord hook ID (without all the URL detail) for directory creation
                hook_only=$(echo $hook | grep -Eo "webhooks/[a-zA-Z0-9./?=_%:-]*" | sed 's|webhooks/||g' | sed 's|/|--|')
                #Create hook directories
                if [ ! -d "$bot_files/$hook_only" ]
                then
                        mkdir $bot_files/$hook_only
                fi
                #Create channel directories within hook directories
                if [ ! -d "$bot_files/$hook_only/$channel" ]
                then
                        mkdir $bot_files/$hook_only/$channel
                fi
                #Make usedurls cache if doesn't exist
                if [ ! -d "$bot_files/$hook_only/usedurls" ] 
                then
                        touch $bot_files/$hook_only/usedurls
                fi
        done
        #Pull and isolate latest dump
        wget -L "https://www.youtube.com/feeds/videos.xml?channel_id=$channel" -O $bot_files/$hook_only/$channel/dump
        #Parse out Video ID's and dump them into urlcache
        cat $bot_files/$hook_only/$channel/dump | grep -Eo "<yt:videoId>[a-zA-Z0-9./?=_%:-]*</yt:videoId>" | sed 's|<yt:videoId>||g' | sed 's|</yt:videoId>||g' | uniq > $bot_files/$hook_only/$channel/urlcache     
        #Build full url var
        url="https://www.youtube.com/watch?v=$(head -n 1 $bot_files/$hook_only/$channel/urlcache)"
        #Dump latest video from each source into each listed discord webhook (URL array at top)
#       for hook in ${hooks[@]}; do
                        if ! grep -q "$url" $bot_files/$hook_only/usedurls; then #if url is not found in usedurls
                                curl -d "{\"content\": \"$url$addstr\"}" -H "Content-Type: application/json" "$hook" #dump link into discord webhook
                                (echo "$url" && cat $bot_files/$hook_only/usedurls) > $bot_files/$hook_only/usedurls.temp && mv $bot_files/$hook_only/usedurls.temp $bot_files/$hook_only/usedurls #update usedurls  
                        fi
#       done #Close main for loop
#Make sure our used url cache never exceeds 100 lines (Disk space saver)
#while [[ $(cat $bot_files/$hook_only/usedurls | wc -l) > 100 ]] #While usedurls has more than 100 lines
#do
#       sed -i '$ d' $bot_files/$hook_only/usedurls #Remove last line in file
#done #Close url cache cleaning while loop
done
