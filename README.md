# Summary
This bot is fully written in linux shell (`.sh scripting`) and will run natively on most systems. Developed and running on a RaspberryPI and has been feeding discord servers for over a year. The only dependency that is in place is using sqlite by preference, although you can tweak the code to simply store your servers/webhooks in a text file if you'd rather not install sqlite.

# Can I see the bot in action?
Yea, the bot is currently feeding many servers, but you can see it in action on my discord server ([DISCORD.D4NG3R.COM](https://discord.d4ng3r.com)) in `SOCIAL > #youtube`

# Usage 
(Under the assumption you installed sqlite and have created a database structured like `DiscordBotDB.png`)
- Ensure you add your discord webhook URL to your sqlite db (See `DiscordBotDB.png`)
- Pull the SH script to your run location (I just run it from user folder `/home/<user>/projects/discord_bots/youtube` but you can run it from anywhere.)
- Set the `hooks` var (line 4) to specify DB/Table/Data selections
- Set the `bot_files` var (line 8), this tells the bot where to cache used URLs
- Set the bot to run however you like. I have it set to run every 5 minutes via CRON (Example below)
-- Cron file: `/etc/cron.d/run_all_discord_bots`
-- Cron file contents: `*/5 * * * * root /home/admin/projects/discord_bots/reddit/bot_youtube.sh`

Also take note that it expects a channels unique identifier. For instance, my youtube channel's identifer would be `UCZV7QVzq3zCyWuA20h7sn6w`, since my YT link is `https://www.youtube.com/channel/UCZV7QVzq3zCyWuA20h7sn6w`. If using sqlite, just put the identifier in the subreddit column.

***NOTE: If using sqlite, see `DiscordBotDB.png` for table structure this bot expects

This bot is still WIP. You'll notice it posts in my discord channel twice for each video, that is because I have it feeding 2 different YT channels into 2 different discord channels. If you're just feeding a single YT channel into a single discord channel you won't have this problem. Its a bug I haven't been able to fix, so if you fix it please let me know and I'll update this.
