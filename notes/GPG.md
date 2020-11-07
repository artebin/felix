# GNU Privacy Guard

## Documentation
* <https://help.ubuntu.com/community/GnuPrivacyGuardHowto>

## Generate the key
	gpg --full-gen-key

## List the keys
* `$gpg --list-keys`
* `$gpg --list-secret-keys`

## Fingerprint
* `$gpg --fingerprint "${ID}"`

## Set the default GPG key
	$export GPGKEY="${DEFAULT_GPG_KEY_ID}"

## Sign files
* `$gpg --armor --sign --output "${FILE}.asc" "${FILE}"`
* For the output containing the signed file plus the signature:
`$gpg --armor --clear-sign --output "${FILE}.asc" "${FILE}"`

## Backup and restore

### The items to backup:
* public key
* private key
* owner trust (trustdb)

## Export the keys and trustdb
	$gpg --armor --export "${ID}" --output "${ID}.public.key.asc"
	$gpg --armor --export-secret-keys "${ID}" --output "${ID}.private.key.asc"
	$gpg --export-ownertrust >ownertrust.txt

### Import the keys and trustdb
	$gpg --import "${ID}.public.key.asc"
	$gpg --import "${ID}.private.key.asc"
	$gpg --import-ownertrust ownertrust.txt

