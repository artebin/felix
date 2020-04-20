# Command Line Sheet Cheat

## OS and services

* Identify Linux distribution with file `/etc/os-release`

* Set the clock:
    * Enable/disable synchonization of the machine clock with NTP: `timedatectl set-ntp no`
    * Set machine clock: `timedatectl set-time '2020-03-13 23:59:00'`

## Terminal

* List files in column: `ls -1`

* Show the command arguments in ps: `ps -f -u ${USER}`

* List sockets created by pid number: `ss -l -p -n | grep "pid=${PID},"`

* Removing an old SSH key: `ssh-keygen -R [HOSTNAME|ADDRESS]`

## File Processing

* Create a 7z archive with password: `7z a <ARCHIVE_FILE> <FILE_TO_INCLUDE> -p <PASSWORD>`

## CVS

* Mark missing files in a subversion project as deleted: `svn st | grep ^! | awk '{print " --force "$2}' | xargs svn rm`

* Revert to base revision one file in a git project: `git checkout -- FILE`

## Convert values

* Convert value from base 16 to base 2: `echo 'obase=2;ibase=16;3F'|bc`

* Extract time duration with dateutils: `dateutils.ddiff 08:31:10 08:32:26 -f"%H:%M:%S"`

* Seconds to hours: `date -d@48480 -u +%H:%M:%S`

## Miscellaneous

* Extract a mp3 from a youtube video URL: `youtube-dl --extract-audio --audio-format mp3 VIDEO_URL`
