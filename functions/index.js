const functions = require("firebase-functions");
const admin = require("firebase-admin");
const axios = require("axios");

admin.initializeApp();
const db = admin.firestore();

exports.checkNewPackages = functions.pubsub
  .schedule("every 15 minutes")
  .onRun(async (context) => {
    try {
      // 1. Fetch most recent 5 packages from pub.dev
      const searchUrl = "https://pub.dev/api/search?q=&sort=created";
      const response = await axios.get(searchUrl);
      const packages = response.data.packages;

      if (!packages || packages.length === 0) {
        console.log("No packages found on pub.dev");
        return null;
      }

      // 2. Get the latest package ID
      const latestPackageId = packages[0].package;

      // 3. Check Firestore for the last seen package
      const lastSeenDoc = await db
        .collection("settings")
        .doc("last_package")
        .get();
      const lastSeenId = lastSeenDoc.exists ? lastSeenDoc.data().id : null;

      // 4. If it's a new package, send FCM notification
      if (latestPackageId !== lastSeenId) {
        console.log(`New package found: ${latestPackageId}`);

        // Get full package info for better notification
        const infoUrl = `https://pub.dev/api/packages/${latestPackageId}`;
        const infoResponse = await axios.get(infoUrl);
        const packageInfo = infoResponse.data;
        const version = packageInfo.latest.version;

        const message = {
          notification: {
            title: "New Package Published!",
            body: `${latestPackageId} version ${version} has just been released on pub.dev.`,
          },
          topic: "new_packages",
          data: {
            package_id: latestPackageId,
            version: version,
          },
        };

        // Send FCM notification
        await admin.messaging().send(message);

        // 5. Update last seen package in Firestore
        await db.collection("settings").doc("last_package").set({
          id: latestPackageId,
          version: version,
          timestamp: admin.firestore.FieldValue.serverTimestamp(),
        });

        console.log("Notification sent successfully!");
      } else {
        console.log("No new packages to notify about.");
      }
    } catch (error) {
      console.error("Error checking new packages:", error);
    }
    return null;
  });
