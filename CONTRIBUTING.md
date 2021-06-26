# Developing Nubango

This document explains the technical aspects of Nubango and the KTS system it is based on. Nubango does not have a PR policy.


This document is a work-in-progress. Thank you for your patience, and thank you for your interest in supporting this project.

## Introduction

First, we should understand the simple animal that is the original *Kerbango Tuning Service* (KTS); it was one of the first full-featured internet radio tuning systems available with one of the first internet-based radio appliances. there is no advanced technology inside. According to [Wikipedia](https://en.wikipedia.org/wiki/Kerbango): "*The "Kerbango Internet Radio" was intended to be the first stand-alone product that let users listen to Internet radio without a computer.*"

Apple acquired the rights to utilize Kerbango via 3Com, and at-present the same exact ancient KTS continues to operate on Apple's server. KTS works by pairing magic numbers with radio station genres. A central XML catalog file represents the mapping between numbers and genres, and the Nubango CGI script contains a similar string-map. The Apple KTS has changed implementation of such magic numbers several times, and different iTunes clients tend to use varying magic numbers, which both result in an empty/bad response from the Apple KTS.

Furthermore, a basic CRAM-MD5 challenge must be passed by iTunes if it communicates with the Apple KTS. The password/salt used in iTunes' MD5 hashing is unknown and there will be no attempt to obtain it, as it isn't neccesary to implement Nubango. Nubango instead presents a fake CRAM-MD5 challenge by sending the string `foobar` as a challenge. By using this well-known exploit around CRAM-MD5 authentication, the end result is that we can trick iTunes into believing that it has initiated a KTS session successfully (and with almost zero effort).

## Kerbango XML Specifics

Kerbango uses a specific XML schema to represent radio stations, genres, and their remote resources. Not all fields are known, yet.

All Kerbango XML starts with a `kb:Kerbango` node which then contains a `kb:results` node. Multiple items such as `kb:menu_record` or `kb:station_record` nodes may appear within the `kb:results` node.

### Genres XML Structure

- Each genre is represented by a `kb:menu_record` node.
- The `kb:menu_id` is the magic number for the genre; iTunes inserts the number into an HTTP querystring and uses it to request a list of genre-specific radio stations.
- I do not know what `kb:pass_count` represents, but iTunes requests the field.

Here is a basic example of a genre listing, with only one genre present.

```xml
<?xml version="1.0" encoding="utf-8"?>
<kb:Kerbango xmlns:kb="http://www.kerbango.com/xml">
	<kb:results>
		<kb:menu_record>
			<kb:name>Golden Oldies</kb:name>
			<kb:menu_id>129</kb:menu_id>
			<kb:pass_count>0</kb:pass_count>
		</kb:menu_record>
	</kb:results> 
</kb:Kerbango>
```

### Stations XML Structure

- Each station is represented by a `kb:station_record` node.
- iTunes appears to ignore the `kb:description` tag and instead displays `kb:long_description`, thus all "short" descriptions have been hard-coded to be `foobar`.
- The `kb:num_users` and `kb:max_users` nodes are both hard-coded to `1` and `100` respectively, as there is no way for Nubango to know the real user counts.

Here is a basic example of a stations listing, with only one station present.

```xml
<?xml version="1.0" encoding="utf-8"?>
<kb:Kerbango xmlns:kb="http://www.kerbango.com/xml">
	<kb:results> 
		<kb:station_record>
			<kb:station>Love Jazz Florida</kb:station>
			<kb:description>foobar</kb:description>
			<kb:long_description>Smooth Jazz and Cool Jazz for Lovers!</kb:long_description>
			<kb:num_users>1</kb:num_users>
			<kb:max_users>100</kb:max_users>
			<kb:station_url_record>
				<kb:url>http://listen.radionomy.com/lovejazzflorida.m3u</kb:url>
				<kb:status_code>200</kb:status_code>
				<kb:bandwidth_kbps>128</kb:bandwidth_kbps>
			</kb:station_url_record>
		</kb:station_record>
	</kb:results> 
</kb:Kerbango>
```

## Kerbango XML Generator

The included `internetRadio.html` document is in fact a browser-based Kerbango station record XML generator, and it sources the stations from this web page: [iTunes Internet Radio Stations by Steve MacGuire](http://samsoft.org.uk/iTunes/InternetRadio.asp)

There are some radio stations that are now dead links, but they could be cleaned up later on with the addition of a health-checking program. Steve states on his website that he has archived a total of "*6,096 streams in 25 categories*", and that the list was last compiled on "*October 22nd, 2019*". `internetRadio.html` generates new Kerbango-compatible XML files by using the raw data within Steve's DOM. Sometime in Nubango's future it may be neccesary/optimal to switch to a different source of radio station data.