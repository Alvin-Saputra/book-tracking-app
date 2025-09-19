import 'package:book_tracker_app/Controller/user_controller.dart';
import 'package:book_tracker_app/Model/remote/authentication_api_service.dart';
import 'package:book_tracker_app/View/Components/bottom_navigation_widget.dart';
import 'package:book_tracker_app/View/Components/custom_input_text_field.dart';
import 'package:book_tracker_app/View/Screens/registration_screen.dart';
import 'package:book_tracker_app/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 32.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/icon/icon_outline.png'),
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 64.0, left: 32.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Login",
                      style: GoogleFonts.roboto(
                        fontSize: 32.0,
                        fontWeight: FontWeight.w400,
                        color: AppColors.text,
                      ),
                    ),
                  ],
                ),
              ),
              Form(
                key: formKey,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 32.0,
                    right: 32.0,
                    top: 48.0,
                    bottom: 24.0,
                  ),
                  child: Column(
                    children: [
                      CustomInputField(
                        validator: (value) => (value == null || value.isEmpty)
                            ? "Enter Your Email"
                            : null,
                        controller: emailController,
                        label: 'Email',
                      ),
                      const SizedBox(height: 16.0),
                      CustomInputField(
                        validator: (value) => (value == null || value.isEmpty)
                            ? "Enter Your Password"
                            : null,
                        controller: passwordController,
                        label: 'Password',
                        isPassword: true,
                      ),
                      const SizedBox(height: 32.0),

                      Consumer<UserController>(
                        builder:
                            (
                              BuildContext context,
                              UserController controller,
                              Widget? child,
                            ) {
                              return SizedBox(
                                width: double.infinity,
                                child: (controller.isLoading)
                                    ? Center(child: CircularProgressIndicator())
                                    : ElevatedButton(
                                        onPressed: () async {
                                          if (formKey.currentState!
                                              .validate()) {
                                            try {
                                              bool isSuccess = await controller
                                                  .loginUser(
                                                    emailController.text,
                                                    passwordController.text,
                                                  );

                                              if (isSuccess && mounted) {
                                                Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        BottomNavigationWidget(),
                                                  ),
                                                  (Route<dynamic> route) =>
                                                      false,
                                                );
                                              }
                                            } catch (error) {
                                              if (mounted) {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      "${error.toString().replaceFirst('Exception: ', '')}",
                                                    ),
                                                    duration: Duration(
                                                      seconds: 3,
                                                    ),
                                                  ),
                                                );
                                              }
                                            }
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          backgroundColor: AppColors.secondary,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 16,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              32.0,
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          "Login",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                              );
                            },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24.0),
              Text(
                "Or Login With",
                style: GoogleFonts.roboto(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 16.0),
              Divider(
                color: Colors.grey.shade400,
                thickness: 1,
                indent: 32,
                endIndent: 32,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24.0, bottom: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: FaIcon(FontAwesomeIcons.google, size: 28),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: FaIcon(FontAwesomeIcons.facebook, size: 28),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return RegistrationScreen();
                      },
                    ),
                  );
                },
                child: Text(
                  "Don't have account? Sign Up here",
                  style: GoogleFonts.roboto(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    color: AppColors.text,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
