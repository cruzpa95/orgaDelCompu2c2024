#### Script's tree description

##### Complete installation (with OS and ARCH detection)
```
install-ubuntu.sh
 |_ install.sh $OS $ARCH
```

##### Complete installation and run
```
install-and-run.sh $OS $ARCH
 |_ install.sh $OS $ARCH
 |_ first-run.sh
```

##### Complete installation (fixing possibly dependency errors)
```
install-save.sh $OS $ARCH
 |_ install.sh $OS $ARCH
 |_ sudo dpkg --configure -a ##### Fix depency errors during installation
```

##### Complete installation
```
install.sh $OS $ARCH
  |_ mono-downloader-ubuntu-$OS.sh
  |_ mono-installer.sh
  |_ edit-armsim-files.sh $ARCH
```

##### Install dependencies for mono on Ubuntu 16
```
mono-downloader-ubuntu-16.sh
```

##### Install dependencies for mono on Ubuntu 18
```
mono-downloader-ubuntu-18.sh
```

##### Edit and move files
```
edit-armsim-files.sh $ARCH
```

##### Parameters
* $OS: Ubuntu distribution (values: 16 | 18)
* $ARCH: Architecture (values: 32 | 64)
