/* The /demo/ worker does not cache files or change ordinary API traffic. */
const dropResponseHeader = "X-TPP-Demo-Drop-Response";
const loopbackHost = () => {
  const host = self.location.hostname;
  return host === "localhost" || host === "[::1]" ||
    (/^127\.\d{1,3}\.\d{1,3}\.\d{1,3}$/.test(host) && host.split(".").every((part) => Number(part) <= 255));
};

self.addEventListener("install", (event) => event.waitUntil(self.skipWaiting()));
self.addEventListener("activate", (event) => event.waitUntil(self.clients.claim()));

self.addEventListener("fetch", (event) => {
  const request = event.request;
  const url = new URL(request.url);
  if (!loopbackHost() || request.method !== "POST" || url.origin !== self.location.origin ||
      url.pathname !== "/api/transfers" || url.search !== "" ||
      request.headers.get(dropResponseHeader) !== "1") {
    return;
  }

  event.respondWith((async () => {
    const headers = new Headers(request.headers);
    headers.delete(dropResponseHeader);
    const response = await fetch(new Request(request, { headers }));
    if (response.status === 201 && response.headers.get("Idempotency-Replayed") === "false") {
      // The application already returned a new committed transfer. Only the page loses the reply.
      // The browser verifier observes this diagnostic without a response body, key or transfer ID.
      if (event.clientId) {
        const client = await self.clients.get(event.clientId).catch(() => undefined);
        client?.postMessage({ type: "tpp-response-dropped", status: 201 });
      }
      if (response.body) void response.body.cancel().catch(() => {});
      return Response.error();
    }
    return response;
  })());
});
