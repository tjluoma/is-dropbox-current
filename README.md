is-dropbox-current
==================

Checks to see if your locally installed copy of Dropbox is the same as the official release

### The Problem ###

Dropbox is supposed to update itself 'automagically' but sometimes the 'magic' is a bit… um… well, do you remember Ron Weasley in his first year at Hogwarts? It's like sort of like that.

### The Solution ###

Have your computer check periodically to see if you are up-to-date, by comparing the version installed on your Mac vs the version that is offered on Dropbox.com.

If they are identical, hurray.

If not, let the user know.

If Dropbox isn't even installed (oops!) let the user know that too.

### "Ok, but how?" ###

1.	A shell script (naturally) saved somewhere in your $PATH, which you can then either run yourself in Terminal, or run automatically via `launchd`

2.	A `launchd` plist which will tell `launchd` to run the check every so often. (Optional, but recommended.)

### Requirements ###

If you are not going to use launchd, you can just run the shell script from Terminal.app anytime, and you do not need either Growl or terminal-notifier.

If you are going to use launchd, you will need some way for the script to communicate with you: 

* If you are on Mac OS X 10.8 (Mountain Lion) or later, you can use [terminal-notifier][1]. The script will check for the terminal-notifier.app to be installed in /Applications/ or the terminal-notifier program to be installed at /usr/local/bin/terminal-notifier. *(Hint: if you have Xcode installed and use [Homebrew](http://mxcl.github.com/homebrew/), you can just do `brew install terminal-notifier`)*

* If you are on earlier versions of Mac OS X, you can use [Growl], ***but only if*** you also have [growlnotify] installed. *(And, obviously, Growl needs to be running for you to get the notifications.)*

### "What happens if I have both terminal-notifier *and* growlnotify installed?" ###

Growl notifications will show the Dropbox icon, which looks nicer. But terminal-notifier can actually launch the URL to download the latest version of Dropbox if your version is outdated. For that reason, **the script will opt to use terminal-notifier** if it finds both commands on your Mac.

### "How do I install this?" ###

1. Download the shell script and put it somewhere in your $PATH such as /usr/local/bin/is-dropbox-current.sh 

2. Make sure it is executable by running this command in Terminal: `chmod 755 /usr/local/bin/is-dropbox-current.sh`

3. If you want to use launchd:
	* Download **com.tjluoma.is-dropbox-current.plist** and save it to `~/Library/LaunchAgents/`
	* Run this command in Terminal.app: `launchctl load ~/Library/LaunchAgents/com.tjluoma.is-dropbox-current.plist`

Note that by default the script will run once a day at 3:00 p.m. local time. You can change that by editing the plist. I highly recommend [LaunchControl][2] for working with launchd. [Lingon] is also very good, and might be a little more "user friendly" if you are not familiar with launchd. Remember to reload the plist after making any changes.


[Lingon]: http://www.peterborgapps.com/lingon/

[growlnotify]: http://growl.info/downloads

[Growl]: https://itunes.apple.com/app/growl/id467939042

[1]: https://github.com/alloy/terminal-notifier

[2]: http://www.soma-zone.com/LaunchControl/
