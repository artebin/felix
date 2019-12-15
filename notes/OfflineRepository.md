## Ubuntu Offline Repository

- create a mirror of the repository with `apt-mirror` (configure `/etc/apt/mirror.list` and execute `apt-mirror`)

- add a sources list in `/etc/apt/sources.list.d/local_mirror.list` with something like the content below:

    	deb [ arch=amd64 ] http://localhost:10001/ubuntu/ bionic main restricted universe multiverse
    	# deb-src [ arch=amd64 ] http://localhost:10001/ubuntu/ bionic main restricted universe multiverse
    	
    	deb [ arch=amd64 ] http://localhost:10001/ubuntu/ bionic-updates main restricted universe multiverse
    	# deb-src [ arch=amd64 ] http://localhost:10001/ubuntu/ bionic-updates main restricted universe multiverse
    	
    	# deb [ arch=amd64 ] http://localhost:10001/ubuntu/ bionic-backports main restricted universe multiverse
    	# deb-src [ arch=amd64 ] http://localhost:10001/ubuntu/ bionic-backports main restricted universe multiverse
    	
    	deb [ arch=amd64 ] http://localhost:10001/ubuntu bionic-security main restricted universe multiverse
    	# deb-src [ arch=amd64 ] http://localhost:10001/ubuntu bionic-security main restricted universe multiverse

- start a http server for the repository, go into `<mirror directory>/mirror/archive.ubuntu.com`

- execute `python -m SimpleHTTPServer 10001`
