# Command Line Sheet Cheat

* List files in column: `ls -1`

* Show the command arguments in ps: `ps -f -u ${USER}`

* List sockets created by pid number: `ss -l -p -n | grep "pid=${PID},"`

* Mark missing files in a subversion project as deleted: `svn st | grep ^! | awk '{print " --force "$2}' | xargs svn rm`

* Revert to base revision one file in a git project: `git checkout -- FILE`

* Removing an old SSH key: `ssh-keygen -R [HOSTNAME|ADDRESS]`

* Set the clock:
    * Enable/disable synchonization of the machine clock with NTP: `timedatectl set-ntp no`
    * Set machine clock: `timedatectl set-time 23:59:00`


* Extract a mp3 from a youtube video URL: `youtube-dl --extract-audio --audio-format mp3 VIDEO_URL`
