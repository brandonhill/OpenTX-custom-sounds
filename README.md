# OpenTX custom sounds

For macOS/OS X. Uses `say` command for speech synthesis and `sox` for conversion of your own custom sounds for use by [OpenTX 2.2.x](http://www.open-tx.org/2017/05/30/opentx-2.2.0). See OpenTX [Audio reference](https://opentx.gitbooks.io/manual-for-opentx-2-2/content/advanced/audio.html).

Sample: [hello.wav](https://github.com/brandonhill/OpenTX-custom-sounds/blob/master/samples/hello.wav).

## Usage

* Using **Terminal.app** navigate to your local OpenTX Companion folder, e.g.:

```
$ cd ~/Documents/RC/Open\ TX
```

* Clone this repository and navigate to local copy:

```
$ git clone git://github.com/brandonhill/OpenTX-custom-sounds.git
$ cd OpenTX-custom-sounds
```

* Open sound configuration files to edit (and save), if desired:

```
$ open custom.txt
$ open system.txt
```

> Expected format is a six character name (a-z, dashes) and the text to be read, separated by a tab character.

> Sounds in `system.txt` should have the same names as and will overwrite existing system sounds or they won't be usable (without editing sound mappings).

* Create your sounds:

```
$ ./generate.sh
```

### Parameters

* **-l**: Specify language code. Default is `en`.
* **-o**: Specify output directory. Default is `../SD structure/SOUNDS`.
* **-p**: Play the sounds while generating them.
* **-v**: Specify voice to use. Default is Karen. Run `say -v '?'` to see available voices.

### Examples

```
$ ./generate.sh
$ ./generate.sh -l fr
$ ./generate.sh -o /Volumes/Taranis\ SD/SOUNDS
$ ./generate.sh -p
$ ./generate.sh -v Daniel
$ ./generate.sh -l de -o ~/Desktop/OpenTX\ Sounds -p -v Kate
```
