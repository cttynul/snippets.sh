# snippets.sh

Just a couple of bash scripts to make my daily life easier.

---
## dd++

### Introduction
dd is a command-line utility for Unix and Unix-like operating systems whose primary purpose is to convert and copy files. (Wikipedia.org)

dd++ makes using dd easier displaying a progress bar in terminal or dialog mode.

![ddpp](http://i.imgur.com/Ozibx1m.png)

### Usage
`
$ sh ddplusplus.sh Input_File Output_File
`

---
## zzzz.io_watchdog
Update your zzzz.io/or dynamic DNS service with a scheduled script.

## How to use:
1. wget the script
`
https://raw.githubusercontent.com/cttynul/zzzz.io_watchdog/master/watchdog_ip.sh
`
2. insert your zzzz.io url in address in if condition

3. crontab as you wish, i.e. 8 hours:
`
0 */8 * * * /path/to/watchdog_ip.sh
`

4. profit

0. for more check: 
https://www.zzzz.io/faq/

## Special thanks
many thanks to webmasters of:
- https://www.zzzz.io/
- http://ipecho.net

i'm :heart: u.
