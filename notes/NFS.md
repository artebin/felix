# NFS

## Documentation

  * <https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/4/html/reference_guide/s2-nfs-client-config-options>
  * <https://wiki.archlinux.org/title/NFS>
  * <https://cromwell-intl.com/open-source/performance-tuning/nfs.html>
  * <https://docstore.mik.ua/orelly/networking_2ndEd/nfs/ch16_04.htm>

## Mount parameters

### /etc/fstab

`<IP_OR_HOSTNAME>:/<SHARED_DIRECTORY> <MOUNT_POINT> nfs noauto,users,rw,atime,nosuid,noexec,nodev,bg,comment=x-gvfs-show 0 0`

### AutoFS

`<MOUNT_POINT> -users,rw,sync,soft,rsize=32768,wsize=32768,intr,timeo=60,retrans=2,nosuid,noexec,nodev,noatime,nolock,bg <IP_OR_HOSTNAME>:<SHARED_DIRECTORY>`

## Tools

  * Show mount points with their flags including the version of NFS used: `nfsstat -m`

## Improve NFS server performance

  * Configuration files on Debian/Ubuntu is in `/etc/default`
  * Increase the number of threads in `/etc/default/nfs-kernel-server`
