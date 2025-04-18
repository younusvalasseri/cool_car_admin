const admin = require("firebase-admin");

// Replace with the path to your service account key file
const serviceAccount = require("./serviceAccountKey.json");

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
});

// Replace with your admin user's UID
const uid = "ZAiqegMvdYXdpVGBMn8n3qAsLLw2";

admin.auth().setCustomUserClaims(uid, { admin: true }).then(() => {
    console.log(`✅ Admin claim added to user ${uid}`);
});
