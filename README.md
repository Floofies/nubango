# Nubango

Nubango is an iTunes-compatible Kerbango radio tuning server/proxy.

Certain old iTunes versions like v4.x and below are no longer able to download any internet radio stations because they are using bad query strings in their HTTP requests; such old versions fail to download the Kerbango XML they need from the Apple/Kerbango Radio Tuning Service. To get things working again, iTunes can be made to communicate with Nubango instead of Kerbango.

To get iTunes to load radio stations from Nubango, we must perform something akin to a "man-in-the-middle attack" by redirecting iTunes' HTTP requests to a Nubango server (locally or remotely), which can serve a locally-hosted XML station catalog.

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
| 9.x | Testing | 50% |
| 4.x | **OK** | 100% |
| 3.x | Untested | 50% |
| 2.x | **OK** | 100% |
| 1.x | Untested | 0%

## :cd: How-To / Install

You can run the included `install.sh` installation script, then skip to **Step 6**; or you can complete the all of the *DIY Install* steps below:

### :wrench: DIY Install

*For experienced users only. You risk damaging your system. Please read the included MIT "LICENSE" document.*

1. Copy the included directory `xml` into the directory `/Library/WebServer/Documents`

2. Add a DNS redirection to the bottom of the file `/etc/hosts`:

```
127.0.0.1 pri.kts-af.net
```

3. Add an Apache `RewriteRule` to the bottom of the file `/etc/httpd/httpd.conf`:

```
RewriteRule "^/xml/index\.xml$" "/cgi-bin/nubango.sh" [PT]"
```

4. Copy the included file `cgi-bin/nubango.sh` into the directory `/Library/WebServer/CGI-Executables`
5. Make the file `nubango.sh` executable:

```
chmod +x /Library/WebServer/CGI-Executables/nubango.sh
```

6. Enable "Personal Web Sharing" in *System Preferences > Internet & Network > Services > Sharing*
7. Open http://127.0.0.1 and http://127.0.0.1/xml/index.xml in your web browser to ensure that the HTTP server is working properly.