import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart' as fb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';
import '../Main/verify_otp_page.dart';
import '../views/admin_home_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geocoding/geocoding.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> launchDialer(String phoneNumber) async {
  final Uri telUri = Uri(scheme: 'tel', path: phoneNumber);
  if (await canLaunchUrl(telUri)) {
    await launchUrl(telUri);
  } else {
    throw 'Could not launch dialer';
  }
}

Future<String> getLocationName(String? coordinates) async {
  if (coordinates == null || coordinates.isEmpty) return "Unknown Location";

  try {
    List<String> latLng = coordinates.split(",");
    double latitude = double.parse(latLng[0]);
    double longitude = double.parse(latLng[1]);

    List<Placemark> placemarks = await placemarkFromCoordinates(
      latitude,
      longitude,
    );
    if (placemarks.isNotEmpty) {
      return "${placemarks.first.locality}, ${placemarks.first.country}"; // City & Country
    }
  } catch (e) {
    return "Unknown Location";
  }
  return "Unknown Location";
}

String formatDate(Timestamp timestamp) {
  return DateFormat('dd-MMM-yyyy').format(timestamp.toDate());
}

final updateUserNameProvider =
    Provider.family<Future<void> Function(String), String>((ref, userId) {
      return (String newName) async {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) return;

        await user.updateDisplayName(newName);
        await FirebaseFirestore.instance.collection('users').doc(userId).update(
          {'name': newName},
        );
      };
    });

final currentUserProvider = Provider<User?>((ref) {
  return FirebaseAuth.instance.currentUser;
});

// 🔹 Active rental requests stream
final activeRequestsStreamProvider = StreamProvider.autoDispose<QuerySnapshot>((
  ref,
) {
  return FirebaseFirestore.instance.collection('rental_requests').snapshots();
});

// 🔹 Stream for latest chats
final latestChatsProvider = StreamProvider<QuerySnapshot>((ref) {
  return FirebaseFirestore.instance
      .collectionGroup('chats')
      .orderBy('timestamp', descending: true)
      .snapshots();
});

// 🔹 Provider to fetch user data by ID
final userDataProvider = FutureProvider.family<Map<String, dynamic>?, String>((
  ref,
  userId,
) async {
  final doc =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();
  return doc.exists ? doc.data() : null;
});

// 🔹 Provider to fetch unread messages count
final unreadCountProvider = StreamProvider.family<int, String>((ref, userId) {
  return FirebaseFirestore.instance
      .collection('messages')
      .doc(userId)
      .collection('chats')
      .where('isRead', isEqualTo: false)
      .snapshots()
      .map((snap) => snap.docs.length);
});

/// 🔹 Stream of chats for a user
final adminChatStreamProvider = StreamProvider.family
    .autoDispose<QuerySnapshot, String>((ref, userId) {
      return FirebaseFirestore.instance
          .collection('messages')
          .doc(userId)
          .collection('chats')
          .orderBy('timestamp', descending: true)
          .snapshots();
    });

/// 🔹 Send message as Admin
final adminSendMessageProvider = Provider((ref) {
  return (String userId, String message) {
    return FirebaseFirestore.instance
        .collection('messages')
        .doc(userId)
        .collection('chats')
        .add({
          'sender': 'admin',
          'text': message,
          'timestamp': FieldValue.serverTimestamp(),
        });
  };
});

/// 🔹 Mark all messages as read
final adminMarkMessagesReadProvider = Provider((ref) {
  return (String userId) async {
    final unreadMessages =
        await FirebaseFirestore.instance
            .collection('messages')
            .doc(userId)
            .collection('chats')
            .where('isRead', isEqualTo: false)
            .get();

    for (var doc in unreadMessages.docs) {
      await doc.reference.update({'isRead': true});
    }
  };
});

/// 🔹 Get user name
final fetchChatUserNameProvider = FutureProvider.family<String, String>((
  ref,
  userId,
) async {
  final doc =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();
  return doc.data()?['name'] ?? 'User';
});

final todaysUsersStreamProvider = StreamProvider<AsyncValue<int>>((ref) {
  final now = DateTime.now();
  final startOfToday = DateTime(now.year, now.month, now.day);
  return FirebaseFirestore.instance
      .collection('users')
      .where(
        'createdAt',
        isGreaterThanOrEqualTo: Timestamp.fromDate(startOfToday),
      )
      .snapshots()
      .map((snapshot) => AsyncValue.data(snapshot.docs.length));
});

final unreadMessagesStreamProvider = StreamProvider<AsyncValue<int>>((ref) {
  return FirebaseFirestore.instance
      .collection('chats')
      .where('isRead', isEqualTo: false)
      .snapshots()
      .map((snapshot) => AsyncValue.data(snapshot.docs.length));
});

/// 📄 Stream provider for fetching all FAQs
final faqStreamProvider = StreamProvider.autoDispose((ref) {
  return FirebaseFirestore.instance
      .collection('FAQ')
      .orderBy('createdAt', descending: true)
      .snapshots();
});

/// 📄 Future provider for adding a new FAQ
final addFaqProvider = Provider((ref) => AddFaqService());

class AddFaqService {
  Future<void> addFaq({
    required String question,
    required String answer,
  }) async {
    if (question.isEmpty || answer.isEmpty) return;

    await FirebaseFirestore.instance.collection('FAQ').add({
      'question': question,
      'answer': answer,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}

final todayNewUsersProvider = StreamProvider<QuerySnapshot>((ref) {
  final todayStart = Timestamp.fromDate(
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
  );

  return FirebaseFirestore.instance
      .collection('users')
      .where('createdAt', isGreaterThanOrEqualTo: todayStart)
      .orderBy('createdAt', descending: true)
      .snapshots();
});

final tripHistoryProvider = StreamProvider.autoDispose((ref) {
  return FirebaseFirestore.instance
      .collection('rental_history')
      .orderBy('pickupDate', descending: true)
      .snapshots();
});

final userDetailsProvider =
    FutureProvider.family<Map<String, dynamic>?, String>((ref, userId) async {
      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .get();
      return doc.exists ? doc.data() : null;
    });

final userNameProvider = FutureProvider.family<String, String>((
  ref,
  userId,
) async {
  final doc =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();
  final data = doc.data();
  return data?['name'] ?? "User: $userId";
});
final userDocumentsProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  final querySnapshot =
      await FirebaseFirestore.instance.collection('user_documents').get();

  // Add the userId to each document map
  return querySnapshot.docs.map((doc) {
    final data = doc.data();
    data['userId'] = doc.id;
    return data;
  }).toList();
});

class PickAndUploadImage {
  static Future<void> pickAndUploadImage(
    WidgetRef ref,
    BuildContext context,
  ) async {
    final picker = ImagePicker();
    final user = FirebaseAuth.instance.currentUser;

    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null || user == null) return;

    final croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      compressFormat: ImageCompressFormat.jpg,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.blue,
          toolbarWidgetColor: Colors.white,
          lockAspectRatio: true,
        ),
        IOSUiSettings(title: 'Crop Image'),
      ],
    );

    if (croppedFile == null) return;

    final file = File(croppedFile.path);
    final storageRef = FirebaseStorage.instance.ref().child(
      'profile_photos/${user.uid}',
    );

    await storageRef.putFile(file);
    final imageUrl = await storageRef.getDownloadURL();

    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'profilePhoto': imageUrl,
    });

    await user.updatePhotoURL(imageUrl);

    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Profile picture updated!")));
      ref.invalidate(userDetailsProvider);
    }
  }
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<User?>>(
      (ref) => AuthNotifier(),
    );

class AuthNotifier extends StateNotifier<AsyncValue<User?>> {
  AuthNotifier() : super(const AsyncValue.loading()) {
    _checkAuthState();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _checkAuthState() {
    _auth.authStateChanges().listen((user) {
      state = AsyncValue.data(user);
    });
  }

  void setUser(User? user) {
    state = AsyncValue.data(user);
  }

  Future<void> signUpUser(
    String name,
    String email,
    String password,
    BuildContext context,
  ) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      String uid = userCredential.user!.uid;

      // ✅ Store user details in Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'name': name,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      setUser(_auth.currentUser);
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text("🎉 Welcome, $name! Account created.")),
      );
    } on FirebaseAuthException catch (e) {
      _showError(scaffoldMessenger, e.message ?? "Signup failed");
    }
  }

  Future<void> signInWithEmail(
    String email,
    String password,
    BuildContext context,
  ) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      setUser(_auth.currentUser);
    } on FirebaseAuthException catch (e) {
      _showError(scaffoldMessenger, e.message ?? "Login failed");
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        DocumentSnapshot userDoc =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get();

        // 🔹 If user does not exist in Firestore, prompt for mobile number
        if (!userDoc.exists) {
          if (!context.mounted) return;
          String? phoneNumber = await _promptForPhoneNumber(context);

          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
                'name': user.displayName ?? "Google User",
                'email': user.email,
                'phone': phoneNumber ?? '',
                'createdAt': FieldValue.serverTimestamp(),
              });
        }
      }

      setUser(_auth.currentUser);
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  /// **Prompt user to enter phone number manually**
  Future<String?> _promptForPhoneNumber(BuildContext context) async {
    TextEditingController phoneController = TextEditingController();
    return await showDialog<String>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Enter Your Phone Number"),
            content: TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(hintText: "+1 123 456 7890"),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, null), // Cancel
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed:
                    () => Navigator.pop(context, phoneController.text.trim()),
                child: const Text("Save"),
              ),
            ],
          ),
    );
  }

  Future<String> getUserName(String userId) async {
    try {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .get();

      if (userDoc.exists) {
        return userDoc['name'] ?? 'Unknown User';
      } else {
        return 'Unknown User';
      }
    } catch (e) {
      return 'Unknown User';
    }
  }

  Future<void> signInWithFacebook(BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      final fb.LoginResult result = await fb.FacebookAuth.instance.login(
        permissions: ["public_profile", "email", "user_mobile_phone"],
      );

      if (result.status == fb.LoginStatus.success) {
        final fb.AccessToken accessToken = result.accessToken!;
        final OAuthCredential credential = FacebookAuthProvider.credential(
          accessToken.token,
        );

        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithCredential(credential);
        User? user = userCredential.user;

        if (user != null) {
          final fbUserData = await fb.FacebookAuth.instance.getUserData(
            fields: "name,email,phone",
          );
          if (!context.mounted) return;
          String? phoneNumber =
              fbUserData["phone"] ?? await _promptForPhoneNumber(context);

          DocumentSnapshot userDoc =
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .get();

          if (!userDoc.exists) {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .set({
                  'name': user.displayName ?? "Facebook User",
                  'email': user.email,
                  'phone': phoneNumber ?? '',
                  'createdAt': FieldValue.serverTimestamp(),
                });
          }
        }

        setUser(_auth.currentUser);
      } else {
        _showError(scaffoldMessenger, "Facebook Sign-In Failed");
      }
    } on FirebaseAuthException catch (e) {
      _showError(scaffoldMessenger, e.message ?? "Facebook Sign-In Error");
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    setUser(null);
  }

  void _showError(ScaffoldMessengerState scaffoldMessenger, String message) {
    scaffoldMessenger.showSnackBar(SnackBar(content: Text(message)));
  }
}

// final connectivityProvider = StateNotifierProvider<ConnectivityNotifier, bool>(
//   (ref) => ConnectivityNotifier(),
// );

// class ConnectivityNotifier extends StateNotifier<bool> {
//   ConnectivityNotifier() : super(false) {
//     _checkInternetConnection();
//   }

//   void _checkInternetConnection() async {
//     final connectivityResults = await Connectivity().checkConnectivity();
//     state = connectivityResults.contains(ConnectivityResult.none);

//     Connectivity().onConnectivityChanged.listen((results) {
//       state = results.contains(ConnectivityResult.none);
//     });
//   }
// }

final emailControllerProvider = Provider<TextEditingController>((ref) {
  return TextEditingController();
});
final passwordControllerProvider = Provider<TextEditingController>((ref) {
  return TextEditingController();
});
final registerNotifierProvider =
    StateNotifierProvider<RegisterNotifier, RegisterState>(
      (ref) => RegisterNotifier(),
    );

class RegisterNotifier extends StateNotifier<RegisterState> {
  RegisterNotifier() : super(RegisterState());

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void setName(String name) => state = state.copyWith(name: name);
  void setEmail(String email) => state = state.copyWith(email: email);
  void setPhoneNumber(String number) =>
      state = state.copyWith(phoneNumber: number);
  void setPassword(String password) =>
      state = state.copyWith(password: password);
  void setConfirmPassword(String confirmPassword) =>
      state = state.copyWith(confirmPassword: confirmPassword);

  /// **🔹 Verify Phone Number & Send OTP**
  Future<void> verifyPhoneNumber(BuildContext context) async {
    if (state.phoneNumber.isEmpty ||
        state.name.isEmpty ||
        state.email.isEmpty ||
        state.password.isEmpty ||
        state.confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ All fields are required.")),
      );
      return;
    }

    if (state.password != state.confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Passwords do not match.")),
      );
      return;
    }

    state = state.copyWith(isLoading: true);

    await _auth.verifyPhoneNumber(
      phoneNumber: state.phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        UserCredential userCredential = await _auth.signInWithCredential(
          credential,
        );
        await _saveUserToFirestore(
          userCredential.user!,
          state.name,
          state.email,
          state.password,
        );
      },
      verificationFailed: (FirebaseAuthException e) {
        state = state.copyWith(isLoading: false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Verification failed: ${e.message}')),
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        state = state.copyWith(isLoading: false);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => VerifyOtpPage(
                  verificationId: verificationId,
                  phoneNumber: state.phoneNumber,
                  name: state.name,
                  email: state.email,
                  password: state.password,
                ),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  /// **🔹 Save User to Firestore (With Password Hashing)**
  Future<void> _saveUserToFirestore(
    User user,
    String name,
    String email,
    String password,
  ) async {
    final userRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid);

    DocumentSnapshot userDoc = await userRef.get();
    if (!userDoc.exists) {
      String hashedPassword = _hashPassword(password);
      await userRef.set({
        'name': name,
        'email': email,
        'phoneNumber': user.phoneNumber,
        'password': hashedPassword, // ✅ Store Hashed Password
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  /// **🔹 Hash Password Before Storing**
  String _hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }
}

/// **🔹 Register State Class**
class RegisterState {
  final String name;
  final String email;
  final String phoneNumber;
  final String password;
  final String confirmPassword;
  final bool isLoading;

  RegisterState({
    this.name = '',
    this.email = '',
    this.phoneNumber = '',
    this.password = '',
    this.confirmPassword = '',
    this.isLoading = false,
  });

  RegisterState copyWith({
    String? name,
    String? email,
    String? phoneNumber,
    String? password,
    String? confirmPassword,
    bool? isLoading,
  }) {
    return RegisterState(
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

final otpNotifierProvider = StateNotifierProvider<OtpNotifier, OtpState>(
  (ref) => OtpNotifier(),
);

/// **🔹 OTP Notifier**
class OtpNotifier extends StateNotifier<OtpState> {
  OtpNotifier() : super(OtpState());

  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// **🔹 Set OTP Input**
  void setOtp(String otp) {
    state = state.copyWith(otpCode: otp);
  }

  /// **🔹 Verify OTP & Navigate to Home**
  Future<void> verifyOtp(BuildContext context, String verificationId) async {
    if (state.otpCode.isEmpty || state.otpCode.length < 6) return;

    state = state.copyWith(isLoading: true);

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: state.otpCode,
      );

      UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      await _saveUserToFirestore(userCredential.user!, state.name, state.email);

      state = state.copyWith(isLoading: false);

      if (!context.mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => AdminHomePage()),
        (route) => false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("OTP verification failed: $e")));
    }
  }

  /// **🔹 Save User to Firestore**
  Future<void> _saveUserToFirestore(
    User user,
    String name,
    String email,
  ) async {
    final userRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid);

    DocumentSnapshot userDoc = await userRef.get();
    if (!userDoc.exists) {
      await userRef.set({
        'name': name,
        'email': email,
        'phoneNumber': user.phoneNumber,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }
}

/// **🔹 OTP State Model**
class OtpState {
  final String otpCode;
  final bool isLoading;
  final String phoneNumber;
  final String verificationId;
  final String name; // ✅ Include name
  final String email; // ✅ Include email

  OtpState({
    this.otpCode = '',
    this.isLoading = false,
    this.phoneNumber = '',
    this.verificationId = '',
    this.name = '', // ✅ Default to empty string
    this.email = '', // ✅ Default to empty string
  });

  OtpState copyWith({
    String? otpCode,
    bool? isLoading,
    String? phoneNumber,
    String? verificationId,
    String? name,
    String? email,
  }) {
    return OtpState(
      otpCode: otpCode ?? this.otpCode,
      isLoading: isLoading ?? this.isLoading,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      verificationId: verificationId ?? this.verificationId,
      name: name ?? this.name, // ✅ Preserve values
      email: email ?? this.email, // ✅ Preserve values
    );
  }
}

final activeRequestsProvider =
    StreamProvider.autoDispose<List<QueryDocumentSnapshot>>((ref) async* {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        yield [];
        return;
      }

      final firestore = FirebaseFirestore.instance;

      try {
        // Fetch all cars for the owner
        final carDocs =
            await firestore
                .collection('car_details')
                .doc(user.uid)
                .collection('cars')
                .get();

        // ✅ Safely handle missing deleted field (assume false if missing)
        final nonDeletedCars =
            carDocs.docs.where((doc) {
              final data = doc.data();
              final isDeleted =
                  (data.containsKey('deleted') && data['deleted'] == true);
              return !isDeleted;
            }).toList();

        // Extract valid car categories
        final Set<String> ownerCategories =
            nonDeletedCars
                .map((doc) => doc.data()['expectedClass'] as String?)
                .where((category) => category != null)
                .cast<String>()
                .toSet();

        if (ownerCategories.isEmpty) {
          yield [];
          return;
        }

        // Fetch rental requests that match the car categories
        final rentalRequestsStream = firestore
            .collection('rental_requests')
            .where('category', whereIn: ownerCategories.toList())
            .snapshots()
            .map((snapshot) {
              return snapshot.docs.where((request) {
                final requestedCategory = request.data()['category'] as String?;
                return ownerCategories.contains(requestedCategory);
              }).toList();
            });

        yield* rentalRequestsStream;
      } catch (e) {
        yield [];
      }
    });
final revenueProvider = FutureProvider<Map<String, double>>((ref) async {
  QuerySnapshot revenueSnapshot =
      await FirebaseFirestore.instance
          .collection('rental_history')
          .where('paymentStatus', isEqualTo: 'Paid')
          .get();

  Map<String, double> monthlyRevenue = {};

  for (var doc in revenueSnapshot.docs) {
    final data = doc.data() as Map<String, dynamic>;
    final date = (data['pickupDate'] as Timestamp).toDate();
    final monthYear = "${date.year}-${date.month}";
    final amount = (data['totalFare'] as num).toDouble();

    if (monthlyRevenue.containsKey(monthYear)) {
      monthlyRevenue[monthYear] = monthlyRevenue[monthYear]! + amount;
    } else {
      monthlyRevenue[monthYear] = amount;
    }
  }

  return monthlyRevenue;
});
final carDocumentsProvider = StateNotifierProvider.family<
  CarDocsNotifier,
  AsyncValue<Map<String, String?>>,
  (String ownerId, String carId)
>((ref, tuple) => CarDocsNotifier(ownerId: tuple.$1, carId: tuple.$2));

class CarDocsNotifier extends StateNotifier<AsyncValue<Map<String, String?>>> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final String ownerId;
  final String carId;

  CarDocsNotifier({required this.ownerId, required this.carId})
    : super(const AsyncValue.loading()) {
    fetchCarDocuments();
  }

  Future<void> fetchCarDocuments() async {
    try {
      final docRef = _firestore
          .collection('car_documents')
          .doc(ownerId)
          .collection("cars")
          .doc(carId);

      final doc = await docRef.get();

      final defaultDocs = {
        'Vehicle Insurance': null,
        'Registration Certificate': null,
        'Certificate of Fitness': null,
        'Vehicle Permit': null,
      };

      if (doc.exists && doc.data() != null) {
        final data = doc.data() as Map<String, dynamic>;

        final updatedDocs = defaultDocs.map(
          (key, _) => MapEntry(key, data[key.replaceAll(' ', '_')] as String?),
        );

        state = AsyncValue.data(updatedDocs);
      } else {
        state = AsyncValue.data(defaultDocs);
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> uploadCarDocument(String documentType, File file) async {
    try {
      String formattedKey = documentType.replaceAll(' ', '_');

      Reference ref = _storage.ref(
        'car_documents/$ownerId/cars/$carId/$formattedKey.pdf',
      );
      UploadTask uploadTask = ref.putFile(file);

      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      await _firestore
          .collection('car_documents')
          .doc(ownerId)
          .collection("cars")
          .doc(carId)
          .set({
            formattedKey: downloadUrl,
            'uploadedAt': Timestamp.now(),
          }, SetOptions(merge: true));

      // Update state
      state = AsyncValue.data({
        ...state.value ?? {},
        documentType: downloadUrl,
      });
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> deleteCarDocument(String documentType) async {
    try {
      final docRef = _firestore
          .collection('car_documents')
          .doc(ownerId)
          .collection("cars")
          .doc(carId);

      final docSnap = await docRef.get();
      if (!docSnap.exists) return;

      String formattedKey = documentType.replaceAll(' ', '_');
      String? fileUrl = docSnap.data()?[formattedKey];

      if (fileUrl != null) {
        Reference fileRef = FirebaseStorage.instance.ref().child(
          "car_documents/$ownerId/cars/$carId/$formattedKey.pdf",
        );

        await fileRef.delete();
      }

      await docRef.update({formattedKey: FieldValue.delete()});

      final defaultDocs = {
        'Vehicle Insurance': null,
        'Registration Certificate': null,
        'Certificate of Fitness': null,
        'Vehicle Permit': null,
      };

      final updatedDocs = {...state.value ?? {}, formattedKey: null};

      final mergedDocs = {...defaultDocs, ...updatedDocs};

      state = AsyncValue.data(mergedDocs);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

final ownerDocumentsProvider = StateNotifierProvider<
  OwnerDocumentsNotifier,
  AsyncValue<Map<String, String?>>
>((ref) => OwnerDocumentsNotifier(ref));

class OwnerDocumentsNotifier
    extends StateNotifier<AsyncValue<Map<String, String?>>> {
  final Ref ref;

  OwnerDocumentsNotifier(this.ref) : super(const AsyncValue.loading()) {
    fetchUploadedFiles();
  }

  Future<void> fetchUploadedFiles() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      state = const AsyncValue.data({});
      return;
    }

    try {
      DocumentSnapshot doc =
          await FirebaseFirestore.instance
              .collection('owner_documents')
              .doc(user.uid)
              .get();

      final requiredDocs = {
        'Bank Details': null,
        'Police Clearance': null,
        'Driving License': null,
        'Aadhar Card Front': null,
        'Aadhar Card Back': null,
        'Pan Card': null,
      };

      if (doc.exists && doc.data() != null) {
        final data = doc.data() as Map<String, dynamic>;

        // 🔹 Merge Firestore data with required documents list
        final updatedDocs = requiredDocs.map(
          (key, value) =>
              MapEntry(key, data[key.replaceAll(' ', '_')] as String?),
        );

        state = AsyncValue.data(updatedDocs);
      } else {
        state = AsyncValue.data(requiredDocs); // 🔹 Ensure labels are displayed
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> uploadFile(String documentType) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'pdf'],
    );

    if (result != null && result.files.single.path != null) {
      try {
        final file = File(result.files.single.path!);
        final refStorage = FirebaseStorage.instance.ref(
          'owner_documents/${user.uid}/${file.path.split('/').last}',
        );
        final snapshot = await refStorage.putFile(file);
        final fileUrl = await snapshot.ref.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('owner_documents')
            .doc(user.uid)
            .set({
              documentType.replaceAll(' ', '_'): fileUrl,
              'uploadedAt': Timestamp.now(),
            }, SetOptions(merge: true));

        await fetchUploadedFiles();

        bool allUploaded =
            state.value?.values.every((value) => value != null) ?? false;
        ref.read(documentsStatusProvider.notifier).updateStatus(allUploaded);
      } catch (e) {
        state = AsyncValue.error(e, StackTrace.current);
      }
    }
  }

  Future<void> deleteFile(String documentType) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final fileUrl = state.value?[documentType];
    if (fileUrl == null || fileUrl.isEmpty) return;

    try {
      await FirebaseStorage.instance.refFromURL(fileUrl).delete();
      await FirebaseFirestore.instance
          .collection('owner_documents')
          .doc(user.uid)
          .update({documentType.replaceAll(' ', '_'): FieldValue.delete()});

      await fetchUploadedFiles();

      bool allUploaded =
          state.value?.values.every((value) => value != null) ?? false;
      ref.read(documentsStatusProvider.notifier).updateStatus(allUploaded);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

final documentsStatusProvider =
    StateNotifierProvider<DocumentsStatusNotifier, bool>(
      (ref) => DocumentsStatusNotifier(),
    );

class DocumentsStatusNotifier extends StateNotifier<bool> {
  DocumentsStatusNotifier() : super(false) {
    _checkDocumentsStatus();
  }

  /// **Check if all documents are uploaded**
  void _checkDocumentsStatus() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    FirebaseFirestore.instance
        .collection('owner_documents')
        .doc(user.uid)
        .snapshots()
        .listen((doc) {
          if (doc.exists) {
            bool allUploaded = [
              'Bank_Details',
              'Police_Clearance',
              'Driving_License',
              'Aadhar_Card_Front',
              'Aadhar_Card_Back',
              'Pan_Card',
            ].every(
              (field) =>
                  doc.data()?.containsKey(field) == true &&
                  doc[field] != null &&
                  doc[field].toString().isNotEmpty,
            ); // ✅ Check null & empty

            state = allUploaded; // ✅ Update Riverpod state
          }
        });
  }

  /// **Manually update the status**
  void updateStatus(bool newStatus) {
    state = newStatus;
  }
}
