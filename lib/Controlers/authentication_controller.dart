import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gamematch/authentication_screen/login_screen.dart';
import 'package:gamematch/homeScreen/home_screen.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gamematch/models/person.dart' as personModel;

class AuthenticationController extends GetxController {
  // Get instance of AuthenticationController
  static AuthenticationController authController = Get.find();

  // Reactive variable to hold the current Firebase user
  late Rx<User?> firebaseCurrentUser;

  // Reactive variable to hold the picked image file
  late Rx<File?> pickedFile;
  // Getter for the profile image
  File? get profileImage => pickedFile.value;
  XFile? imageFile;

  // Method to pick image file from gallery
  pickImageFileFromGallery() async {
    imageFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      Get.snackbar("Profile Image", "You have successfully picked your profile image");
    }

    pickedFile = Rx<File?>(File(imageFile!.path));
  }

  // Method to capture image file from camera
  captureImageFileFromCamera() async {
    imageFile = await ImagePicker().pickImage(source: ImageSource.camera);

    if (imageFile != null) {
      Get.snackbar("Profile Image", "You have successfully picked your profile image");
    }

    pickedFile = Rx<File?>(File(imageFile!.path));
  }

  // Method to upload image to storage
  Future<String> uploadImageToStorage(File imageFile) async {
    Reference referenceStorage = FirebaseStorage.instance.ref()
        .child("Profile Images").child(FirebaseAuth.instance.currentUser!.uid);

    UploadTask task = referenceStorage.putFile(imageFile);
    TaskSnapshot snapshot = await task;

    String downloadUrlOfImage = await snapshot.ref.getDownloadURL();

    return downloadUrlOfImage;
  }

  // Method to create a new user account
  createNewUserAccount(File imageProfile, String email, String password, String name, String age, String country, String aboutme, String games) async {
    try {
      //1. Authenticate user and create user with email and password
      UserCredential credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      //2. Upload image to storage
      String urlOfDownloadedImage = await uploadImageToStorage(imageProfile);

      //3. Save user to firestore database
      personModel.Person personInstance = personModel.Person(
        uid: FirebaseAuth.instance.currentUser!.uid,
        imageProfile: urlOfDownloadedImage,
        email: email,
        password: password,
        name: name,
        age: int.parse(age),
        country: country,
        aboutme: aboutme,
        games: games,
      );

      await FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser!.uid)
          .set(personInstance.toJson());

      Get.snackbar("Account Created", "Your account has been created");
      Get.to(const HomeScreen());
    } catch (errorMsg) {
      Get.snackbar("Account Creation Unsuccessful", "Error occurred: $errorMsg");
    }
  }

  // Method to login user
  loginUser(String emailUser, String passwordUser) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailUser, password: passwordUser);
      Get.snackbar("Login Successful", "You are logged-in successfully");
      Get.to(HomeScreen());
    } catch (errorMsg) {
      Get.snackbar("Login Failed", "Error occurred: $errorMsg");
    }
  }

  // Method to check if user is logged in
  checkIfUserLoggedIn(User? currentUser) {
    if (currentUser == null) {
      Get.to(LoginScreen());
    } else {
      Get.to(HomeScreen());
    }
  }

  @override
  void onReady() {
    super.onReady();

    // Bind the firebase auth state changes to the reactive variable
    firebaseCurrentUser = Rx<User?>(FirebaseAuth.instance.currentUser);
    firebaseCurrentUser.bindStream(FirebaseAuth.instance.authStateChanges());

    // Execute checkIfUserLoggedIn method whenever firebaseCurrentUser changes
    ever(firebaseCurrentUser, checkIfUserLoggedIn);
  }
}