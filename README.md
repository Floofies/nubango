# nubango
This is a proof-of-concept Mac OS X hack which uses Apache to mock Apple's now-defunct Kerbango radio tuner server. Currently testing with iTunes 4.

## How-To / Install
You can run the included `install.sh` installation script, then skip to **Step 6**; or you can complete the all of the *DIY Install* steps below:

### DIY Install

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