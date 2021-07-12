#!/usr/bin/env node
// Kerbango XML Generator, Limb Amputator, and Door Stopper. As seen on TV!
// DOCTOR'S NOTE: This is a terrible, terrible hack. We need better sources!
const fs = require("fs/promises");
const iconv = require("iconv");
const converter = new iconv.Iconv("UTF-8", "latin1//TRANSLIT//IGNORE");
const kbHead = `<?xml version="1.0" encoding="ISO-8859-1"?><kb:Kerbango xmlns:kb="http://www.kerbango.com/xml">`;
const kbRes = `<kb:results>`;
const kbResFoot = `</kb:results>`;
const kbFoot = `</kb:Kerbango>`;
const terminals = {
	"&": "&amp;",
	"?": "&#63;",
	"<": "&lt;",
	">": "&gt;",
	";": "&#59;",
	"=": "&#61;",
	"'": "&#39;",
	"\"": "&#34;"
};
function htmlEntity(terminal) {
	return terminals[terminal];
}
function htmlEntities(str) {
	return str.replace(/[&?<>;=]/g, htmlEntity);
}
const charStr = "!'(),-./0123456789:;<=>?@ABCDEFGHIJKLMNOPRSTUVWXY^_abcdefghijklmnopqrstuvwxyz|éö–’%QZ[ßàäçèôúüŽ‘“„…€*+]ÖÜáãíóı™´Äêðñğœ¡”°É​—台四港第電香~ş«»`{}ûÇÈ║″ÁÙâëîùąęłńśżΠήίαγδεηθικλμνορτφωύآأابةثجحخدرزسشصعغقلمنوىي♫ΒÎåčįİšųžАБВЕИКЛНПСЧабвгдежзийклмнопрстуфцчшья一三二五數普碼話通ÍÚïòõćđƯЈЗРЦЮхыэюҥằếệịọốộớừÀØæøě";
const genres = [
	{ id: "3", name: "90's Hits" },
	{ id: "5", name: "80's Flashback" },
	{ id: "4", name: "70's Retro" },
	{ id: "9", name: "Adult Contemporary" },
	{ id: "14", name: "Alternative Rock" },
	{ id: "163", name: "Ambient" },
	{ id: "12", name: "Blues" },
	{ id: "141", name: "Classical" },
	{ id: "18", name: "Classic Rock" },
	{ id: "86", name: "College / University" },
	{ id: "11", name: "Comedy" },
	{ id: "8", name: "Country" },
	{ id: "103", name: "Eclectic" },
	{ id: "7", name: "Electronica" },
	{ id: "129", name: "Golden Oldies" },
	{ id: "48", name: "Hard Rock / Metal" },
	{ id: "36", name: "Hip Hop / Rap" },
	{ id: "102", name: "International / World" },
	{ id: "112", name: "Jazz" },
	{ id: "21", name: "News / Talk Radio" },
	{ id: "120", name: "Reggae / Island" },
	{ id: "34", name: "Religious" },
	{ id: "20", name: "RnB / Soul" },
	{ id: "19", name: "Sports Radio" },
	{ id: "24", name: "Top 40 / Pop" },
	{ id: "999", name: "Developer Test" }
];
function kbStationRecord(name, desc, href, bitrate) {
	return `<kb:station_record><kb:station>${name}</kb:station><kb:description>foobar</kb:description><kb:long_description>${desc}</kb:long_description><kb:num_users>1</kb:num_users><kb:max_users>100</kb:max_users><kb:station_url_record><kb:url>${href}</kb:url><kb:status_code>200</kb:status_code><kb:bandwidth_kbps>${bitrate}</kb:bandwidth_kbps></kb:station_url_record></kb:station_record>`;
}
function kbTestStation(name, str) {
	return kbStationRecord(name, str, "http://listen.radionomy.com/lovejazzflorida.m3u", "128");
}
function kbMenuRecord(name, menuID) {
	return `<kb:menu_record><kb:name>${name}</kb:name><kb:menu_id>${menuID}</kb:menu_id><kb:pass_count>0</kb:pass_count></kb:menu_record>`;
}
function formatFilename(str) {
	return str.toLowerCase().replace(/[/ &]/g, () => "-").replace(/---/g, () => "-").replace(/[']/g, () => "");
}
async function generateRecords(kbJSON) {
	const kbStations = JSON.parse(kbJSON);
	for (const genre in kbStations) {
		const fileName = formatFilename(genre);
		console.log("Generating " + fileName + ".xml ...");
		var xmlStr = kbHead + kbRes;
		for (const station of kbStations[genre]) {
			xmlStr += kbStationRecord(station.name, station.desc, station.href, station.bitrate);
		}
		xmlStr += kbResFoot + kbFoot;
		const latin1Buf = converter.convert(xmlStr.replace(/[�]/g, () => "-"), "UTF-8");
		fs.writeFile("./" + fileName + ".xml", latin1Buf, "latin1");
	}
	console.log("Generating nubango-auth.xml ...");
	const authStr = kbHead + `<kb:authenticate><kb:method>CRAM-MD5</kb:method><kb:challenge>foobar</kb:challenge></kb:authenticate>` + kbFoot;
	fs.writeFile("./nubango-auth.xml", converter.convert(authStr, "UTF-8"), "latin1");
	console.log("Generating empty.xml ...");
	const emptyStr = kbHead + kbRes + kbResFoot + kbFoot;
	fs.writeFile("./empty.xml", converter.convert(emptyStr, "UTF-8"), "latin1");
	console.log("Generating encoding-test.xml ...");
	const testStr = kbHead + kbRes + kbTestStation("Latin1DevEncodingTest", htmlEntities(charStr)) + kbResFoot + kbFoot;
	fs.writeFile("./encoding-test.xml", converter.convert(testStr, "UTF-8"), "latin1");
	console.log("Generating genres.xml ...");
	var menuStr = kbHead + kbRes;
	for (const genre of genres) menuStr += kbMenuRecord(genre.name, genre.id);
	menuStr += kbResFoot + kbFoot;
	fs.writeFile("./genres.xml", converter.convert(menuStr, "UTF-8"), "latin1");
}
fs.readFile("./stations.json").then(generateRecords);