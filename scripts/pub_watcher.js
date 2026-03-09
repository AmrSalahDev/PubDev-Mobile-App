const admin = require("firebase-admin");
const axios = require("axios");
const fs = require("fs");

/**
 * Pub.dev Watcher Script
 * ----------------------
 * This script is designed to run via GitHub Actions every 5 minutes.
 * It checks the pub.dev API for new packages and sends an FCM notification
 * using the Firebase Admin SDK.
 * 
 */

// 1. Initialize Firebase Admin SDK
// The service account JSON is passed from GitHub Secrets as an environment variable
if (!process.env.FIREBASE_SERVICE_ACCOUNT) {
  console.error("Missing FIREBASE_SERVICE_ACCOUNT environment variable.");
  process.exit(1);
}

const serviceAccount = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT);

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const path = require("path");
const cacheFile = path.join(__dirname, "last_package.json");

async function checkNewPackages() {
  try {
    console.log("Checking pub.dev for new packages...");
    
    // 2. Fetch the most recent packages from pub.dev API
    const searchUrl = "https://pub.dev/api/search?q=&sort=created";
    const response = await axios.get(searchUrl);
    
    if (!response.data || !response.data.packages || response.data.packages.length === 0) {
      console.log("No packages found on pub.dev");
      return;
    }

    const packages = response.data.packages;
    if (!packages || packages.length === 0) {
      console.log("No packages found on pub.dev");
      return;
    }

    // 3. Load the last seen package from our local cache file
    let lastSeenId = "";
    if (fs.existsSync(cacheFile)) {
      try {
        const cacheContent = JSON.parse(fs.readFileSync(cacheFile, "utf8"));
        lastSeenId = cacheContent.id;
        console.log(`Last seen package in cache: ${lastSeenId}`);
      } catch (e) {
        console.warn("Could not parse cache file, treating as first run.");
      }
    }

    // 4. Find all packages published since the last seen one
    // We check the top 10 most recent packages
    const newPackages = [];
    for (let i = 0; i < Math.min(packages.length, 10); i++) {
        if (packages[i].package === lastSeenId) break;
        newPackages.push(packages[i]);
    }

    if (newPackages.length > 0) {
      console.log(`🚀 Found ${newPackages.length} new packages!`);

      // 5. Send notification for each new package (limit to 5 to avoid spam)
      const notifyCount = Math.min(newPackages.length, 5);
      
      for (let i = 0; i < notifyCount; i++) {
        const pkg = newPackages[i];
        console.log(`Notifying for ${pkg.package}...`);
        
        const message = {
          notification: {
            title: "New Package Published!",
            body: `${pkg.package} has just been released on pub.dev.`,
          },
          topic: "new_packages",
          data: {
            package_id: pkg.package,
            click_action: "FLUTTER_NOTIFICATION_CLICK"
          }
        };

        await admin.messaging().send(message);
      }
      
      // 6. Update our local cache file with the absolute latest one
      fs.writeFileSync(cacheFile, JSON.stringify({ 
        id: packages[0].package, 
        timestamp: new Date().toISOString() 
      }, null, 2));
      
      console.log(`Task completed: Sent ${notifyCount} notifications.`);
    } else {
      console.log("No new packages since last check.");
    }
  } catch (error) {
    console.error("Error in watcher script:", error.message);
    if (error.response) {
      console.error("API Response Error:", error.response.data);
    }
    process.exit(1);
  }
}

checkNewPackages();
