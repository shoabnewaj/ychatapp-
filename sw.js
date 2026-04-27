const CACHE_NAME = "ychat-v1";

const urlsToCache = [
  "/",
  "/manifest.json"
  // প্রয়োজন হলে এখানে তোমার real page add করো (যেমন /index.jsp)
];

// Install → cache basic files
self.addEventListener("install", event => {
  console.log("Service Worker installing...");
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then(cache => cache.addAll(urlsToCache))
  );
  self.skipWaiting();
});

// Activate → clean old cache
self.addEventListener("activate", event => {
  console.log("Service Worker activated");

  event.waitUntil(
    caches.keys().then(keys => {
      return Promise.all(
        keys.map(key => {
          if (key !== CACHE_NAME) {
            return caches.delete(key);
          }
        })
      );
    })
  );

  self.clients.claim();
});

// Fetch → network first, fallback to cache
self.addEventListener("fetch", event => {
  event.respondWith(
    fetch(event.request)
      .then(response => {
        // cache new request
        const responseClone = response.clone();
        caches.open(CACHE_NAME)
          .then(cache => cache.put(event.request, responseClone));

        return response;
      })
      .catch(() => {
        // offline fallback
        return caches.match(event.request);
      })
  );
});