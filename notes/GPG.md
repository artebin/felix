# GNU Privacy Guard

## Generate the key
	gpg --full-gen-key

## List
gpg --list-keys

## Backup and restore

### The items to backup:
* private key (it contains the public key)
* ownertrust

### Export private keys
	gpg --armor --export-secret-keys ${ID} > ${ID}.private-key.asc

### Export ownertrust
	gpg --export-ownertrust >otrust.txt

### Import keys and trustdb
	gpg --import ${ID}.private-key.asc
	gpg --import-ownertrust otrust.txt

## Export public keys
	gpg --armor -export ${ID} > ${ID}.public-key.asc

### Sign public key file
	gpg --sign public_key.asc
