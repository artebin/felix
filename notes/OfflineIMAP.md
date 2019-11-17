# Offline IMAP

## Configuration file

	# Sample minimal config file.  Copy this to ~/.offlineimaprc and edit to
	# get started fast.
	
	[general]
	accounts = nicolas.james@gmail.com
	
	[Account nicolas.james@gmail.com]
	localrepository = Local
	remoterepository = Remote
	
	[Repository Local]
	type = Maildir
	localfolders = ~/Mail
	
	[Repository Remote]
	type = IMAP
	remotehost = imap.gmail.com
	remoteuser = nicolas.james@gmail.com
	sslcacertfile = /etc/ssl/certs/ca-certificates.crt
	ssl_version = tls1_2
