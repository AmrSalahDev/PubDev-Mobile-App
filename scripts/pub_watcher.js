const admin = require("firebase-admin");
const axios = require("axios");
const fs = require("fs");
const path = require("path");

// 1. Initialize Firebase Admin SDK
if (!process.env.FIREBASE_SERVICE_ACCOUNT) {
  console.error("Missing FIREBASE_SERVICE_ACCOUNT environment variable.");
  process.exit(1);
}

const serviceAccount = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT);
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const cacheFile = path.join(__dirname, "last_package.json");

async function checkNewPackages() {
  try {
    console.log("Checking pub.dev for new packages...");
    
    // 2. Fetch the most recent packages
    const searchUrl = "https://pub.dev/api/search?q=&sort=created";
    // We can pull "data" right out of the response to keep the code clean
    const { data } = await axios.get(searchUrl);
    
    // Simpler check to make sure we have packages
    if (!data?.packages?.length) {
      console.log("No packages found on pub.dev");
      return;
    }

    const packages = data.packages;

    // 3. Load the last seen package (Warning: This file gets deleted on GitHub Actions!)
    let lastSeenId = "";
    if (fs.existsSync(cacheFile)) {
      try {
        const cacheContent = JSON.parse(fs.readFileSync(cacheFile, "utf8"));
        lastSeenId = cacheContent.id;
        console.log(`Last seen package: ${lastSeenId}`);
      } catch (e) {
        console.warn("Could not read old file, treating as first run.");
      }
    }

    // 4. Find all packages published since the last seen one
    const newPackages = [];
    for (const pkg of packages) {
        if (pkg.package === lastSeenId) break;
        newPackages.push(pkg);
    }

    if (newPackages.length === 0) {
      console.log("No new packages since last check.");
      return;
    }

    console.log(`🚀 Found ${newPackages.length} new packages!`);

    // Limit to 5 packages to avoid spam
    const packagesToNotify = newPackages.slice(0, 5);
    
    // 5. Fetch all descriptions at the same time (Much faster!)
    const messages = await Promise.all(packagesToNotify.map(async (pkg) => {
      let description = "";
      try {
        const detailResponse = await axios.get(`https://pub.dev/api/packages/${pkg.package}`);
        description = detailResponse.data.latest.pubspec.description || "";
        
        if (description.length > 200) {
          description = description.substring(0, 197) + "...";
        }
      } catch (e) {
        console.warn(`Could not fetch description for ${pkg.package}`);
      }

      // Create the message format for Firebase
      return {
        notification: {
          title: "New Package Published!",
          body: `${pkg.package}`,
        },
        topic: "new_packages",
        data: {
          package_name: pkg.package,
          description: description,
          click_action: "FLUTTER_NOTIFICATION_CLICK"
        }
      };
    }));

    // 6. Send all messages to Firebase in one single batch
    if (messages.length > 0) {
      const response = await admin.messaging().sendEach(messages);
      console.log(`Task completed: Sent ${response.successCount} notifications.`);
    }
    
    // 7. Update local cache
    fs.writeFileSync(cacheFile, JSON.stringify({ 
      id: packages[0].package, 
      timestamp: new Date().toISOString() 
    }, null, 2));
    
  } catch (error) {
    console.error("Error in script:", error.message);
    process.exit(1);
  }
}

checkNewPackages();