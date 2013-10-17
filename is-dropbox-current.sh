#!/bin/zsh
# Purpose: check to see if the installed version of Dropbox is the same as the official version
#
# From:	Tj Luo.ma
# Mail:	luomat at gmail dot com
# Web: 	http://RhymesWithDiploma.com
# Date:	2013-10-17

NAME="$0:t:r"

HUSHFILE="$HOME/.hush-$NAME"

if [ -x /Applications/terminal-notifier.app/Contents/MacOS/terminal-notifier -o -x /usr/local/bin/terminal-notifier ]
then

	function is_notinstalled {

		terminal-notifier -message "Click to download latest version" -title "Dropbox is Not Installed " -subtitle "From $NAME" -open 'https://www.dropbox.com/downloading?os=mac'

		exit 0
	}

	function is_current {

		if [ -e "$HUSHFILE" ]
		then
				# if this file exists, then we don't send an alert when Dropbox is up-to-date

				zmodload zsh/datetime

				timestamp () {
					strftime "%Y-%m-%d--%H.%M.%S" "$EPOCHSECONDS"
				}

				echo "$NAME: Dropbox is current as of `timestamp`" >>| "$HUSHFILE"

				exit 0

		else

				terminal-notifier -message "Click to disable future 'Up-To-Date' alerts" -title "Dropbox is Up-To-Date ($INSTALLED_VERSION)" -subtitle "From $NAME" -execute "/usr/bin/touch ${HUSHFILE}"

				exit 0
		fi
	}

	function is_outdated  {
		terminal-notifier -message "Click to download version $CURRENT_VERSION" -title "Dropbox $INSTALLED_VERSION is outdated." -subtitle "From $NAME" -open 'https://www.dropbox.com/downloading?os=mac'

		exit 0

	}

elif (( $+commands[growlnotify] ))
then

	function is_notinstalled {

		growlnotify  \
			--appIcon "Terminal"  \
			--identifier "$NAME"  \
			--message "Dropbox is not installed!"  \
			--title "$NAME"

		exit 0

	}

	function is_current {

		if [ -e "$HUSHFILE" ]
		then
				# if this file exists, then we don't send an alert when Dropbox is up-to-date

				zmodload zsh/datetime

				timestamp () {
					strftime "%Y-%m-%d--%H.%M.%S" "$EPOCHSECONDS"
				}

				echo "$NAME: Dropbox is current as of `timestamp`" >>| "$HUSHFILE"

				exit 0

		else

				growlnotify  \
					--appIcon "Dropbox"  \
					--identifier "$NAME"  \
					--message "Create a file at '$HUSHFILE' to disable future Up-To-Date messages."  \
					--title "Dropbox is Up-To-Date"

				exit 0
		fi
	}

	function is_outdated  {

		growlnotify  \
			--sticky \
			--appIcon "Dropbox"  \
			--identifier "$NAME"  \
			--message "Go to http://dropbox.com/install to get the latest version."  \
			--title "Dropbox $INSTALLED_VERSION is outdated"

	}

else

	function is_notinstalled {
								echo "$NAME: Dropbox is not installed. Go to  http://dropbox.com/install to get the latest version."
								exit
							}
	function is_current {
								echo "$NAME: Dropbox is Up-To-Date ($INSTALLED_VERSION)"
								exit
						}

	function is_outdated  {
								echo "$NAME: Dropbox is outdated. Go to http://dropbox.com/install to get the latest version."
								exit
						}

fi


####|####|####|####|####|####|####|####|####|####|####|####|####|####|####
#
#		This is where we actually start checking things
#



INSTALLED_VERSION=$(fgrep -A1 CFBundleShortVersionString /Applications/Dropbox.app/Contents/Info.plist 2>/dev/null | tr -dc '[0-9].')


if [[ "$INSTALLED_VERSION" == "" ]]
then
		is_notinstalled
		exit
fi

# If we get this far, we have a locally installed version, now we just need to compare it to the official version

UA_SAFARI='Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_7; en-us) AppleWebKit/533.21.1 (KHTML, like Gecko) Version/5.0.5 Safari/533.21.1'

CURRENT_VERSION=$(curl -sL -A "$UA_SAFARI" 'https://www.dropbox.com/install' |\
					fgrep '<span id="version_str">' |\
					sed 's#.*<span id="version_str">##g ; s# .*##g' |\
					tr -dc '[0-9].')

	# http://bashscripts.org/forum/viewtopic.php?f=16&t=1248
function version { echo "$@" | awk -F. '{ printf("17%03d%03d%03d\n", $1,$2,$3,$4); }'; }

if [ $(version ${CURRENT_VERSION}) -gt $(version ${INSTALLED_VERSION}) ]
then
			# Update Needed
		is_outdated
else
			# No Update Needed
		is_current
fi



exit
#
#EOF
