# OpenTX custom sounds

For macOS/OS X. Uses `say` command for speech synthesis and `sox` for conversion of your own custom sounds for use by OpenTX 2.2.x.

Currently English only. Currently expects to be run from a sibling directory to your `SD structure` directory. Will eventually add ability to provide a destination directory.

Edit sound configuration files by providing a six character name (a-z, dashes) and the text to be read separated by a tab character:

```
fm-ang	Angle mode
fm-hor	Horizon mode
...
```

The `system.txt` configuration file is for sounds to be placed in the system folder, meaning they should have the same name as and will overwrite an existing system sound. Otherwise it won't be usable.

## Usage

Download and install `sox`.

Navigate to this directory. Provide `-p` argument to play the sounds whilst creating them, and `-v` argument to use a specific voice (Karen is default):

```
$ ./generate.sh
$ ./generate.sh -p
$ ./generate.sh -v Daniel
$ ./generate.sh -p -v Kate
```
