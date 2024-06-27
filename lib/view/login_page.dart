import 'package:mynote/view/province_list_page.dart';
import 'package:flutter/material.dart';
import 'package:mynote/view/register_page.dart';
import '../controller/user.dart';
import '../helper/singleton_shared_preferences.dart';
import 'input_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
          body: const LoginForm(),
        ));
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginForm();
}

class _LoginForm extends State<LoginForm> {
  final _loginFormKey = GlobalKey<FormState>();

  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isLogin();
  }

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
                  'Login',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24),
                ),
              ))
            ],
          ),
          Form(
            key: _loginFormKey,
              child: Column(
            children: [
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
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  labelText: 'Password',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
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
                                borderRadius: BorderRadius.circular(6)
                              )
                            ),
                            onPressed: _login,
                            child: const Text('Login', style: TextStyle(color: Colors.black),)))
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 24),
                child: Row(
                  children: [
                    Expanded(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6)
                                )
                            ),
                            onPressed: () {},
                            child: const Text('Google', style: TextStyle(color: Colors.white),)))
                  ],
                ),
              )
            ],
          )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Do not have an account?',
                style: TextStyle(color: Colors.white),
              ),
              TextButton(
                  onPressed: goToRegisterPage,
                  child: const Text(
                    'Register now',
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          )
        ],
      ),
    );
  }

  void goToRegisterPage(){
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const RegisterPage(),
        transitionDuration: const Duration(seconds: 1),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = const Offset(-1.5, 0.0);
          var end = Offset.zero;
          var curve = Curves.ease;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  Future<dynamic> _login() async {
    try {
      List<dynamic> user = await getUserByUserNameAndPassword(
          userNameController.text, passwordController.text);
      if(user.isNotEmpty){
        final preferencesManager = PreferencesManager();
        await preferencesManager.init();
        await preferencesManager.saveInt('userId', user[0]['id']);
        await preferencesManager.saveString('userName', user[0]['userName']);
        if (!mounted) return;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ProvinceListPage())
        );
      }else{
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User name or password is incorrect!!!')),
        );
      }
    }catch(err){
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login failure')),
      );
    }
  }

  Future<dynamic> isLogin() async {
    final preferencesManager = PreferencesManager();
    await preferencesManager.init();
    final userId = preferencesManager.getInt('userId');
    if (!mounted) return;
    if(userId != null){
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const ProvinceListPage())
      );
    }
  }
}
