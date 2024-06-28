import 'package:flutter/material.dart';
import 'package:mynote/view/login_page.dart';
import '../controller/user.dart';
import '../model/user_model.dart';
import 'input_form.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'My Note',
        home: Scaffold(
          appBar: AppBar(
            title: const Text('My Note',
                style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            actions: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.menu))
            ],
          ),
          resizeToAvoidBottomInset: false,
          body: const RegisterForm(),
        ));
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterForm();
}

class _RegisterForm extends State<RegisterForm> {
  final _registerFormKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool _passwordVisible = true;
  bool _confirmPasswordVisible = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      color: Colors.black87,
      child: Column(
        children: [
          const Row(
            children: [
              Expanded(
                  child: Center(
                child: Text(
                  'Register',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24),
                ),
              ))
            ],
          ),
          Form(
              key: _registerFormKey,
              child: Column(
                children: [
                  InputForm(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      textInputAction: TextInputAction.next,
                      labelText: 'Email',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        } else if (!isValidEmail(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      }),
                  InputForm(
                      keyboardType: TextInputType.text,
                      controller: userNameController,
                      textInputAction: TextInputAction.next,
                      labelText: 'User name',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your user name';
                        }
                        return null;
                      }),
                  InputForm(
                    keyboardType: TextInputType.text,
                    controller: passwordController,
                    obscureText: _passwordVisible,
                    textInputAction: TextInputAction.next,
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  InputForm(
                      keyboardType: TextInputType.text,
                      obscureText: _confirmPasswordVisible,
                      controller: confirmPasswordController,
                      textInputAction: TextInputAction.done,
                      labelText: 'Confirm password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _confirmPasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _confirmPasswordVisible = !_confirmPasswordVisible;
                          });
                        },
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your confirm password';
                        } else if (value != passwordController.text) {
                          return 'Confirm password is not valid password';
                        }
                        return null;
                      }),
                  Container(
                    margin: const EdgeInsets.only(top: 24),
                    child: Row(
                      children: [
                        Expanded(
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(6))),
                                onPressed: _submit,
                                child: const Text(
                                  'Register',
                                  style: TextStyle(color: Colors.black),
                                )))
                      ],
                    ),
                  )
                ],
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Do you already have an account!',
                style: TextStyle(color: Colors.white),
              ),
              TextButton(
                  onPressed: goLoginPage,
                  child: const Text(
                    'Login now',
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          )
        ],
      ),
    );
  }

  void goLoginPage() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LoginPage(),
        transitionDuration: const Duration(seconds: 1),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = const Offset(1.5, 0.0);
          var end = Offset.zero;
          var curve = Curves.ease;
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  Future<void> _submit() async {
    if (_registerFormKey.currentState!.validate()) {
      try {
        List<dynamic> user =
            await checkUserNameExist(userNameController.text.trim());
        if (user.isNotEmpty) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('User name exist!!!'),
              duration: Duration(seconds: 3),
            ),
          );
        } else {
          await createUser(UserModel(
            email: emailController.text,
            userName: userNameController.text,
            password: passwordController.text,
          ));
          if (!mounted) return;
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LoginPage()));
          // ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(
          //     content: Text('User saved successfully'),
          //     duration: Duration(seconds: 3),
          //   ),
          // );
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User saved failure'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill input')),
      );
    }
  }

  bool isValidEmail(String email) {
    String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(email);
  }
}
