// Nubango Health Checker
// Checks to see if Apache is still working.
addEventListener("scheduled", (event) => {
	event.waitUntil(
		check(true).catch(
			(err) => new Response(err.stack, { status: 500 })
		)
	);
});
addEventListener("fetch", (event) => {
	event.respondWith(
		check(false).catch(
			(err) => new Response(err.stack, { status: 500 })
		)
	);
});
const smsURL = "https://textbelt.com/text";
async function alert(statusCode) {
	await fetch(smsURL, {
		method: "post",
		headers: { "Content-Type": "application/json" },
		body: JSON.stringify({
			phone: smsNumber,
			message: "⚠️⚠️⚠️ ALERT: Nubango HTTP Healthcheck FAILED! Status code: " + statusCode,
			key: smsKey
		})
	});
}
async function check(sendSMS) {
	const srvResponse = await fetch(serverURL, { headers: { "User-Agent": "CFHealthCheckWorker/iTunes" } });
	const hcBody = (await srvResponse.text()).trim();
	const hcStatus = srvResponse.status.toString();
	if (sendSMS) {
		if (hcStatus !== "200" || hcBody !== "OK") await alert(hcStatus);
		return;
	}
	const srvStatus = JSON.stringify({
		result: hcBody === "OK" ? "OK" : "ERROR",
		status: hcStatus
	});
	return new Response(srvStatus, {
		headers: { "Content-Type": "text/json" },
	});
}