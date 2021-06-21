# Nubango

Nubango is an iTunes-compatible Kerbango radio tuning server/proxy.

Certain old iTunes versions like v4.x and below are no longer able to download any internet radio stations because they are using bad query strings in their HTTP requests; such old versions fail to download the Kerbango XML they need from the Apple/Kerbango Radio Tuning Service. To get things working again, iTunes can be made to communicate with Nubango instead of Kerbango.

To get iTunes to load radio stations from Nubango you must redirect iTunes' HTTP requests to a Nubango server (locally or remotely), which can serve a locally-hosted XML station catalog.

## :construction: *Project Status: Experimental*

:warning: "Experimental" means two things: ~~Here be dragons~~ Nubango may cause damage to your system if you attempt to use it, because at-present it is mostly untested.

The charts below both represent someone's past, someone's future, someone's blood, sweat, and tears. They're not crystal balls, but they can tell you which iTunes versions work with Nubango, which operating systems can host Nubango, and how far along the project is for each use-case.

### :bomb: OS Compatibility Chart

| Operating System | Compatibility Status | Project Status |
| --- | --- | --- |
| Windows 10 | Untested | 0% |
| Linux (Debian) | Untested | 0% |
| Linux (RedHat) | Untested | 0% |
| Mac OS X 10.4.11 | **OK** | 100% |
| Mac OS X 10.3.9 | Untested | 0% |
| Mac OS X 10.2.8 | Untested | 0% |
| Mac OS X 10.1.5 | Untested | 0% |
| Mac OS X 10.0.4 | Untested | 0% |
| Mac OS 9.2.2 | Testing | 50% |
| Mac OS 8.6 | Untested | 0% |

*Other systems might be added later...*

### :bomb: iTunes Compatibility Chart

| iTunes Version | Compatibility Status | Project Status |
| --- | --- | --- |
| 9.x | **OK** | 100% |
| 8.x | Testing | 50% |
| 7.x | Testing | 50% |
| 6.x | Testing | 50% |
| 5.x | **OK** | 100% |
| 4.x | **OK** | 100% |
| 3.x | **OK** | 100% |
| 2.x | **OK** | 100% |
| 1.x | **OK** | 100% |

## :wrench: How-To Patch / Install

- To patch an iTunes binary such that it is redirected to localhost, run the included `patcher.sh` installation script in Terminal. Nubango must already be running on the same system.
- To self-host Nubango on Mac OS X 10.4, run the included `install.sh` installation script and then enable "Personal Web Sharing".
	- Open http://127.0.0.1 and http://127.0.0.1/xml/index.xml in your web browser to ensure that the HTTP server is working properly.
- There are also several useful *DIY Installation* steps below which take advantage of system-level hacks rather than patching the iTunes binary.

### Option 1: Patching iTunes Binaries

`patcher.sh` does a simple string replacement on an iTunes binary executable, replacing all instances of `pri.kts-af.net` with `localhost`; running it in Terminal will present an "Open File" dialog in which you will be asked to select an iTunes application for patching. The old application binary is stored within `iTunes.app/Contents/MacOS/iTunes.old`, just in case you would like to undo the hack later.

Pre-patched binaries may be made available at a later date!

### Option 2: DIY Installation

*For experienced users only. You risk damaging your system. Please read the included MIT "LICENSE" document.*

#### Editing your `hosts` file:

You also can do this instead of patching iTunes directly.

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

#### Self-hosting with Apache/CGI:

1. Copy the included directory `xml` into  `/Library/WebServer/Documents`
2. Add this `RewriteRule` to the bottom of `/etc/httpd/httpd.conf`:

```
RewriteRule "^/xml/index\.xml$" "/cgi-bin/streamingRadioStations.sh" [PT]"
```

3. Copy the included file `cgi-bin/streamingRadioStations.sh` into the directory `/Library/WebServer/CGI-Executables`
4. Make the file `streamingRadioStations.sh` executable:

```
chmod +x /Library/WebServer/CGI-Executables/streamingRadioStations.sh
```

5. Ensure that "Personal Web Sharing" is enabled in *System Preferences > Internet & Network > Services > Sharing*
6. Open http://127.0.0.1 and http://127.0.0.1/xml/index.xml in your web browser to ensure that the HTTP server is working properly.