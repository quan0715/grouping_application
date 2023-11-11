'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "6fef97aeca90b426343ba6c5c9dc5d4a",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"assets/FontManifest.json": "be1c0b889ba3a1ac6fcce2a0d85733a9",
"assets/AssetManifest.bin": "6f7f20508a2603c058b62ff43d5a44dc",
"assets/assets/icons/messagetick.svg": "ddb98da5a530328670ff0956c3062ed2",
"assets/assets/icons/task.svg": "39836654e4eac61741fa304494ee0360",
"assets/assets/icons/authIcon/line.png": "f70406db9f7432e1541c00eb8dd74737",
"assets/assets/icons/authIcon/google.png": "1f59a5029bd5c55e0f2b62998bcfd67f",
"assets/assets/icons/authIcon/facebook.png": "af08e63a193dd5f3aee1acddb3b69ebb",
"assets/assets/icons/authIcon/github.png": "fb867234c84e47405475746555b7a0c7",
"assets/assets/icons/calendartick.svg": "656dce63993defb37dd3dd87338dcf01",
"assets/assets/icons/appBar/home.svg": "2b44bc80dcbf9f4c471bd79c18ea3f99",
"assets/assets/icons/appBar/messages.svg": "c6155ec4f18a66a683fbb8a0124def2b",
"assets/assets/icons/appBar/note.svg": "92c9dd05d43947df4f6de947f76666a0",
"assets/assets/icons/appBar/calendar.svg": "c418cb4a33ce5afe61ffbbe5a93edb27",
"assets/assets/images/topic.png": "07d876e40ff92989e8487cf600209852",
"assets/assets/images/review.svg": "e4ef25d471177d15584afe1ee58e0d2a",
"assets/assets/images/Note.png": "4ac31422170e16b6d087fdb9fdfca3e2",
"assets/assets/images/chatting.svg": "9b3d78e7f229c8f0c3e4c81d584130aa",
"assets/assets/images/Event.png": "bf06d9c0fdc4a73a31c603029d8739dc",
"assets/assets/images/conference.png": "90083465663e0c5d173eb79c276c8dfe",
"assets/assets/images/technical_support.png": "1595deae8d99acc75fbb9994d2d1f585",
"assets/assets/images/cover.png": "3b821f089d73ae9339cea0d6ff9b89fe",
"assets/assets/images/welcome.png": "9ca60de55f3eadada17beb3987e01b25",
"assets/assets/images/reminder.svg": "ed4a42af3406cabc9ab28da01e173cb8",
"assets/assets/images/logo_light.svg": "6e6eb6615decff0a59b4f4f120cec007",
"assets/assets/images/analytics.svg": "4ee083ef0d277388378f06304638dbf3",
"assets/assets/images/apple.png": "6af20e263ee7a892de7d6b8a2cb86931",
"assets/assets/images/logo_dark.svg": "379473f8e41ad01508622c976daf49ca",
"assets/assets/images/Mission.png": "3435cacfc155aac94020dc5d7ed4a73b",
"assets/assets/images/profile_male.png": "e1442dc60cdf3dc0ba6ea26f9623a090",
"assets/assets/images/profile_female.png": "128bdc79df8becac689b2e920f0454d5",
"assets/assets/images/404_not_found.png": "1d1240da6a44ff98451defa04bce72cf",
"assets/assets/images/login.png": "8513a47119f6d331f5fd64ee00fab3c5",
"assets/assets/fonts/NotoSansTC-Bold.otf": "503ece9832c8660172b2e9bf6d864028",
"assets/assets/fonts/NotoSansTC-Regular.otf": "d6b43f6600389d7442f317adfbbd9942",
"assets/assets/fonts/NotoSansTC-Medium.otf": "3cf084f9bb05158d53e7c239899aaccc",
"assets/AssetManifest.json": "59554b74c838f52ba9031b2f2ac9c606",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"assets/packages/timezone/data/latest_all.tzf": "d34414858d4bd4de35c0ef5d94f1d089",
"assets/packages/day_night_time_picker/assets/sun.png": "5fd1657bcb73ce5faafde4183b3dab22",
"assets/packages/day_night_time_picker/assets/moon.png": "71137650ab728a466a50fa4fa78fb2b9",
"assets/fonts/MaterialIcons-Regular.otf": "e7069dfd19b331be16bed984668fe080",
"assets/NOTICES": "566b5fa9a706e7256ad41805feae644a",
"assets/shaders/ink_sparkle.frag": "f8b80e740d33eb157090be4e995febdf",
"index.html": "8792746f80cb8156838fc417766a58c8",
"/": "8792746f80cb8156838fc417766a58c8",
"main.dart.js": "30cfa39effd48651eb8241091ff47a89",
"manifest.json": "cfa915122aba3363b097e92bcd388512",
"version.json": "fc49d41da47ea90a3029e034af1970f9",
"canvaskit/skwasm.js": "95f16c6690f955a45b2317496983dbe9",
"canvaskit/chromium/canvaskit.wasm": "be0e3b33510f5b7b0cc76cc4d3e50048",
"canvaskit/chromium/canvaskit.js": "96ae916cd2d1b7320fff853ee22aebb0",
"canvaskit/canvaskit.wasm": "42df12e09ecc0d5a4a34a69d7ee44314",
"canvaskit/skwasm.wasm": "1a074e8452fe5e0d02b112e22cdcf455",
"canvaskit/canvaskit.js": "bbf39143dfd758d8d847453b120c8ebb",
"canvaskit/skwasm.worker.js": "51253d3321b11ddb8d73fa8aa87d3b15"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"assets/AssetManifest.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
