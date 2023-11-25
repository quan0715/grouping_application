'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"manifest.json": "cfa915122aba3363b097e92bcd388512",
"flutter.js": "7d69e653079438abfbb24b82a655b0a4",
"version.json": "fc49d41da47ea90a3029e034af1970f9",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"index.html": "2dafc13aa07a0288b72ae3dfbac7c2a6",
"/": "2dafc13aa07a0288b72ae3dfbac7c2a6",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"assets/FontManifest.json": "be1c0b889ba3a1ac6fcce2a0d85733a9",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"assets/packages/timezone/data/latest_all.tzf": "d34414858d4bd4de35c0ef5d94f1d089",
"assets/packages/day_night_time_picker/assets/sun.png": "5fd1657bcb73ce5faafde4183b3dab22",
"assets/packages/day_night_time_picker/assets/moon.png": "71137650ab728a466a50fa4fa78fb2b9",
"assets/NOTICES": "1f69a54a30ec5ed29fedf9d57a5e44e9",
"assets/AssetManifest.json": "59554b74c838f52ba9031b2f2ac9c606",
"assets/AssetManifest.bin.json": "571c2bb27b6805f04cab5928b825846c",
"assets/shaders/ink_sparkle.frag": "4096b5150bac93c41cbc9b45276bd90f",
"assets/assets/icons/task.svg": "39836654e4eac61741fa304494ee0360",
"assets/assets/icons/appBar/note.svg": "92c9dd05d43947df4f6de947f76666a0",
"assets/assets/icons/appBar/calendar.svg": "c418cb4a33ce5afe61ffbbe5a93edb27",
"assets/assets/icons/appBar/messages.svg": "c6155ec4f18a66a683fbb8a0124def2b",
"assets/assets/icons/appBar/home.svg": "2b44bc80dcbf9f4c471bd79c18ea3f99",
"assets/assets/icons/calendartick.svg": "656dce63993defb37dd3dd87338dcf01",
"assets/assets/icons/authIcon/facebook.png": "af08e63a193dd5f3aee1acddb3b69ebb",
"assets/assets/icons/authIcon/github.png": "fb867234c84e47405475746555b7a0c7",
"assets/assets/icons/authIcon/line.png": "f70406db9f7432e1541c00eb8dd74737",
"assets/assets/icons/authIcon/google.png": "1f59a5029bd5c55e0f2b62998bcfd67f",
"assets/assets/icons/messagetick.svg": "ddb98da5a530328670ff0956c3062ed2",
"assets/assets/images/login.png": "8513a47119f6d331f5fd64ee00fab3c5",
"assets/assets/images/Mission.png": "3435cacfc155aac94020dc5d7ed4a73b",
"assets/assets/images/review.svg": "e4ef25d471177d15584afe1ee58e0d2a",
"assets/assets/images/404_not_found.png": "1d1240da6a44ff98451defa04bce72cf",
"assets/assets/images/Event.png": "bf06d9c0fdc4a73a31c603029d8739dc",
"assets/assets/images/logo_dark.svg": "379473f8e41ad01508622c976daf49ca",
"assets/assets/images/topic.png": "07d876e40ff92989e8487cf600209852",
"assets/assets/images/logo_light.svg": "6e6eb6615decff0a59b4f4f120cec007",
"assets/assets/images/reminder.svg": "ed4a42af3406cabc9ab28da01e173cb8",
"assets/assets/images/apple.png": "6af20e263ee7a892de7d6b8a2cb86931",
"assets/assets/images/profile_female.png": "128bdc79df8becac689b2e920f0454d5",
"assets/assets/images/Note.png": "4ac31422170e16b6d087fdb9fdfca3e2",
"assets/assets/images/analytics.svg": "4ee083ef0d277388378f06304638dbf3",
"assets/assets/images/conference.png": "90083465663e0c5d173eb79c276c8dfe",
"assets/assets/images/profile_male.png": "e1442dc60cdf3dc0ba6ea26f9623a090",
"assets/assets/images/welcome.png": "9ca60de55f3eadada17beb3987e01b25",
"assets/assets/images/technical_support.png": "1595deae8d99acc75fbb9994d2d1f585",
"assets/assets/images/chatting.svg": "9b3d78e7f229c8f0c3e4c81d584130aa",
"assets/assets/images/cover.png": "3b821f089d73ae9339cea0d6ff9b89fe",
"assets/assets/fonts/NotoSansTC-Medium.otf": "3cf084f9bb05158d53e7c239899aaccc",
"assets/assets/fonts/NotoSansTC-Bold.otf": "503ece9832c8660172b2e9bf6d864028",
"assets/assets/fonts/NotoSansTC-Regular.otf": "d6b43f6600389d7442f317adfbbd9942",
"assets/AssetManifest.bin": "6f7f20508a2603c058b62ff43d5a44dc",
"assets/fonts/MaterialIcons-Regular.otf": "e7069dfd19b331be16bed984668fe080",
"canvaskit/skwasm.wasm": "4124c42a73efa7eb886d3400a1ed7a06",
"canvaskit/canvaskit.js": "eb8797020acdbdf96a12fb0405582c1b",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"canvaskit/skwasm.js": "87063acf45c5e1ab9565dcf06b0c18b8",
"canvaskit/canvaskit.wasm": "64edb91684bdb3b879812ba2e48dd487",
"canvaskit/chromium/canvaskit.js": "0ae8bbcc58155679458a0f7a00f66873",
"canvaskit/chromium/canvaskit.wasm": "f87e541501c96012c252942b6b75d1ea",
"main.dart.js": "eced6ef2353a45873e954a4a15b76269"};
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
