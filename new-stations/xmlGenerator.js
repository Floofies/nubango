#!/usr/bin/env node
// Kerbango XML Health Checker, Limb Amputator, and Door Stopper. As seen on TV!
// DOCTOR'S NOTE: This is a terrible, terrible hack. We need better sources!
const fs = require("fs/promises");
fs.readFile("./stations.json").then(generateRecords);
const iconv = require("iconv");
const converter = new iconv.Iconv("UTF-8", "latin1//TRANSLIT//IGNORE");
async function generateRecords(kbStations) {
	kbStations = JSON.parse(kbStations);
	for (const genre in kbStations) {
		console.log("Generating " + genre);
		var xml = `<?xml version="1.0" encoding="UTF-8"?><kb:Kerbango xmlns:kb="http://www.kerbango.com/xml"><kb:results>`;
		for (const station of kbStations[genre]) {
			xml += station.kbXML.replace(/[€]/g, () => "E");
		}
		xml += `</kb:results></kb:Kerbango>`;
		const latin1Buf = converter.convert(xml, "latin1");
		const fileName = genre.toLowerCase().replace(/[/ &]/g, () => "-").replace(/---/g, () => "-").replace(/[']/g, () => "");
		fs.writeFile("./" + fileName + ".xml", latin1Buf, "latin1");
	}
}
