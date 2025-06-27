# 🚗 Cool Car Admin

Cool Car Admin is the backend admin panel of the CoolCar project — a private taxi/rental business platform that connects users with private vehicle owners. This Flutter-based application enables administrators to manage ride requests, drivers, vehicles, payments, and various backend operations efficiently.

---

## 📖 Story Behind CoolCar

CoolCar was born to digitize and streamline the operations of a private car rental and taxi business. The system empowers a rental agency to coordinate between private car owners (CoolTaxi partners), in-house drivers, and customers, all under a unified platform with real-time notifications, GPS tracking, and remote control capabilities.

---

## 📱 App Features

### ✅ Admin Panel Capabilities

- 📦 Manage incoming ride requests
- 🚘 Approve or reject vehicle/driver participation
- 💳 View payment status and activate "Complete Ride" only after Razorpay success
- 📍 Monitor real-time GPS locations of vehicles
- 📩 Push notifications to drivers and customers
- 📄 View and manage ride history, completed bookings, and pending actions
- 📊 Dashboard summary for quick analytics
- 🧾 Manage FAQs and Announcements for users and owners

---

## 🛠 Tech Stack

| Layer         | Technology                |
|---------------|---------------------------|
| Language      | Dart                      |
| Framework     | Flutter                   |
| Backend       | Firebase Firestore        |
| Local Storage | Hive                      |
| Payments      | Razorpay                  |
| Messaging     | WhatsApp API              |
| State Mgmt    | Riverpod                  |
| Notifications | Firebase Cloud Messaging  |
| Media Upload  | Firebase Storage          |

---

## 🔑 Key Functionalities

- **Ride Approval Page** with Razorpay integration (Complete only after payment).
- **AdminChat** to respond to queries from users/owners.
- **FAQ Management** – Add/update FAQs via Firestore.
- **Announcements** – Post heading, message, and an image via gallery.
- **Owner & Driver Management** – Accept/reject entries.
- **Firebase Integration** – Clean architecture with Firestore logic in `providers.dart`.

---

## 🔒 Admin Authentication

The admin section is protected and accessible only through validated admin credentials. Firebase Authentication can be used for managing access.

---

## 🚀 Getting Started

### 1. Clone the repo

```bash
git clone https://github.com/younusvalasseri/cool_car_admin.git
cd cool_car_admin
````

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Run the project

```bash
flutter run
```

### 4. Firebase Setup

Ensure `google-services.json` (Android) and/or `GoogleService-Info.plist` (iOS) is placed in the respective platform directories and Firebase is configured.

---

## 📂 Project Structure (Overview)

```bash
lib/
├── screens/             # All screens (Dashboard, RideApproval, etc.)
├── widgets/             # Reusable UI widgets
├── providers.dart       # Firebase & state logic (using Riverpod)
├── models/              # Data models (User, Vehicle, Ride, etc.)
├── main.dart            # Entry point
```

---

## 📎 Useful Links

* 🔗 [Razorpay Payment Link (Demo)](https://razorpay.me/@coolcar)
* 📄 [Firestore Setup Guide](https://firebase.google.com/docs/firestore)
* 📦 [Hive Flutter Documentation](https://docs.hivedb.dev/)
* 🔧 [Riverpod for State Management](https://riverpod.dev/)

---

## 🙏 Acknowledgements

Special thanks to:

* Firebase for backend infrastructure
* Razorpay for smooth payment experience
* The Flutter community for plugins and guidance

---

## 👨‍💻 Author

**Younus Valasseri**
Director, Institute of Automobile Technology (IAT)
[GitHub Profile](https://github.com/younusvalasseri)

---

## 📜 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

```

---

Would you like me to automatically create a `README.md` file and open a pull request in your repo via a GitHub token? Or would you like to copy-paste this manually?
```
