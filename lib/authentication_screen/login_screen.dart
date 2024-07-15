import 'package:flutter/material.dart';
import 'package:gamematch/Controlers/authentication_controller.dart';
import 'package:gamematch/authentication_screen/registration_screen.dart';
import 'package:gamematch/widgets/custom_text_field_widget.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  bool showProgressBar = false;
  var controllerAuth = AuthenticationController.authController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [ 

              //space
              const SizedBox(
                height: 120,
              ),

              Image.asset("images/GameMatch.png", width: 200 ,), //Default Image

              const Text(
                "Welcome",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold
                ),
              ),

              const Text(
                "Login to find new gamers",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),
              ),
              
              //space
              const SizedBox(
                height: 28,
              ),

              //email
              SizedBox(
                width: MediaQuery.of(context).size.width -36,
                height: 55,
                child: CustomTextFieldWidet(
                  editingController: emailTextEditingController,
                  labelText: "Email",
                  iconData: Icons.email_outlined,
                  isObscore: false,
                ),
              ),
              
              //space
              const SizedBox(
                height: 14,
              ),

              //password
              SizedBox(
                width: MediaQuery.of(context).size.width -36,
                height: 55,
                child: CustomTextFieldWidet(
                  editingController: passwordTextEditingController,
                  labelText: "Password",
                  iconData: Icons.lock_outline,
                  isObscore: true,
                ),
              ),

              //space
              const SizedBox(
                height: 30,
              ),

              //login button
              Container(
                width: MediaQuery.of(context).size.width -36,
                height: 55,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: InkWell(
                  onTap: () async{
                    if (emailTextEditingController.text.trim().isNotEmpty && passwordTextEditingController.text.trim().isNotEmpty){
                      setState(() {
                        showProgressBar = true;
                      });

                      await controllerAuth.loginUser(emailTextEditingController.text.trim(), passwordTextEditingController.text.trim());

                      setState(() {
                        showProgressBar = false;
                      });
                    }else{
                      Get.snackbar("Email or Password is Missing", "Please fill all fields");
                    }
                  },
                  child: const Center(
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              //space
              const SizedBox(
                height: 16,
              ),

              //Don't have a account button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an Account",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),

                  InkWell(
                    onTap: (){
                       Get.to(const RegistrationScreen());
                    },
                    child: const Text(
                      "Create here",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  
                ],
              ),

              //space
              const SizedBox(
                height: 16,
              ),

              //Progress Bar
              showProgressBar == true 
                ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
                ) : Container(),

            ],
          ),
        ),
      ),
    );
  }
}