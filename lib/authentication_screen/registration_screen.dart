import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gamematch/authentication_screen/login_screen.dart';
import 'package:gamematch/widgets/custom_text_field_widget.dart';
import 'package:gamematch/Controlers/authentication_controller.dart';
import 'package:get/get.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  // Personal Info
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController ageTextEditingController = TextEditingController();
  TextEditingController countryTextEditingController = TextEditingController();
  TextEditingController aboutTextEditingController = TextEditingController();

  // Favorite Games
  TextEditingController gamesTextEditingController = TextEditingController();
  List<String> gamesList = ["League of Legends", "Counter Strike 2", "Call of Duty warzone", "Starfield", "Wuthering Waves", "Overcooked 2", "Party Animals", "GTA 5"];
  String? selectedGame;

  bool showProgressBar = false;
  var authenticationController = AuthenticationController.authController;

  void _showGamesDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Favorite Game'),
          content: SingleChildScrollView(
            child: ListBody(
              children: gamesList.map((game) {
                return RadioListTile<String>(
                  value: game,
                  groupValue: selectedGame,
                  title: Text(game),
                  onChanged: (String? value) {
                    setState(() {
                      selectedGame = value;
                      gamesTextEditingController.text = selectedGame ?? '';
                    });
                    Navigator.of(context).pop();
                    _showGamesDialog();
                  },
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 100,
              ),
              const Text(
                "Create Account",
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "To get Started Now.",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              authenticationController.imageFile == null
                  ? const CircleAvatar(
                      radius: 80,
                      backgroundImage: AssetImage("images/GameMatch.png"),
                      backgroundColor: Colors.black,
                    )
                  : Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey,
                        image: DecorationImage(
                          fit: BoxFit.fitHeight,
                          image: FileImage(File(authenticationController.imageFile!.path)),
                        ),
                      ),
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () async {
                      await authenticationController.pickImageFileFromGallery();
                      setState(() {
                        authenticationController.imageFile;
                      });
                    },
                    icon: const Icon(
                      Icons.image_outlined,
                      color: Colors.grey,
                      size: 30,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  IconButton(
                    onPressed: () async {
                      await authenticationController.captureImageFileFromCamera();
                      setState(() {
                        authenticationController.imageFile;
                      });
                    },
                    icon: const Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.grey,
                      size: 30,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Personal Info.",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width - 36,
                height: 55,
                child: CustomTextFieldWidet(
                  editingController: nameTextEditingController,
                  labelText: "Name",
                  iconData: Icons.person_outline,
                  isObscore: false,
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width - 36,
                height: 55,
                child: CustomTextFieldWidet(
                  editingController: emailTextEditingController,
                  labelText: "Email",
                  iconData: Icons.email_outlined,
                  isObscore: false,
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width - 36,
                height: 55,
                child: CustomTextFieldWidet(
                  editingController: passwordTextEditingController,
                  labelText: "Password",
                  iconData: Icons.lock_outline,
                  isObscore: true,
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width - 36,
                height: 55,
                child: CustomTextFieldWidet(
                  editingController: ageTextEditingController,
                  labelText: "Age",
                  iconData: Icons.numbers_outlined,
                  isObscore: false,
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width - 36,
                height: 55,
                child: CustomTextFieldWidet(
                  editingController: countryTextEditingController,
                  labelText: "Country",
                  iconData: Icons.location_city,
                  isObscore: false,
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width - 36,
                height: 55,
                child: CustomTextFieldWidet(
                  editingController: aboutTextEditingController,
                  labelText: "About Me",
                  iconData: Icons.book_outlined,
                  isObscore: false,
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width - 36,
                height: 55,
                child: TextField(
                  controller: gamesTextEditingController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Favorite Game",
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: _showGamesDialog,
                    ),
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              Container(
                width: MediaQuery.of(context).size.width - 36,
                height: 55,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: InkWell(
                  onTap: () async {
                    if (authenticationController.imageFile != null) {
                      if (nameTextEditingController.text.trim().isNotEmpty &&
                          emailTextEditingController.text.trim().isNotEmpty &&
                          passwordTextEditingController.text.trim().isNotEmpty &&
                          ageTextEditingController.text.trim().isNotEmpty &&
                          countryTextEditingController.text.trim().isNotEmpty &&
                          aboutTextEditingController.text.trim().isNotEmpty &&
                          gamesTextEditingController.text.trim().isNotEmpty) {
                        setState(() {
                          showProgressBar = true;
                        });

                        await authenticationController.createNewUserAccount(
                          authenticationController.profileImage!,
                          emailTextEditingController.text.trim(),
                          passwordTextEditingController.text.trim(),
                          nameTextEditingController.text.trim(),
                          ageTextEditingController.text.trim(),
                          countryTextEditingController.text.trim(),
                          aboutTextEditingController.text.trim(),
                          gamesTextEditingController.text.trim(),
                        );

                        setState(() {
                          showProgressBar = false;
                        });
                      } else {
                        Get.snackbar("A field is empty", "Fill out all fields in the text fields");
                      }
                    } else {
                      Get.snackbar("Image File Missing", "Please choose a picture or take one");
                    }
                  },
                  child: const Center(
                    child: Text(
                      "Register",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account?",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(const LoginScreen());
                    },
                    child: const Text(
                      "Login here",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  showProgressBar
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
                        )
                      : Container(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}