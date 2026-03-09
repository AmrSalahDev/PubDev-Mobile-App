const admin = require("firebase-admin");
const axios = require("axios");
const fs = require("fs");

/**
 * Pub.dev Watcher Script
 * ----------------------
 * This script is designed to run via GitHub Actions every 15 minutes.
 * It checks the pub.dev API for new packages and sends an FCM notification
 * using the Firebase Admin SDK.
 * 
 * NO CREDIT CARD REQUIRED for this approach.
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

    const latestPackageId = response.data.packages[0].package;
    console.log(`Current latest package on pub.dev: ${latestPackageId}`);

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
    } else {
      console.log("No cache file found, creating one now.");
    }

    // 4. Compare and notify if a new package exists
    if (latestPackageId !== lastSeenId) {
      console.log(`🚀 New package detected! Sending notification for ${latestPackageId}...`);
      
      const message = {
        notification: {
          title: "New Package Published!",
          body: `${latestPackageId} has just been released on pub.dev.`,
        },
        topic: "new_packages", // All Flutter apps subscribe to this topic
        data: {
          package_id: latestPackageId,
          click_action: "FLUTTER_NOTIFICATION_CLICK"
        }
      };

      // Send the FCM message via Firebase Admin SDK
      const responseFCM = await admin.messaging().send(message);
      console.log(`Notification sent successfully. FCM Response: ${responseFCM}`);
      
      // 5. Update our local cache file so we don't notify for the same package again
      fs.writeFileSync(cacheFile, JSON.stringify({ 
        id: latestPackageId, 
        timestamp: new Date().toISOString() 
      }, null, 2));
      
      console.log("Task completed: Cache updated.");
    } else {
      console.log("No new packages since last check. Staying quiet.");
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
