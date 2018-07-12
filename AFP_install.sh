#!/bin/bash

# Setting for elinks
# set protocol.http.user_agent = "User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:48.0) Gecko/20100101 Firefox/48.0"
# Address for any language file
# protocol://user:password@www.example.org:port/folder/filename.extension?query=value
#
# JS file set options
# navigator.appCodeName="Mozilla" + navigator.appName + navigator.appVersion + ""
# + navigator.cookieEnabled + navigator.platform + navigator.userAgent 

echo -e "
Hello, I am a *nix universal Adobe flash player installer for any distribution.

First, I will get the version from the 'libflashplayer.so' library file and check it with current Adobe site release.
"

local_Adobe_version=$(sudo find /usr/ -iname "libflashplayer.so" -exec readelf -a {} \; | egrep -i "FlashPlayer*" | gawk '{print $NF}' | sed -e 's/FlashPlayer_//; s/_/./g; s/.$//; s/\.F//')
Adobe_Site_version=$(cat <(elinks -dump -no-references https://get.adobe.com/flashplayer) | grep Version | tr -d [:alpha:][:space:])


if [[ $Local_Adobe_version: = $Adobe_Site_version ]]; then

	echo -e "\033[32mYou have the current  version installed.\033[0m
	
Local Adobe version: $local_Adobe_version
Adobe Site version:  $Adobe_Site_version	
"	exit
else
	echo -e "\033[5;31mYou DO NOT have the current version installed.\033[0m
	
Local Adobe version: $local_Adobe_version
Adobe Site version:  $Adobe_Site_version	
"

	echo Cleaning old files.	
	echo

	rm -vf libflashplayer.so
	rm -vfr usr
	rm -vfr LGPL
	rm -vf readme.txt
	rm -vf *.tar.gz
	echo "Downloading latest version of Flash player in 'tar.gz' format. "
	#elinks -dump -no-references https://get.adobe.com/flashplayer/download/?installer=Flash_Player_11.2_for_other_Linux_(.tar.gz)_64-bit&standalone=1	
#	wget https://fpdownload.adobe.com/get/flashplayer/pdc/$Adobe_Site_version/flash_player_npapi_linux.x86_64.tar.gz

curl --header 'Host: fpdownload.adobe.com' --header 'User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:49.0) Gecko/20100101 Firefox/49.0' --header 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' --header 'Accept-Language: en-US,en;q=0.5' --header 'DNT: 1' --header 'Connection: keep-alive' --header 'Upgrade-Insecure-Requests: 1' https://fpdownload.adobe.com/get/flashplayer/pdc/$Adobe_Site_version/flash_player_npapi_linux.x86_64.tar.gz -o 'flash_player_npapi_linux.x86_64.tar.gz' -L

	echo "Now, I will unpack the Adobe compressed file."
	echo
	echo "tar xf *.tar.gz"

	tar xf *.tar.gz

	echo

fi


echo -e "
Next, I will find your plug-in directories and copy Flash Player library there.
"

PlugDir=$(sudo find /usr/ -iname "libflashplayer.so"| egrep -i "mozilla|plugin*" | sed -e 's/\<libflashplayer.so\>//g')

echo -e "
Returned: $PlugDir

All browsers will use /usr directory so no point in this universal search on all storage.

Installing to $PlugDir"


sudo cp -vf libflashplayer.so $PlugDir

sudo cp -vfr usr/* /usr

echo -e "
Done.
Restart your browser...
Cleaning files...
"

rm -vf libflashplayer.so
rm -vfr usr
rm -vfr LGPL
rm -vf readme.txt
rm -vf $(ls | egrep -i "*install*|*flash*|*player*|*linux*" | egrep -i "*.tar.gz|*.tar.bz2|*.tar") 

echo "Done."
echo



exit 0



