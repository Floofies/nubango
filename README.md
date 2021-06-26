# Nubango

Nubango is an iTunes-compatible Kerbango Tuning Service (KTS) server/proxy. Nubango is *really* just one CGI script and some static XML files.

Old iTunes versions like iTunes 8 and below are no longer able to download internet radio station listings from Apple's KTS server. Such old iTunes versions are using bad query strings in their HTTP requests. To get things working again, iTunes can be made to communicate with Nubango instead of Kerbango.

## Patched iTunes Applications

[Pre-patched iTunes apps are now available on the Macintosh Garden!](https://macintoshgarden.org/apps/garden-itunes-nubango-radio-patch)

To get iTunes to load radio stations from Nubango, we must redirect iTunes' HTTP requests to a Nubango server. `patcher.sh` does a simple string replacement on a iTunes binary executable, replacing all instances of `pri.kts-af.net` with `pri.kts-af.org` (which is our dedicated Nubango server). Running the patcher in Terminal will present an "Open File" dialog in which you will be asked to select an iTunes application for patching. The old application binary is stored within `iTunes.app/Contents/MacOS/iTunes.old`, just in case you would like to undo the hack later.

## :construction: *Project Status Disclaimer: Experimental*

:warning: "Experimental" means two things: ~~Here be dragons~~ Nubango may cause damage to your system if you attempt to use it, because at-present it is mostly untested.

**We need your help to improve Nubango for everyone. Please present requests and report any problems by creating a new GitHub issue!**

## How to Self-Host Nubango

*For experienced users only. You risk damaging your system. Please read the included MIT "LICENSE" document.*

### Self-hosting with Apache on Linux

*Tested on Ubuntu 20.04.2*

1. Install Apache 2:

```shell
sudo apt-get update && sudo apt install apache2
```

2. Copy the entire included `xml` directory into the webroot (most likely at) `/var/www/html`
3. Enable the `rewrite` & `cgi` Apache modules:

```shell
sudo a2enmod rewrite cgi
```

4. Add this `RewriteRule` to the the site file (Just before the line `</VirtualHost>`) at `/etc/apache2/sites-enabled/000-default.config`:

```shell
RewriteEngine On
RewriteRule "^/xml/index\.xml$" "/cgi-bin/streamingRadioStations.sh" [H=cgi-script,PT]
```

5. Copy the included CGI script from `cgi-bin/streamingRadioStations.sh` into the directory at `/usr/lib/cgi-bin`
6. Make the file at `/usr/lib/cgi-bin/streamingRadioStations.sh` executable:

```shell
chmod +x /usr/lib/cgi-bin/streamingRadioStations.sh
```

7. Start Apache 2:

```shell
sudo apachectl start
```

8. Open http://127.0.0.1 and http://127.0.0.1/xml/index.xml in a web browser to ensure that the HTTP server is working properly.

### Self-hosting with Apache on Mac OS X 10.4:

*Apache is included and pre-configured with Mac OS X 10.4*

1. Copy the entire included `xml` directory into the webroot at `/Library/WebServer/Documents`
2. Add this `RewriteRule` to the bottom of the file at `/etc/httpd/httpd.conf`:

```shell
RewriteRule "^/xml/index\.xml$" "/cgi-bin/streamingRadioStations.sh" [PT]
```

3. Copy the included CGI script from `cgi-bin/streamingRadioStations.sh` into the directory at `/Library/WebServer/CGI-Executables`
4. Make the file at `/Library/WebServer/CGI-Executables/streamingRadioStations.sh` executable:

```shell
chmod +x /Library/WebServer/CGI-Executables/streamingRadioStations.sh
```

5. Ensure that "Personal Web Sharing" is enabled in *System Preferences > Internet & Network > Services > Sharing*
6. Open http://127.0.0.1 and http://127.0.0.1/xml/index.xml in a web browser to ensure that the HTTP server is working properly.

### Editing your `hosts` file for self-hosting:

To get your iTunes to communicate with your self-hosted Nubango server, you can perform a DNS hack instead of patching.

You can easily replace any of the below IP addresses with the one pointing to your Nubango server.

**For Mac OS X:** Add to the bottom of `/etc/hosts`:

```
127.0.0.1 pri.kts-af.net
::1 pri.kts-af.net
```

**For Mac OS 9:** Add to the bottom of `/System Folder/Preferences/Hosts`:

```
pri.kts-af.net IN A 127.0.0.1
pri.kts-af.net IN AAAA ::1
```