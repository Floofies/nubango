#!/bin/sh
#Nubango Radio Tuner Service Installer
echo "The Nubango Radio Tuner Service Installer patches critical system files."
echo "Per the MIT license of this program, the authors are not liable for any resulting damage to your system. Proceed at your own risk!"
echo "Press the 'I' key to install Nubango on your system.Press any other key to cancel."
read -rsn1 k
if [[ $k = "i" ]] ; then
[ "$UID" -eq 0 ] || { echo "This script must be run as root."; exit 1;}
echo "*----- Beginning installation..."
echo "**---- Copying Nubango webroot to /Library/WebServer ..."
nubangoDir="${0%/*}"
cp "$nubangoDir"/cgi-bin/streamingRadioStations.sh /Library/WebServer/CGI-Executables/streamingRadioStations.sh
chmod +x /Library/WebServer/CGI-Executables/streamingRadioStations.sh
chown root:admin /Library/WebServer/CGI-Executables/streamingRadioStations.sh
mkdir /Library/WebServer/Documents/xml
cp -r "$nubangoDir"/xml /Library/WebServer/Documents/
chown -R root:admin /Library/WebServer/Documents/xml
echo "****-- Adding new RewriteRule to /etc/httpd/httpd.conf ..."
if ! cat /etc/httpd/httpd.conf | grep -q "streamingRadioStations\.sh"; then
	echo "RewriteRule \"^/xml/index\.xml$\" \"/cgi-bin/streamingRadioStations.sh\" [PT]" >> /etc/httpd/httpd.conf
fi
echo "*****- Starting/Restarting Apache HTTP server..."
apachectl restart
echo "****** Nubango installation complete. Verify that port 80 is open at: http://127.0.0.1"
exit 0
else
	exit 125
fi