import 'package:dart_appwrite/dart_appwrite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mingle/api/auth/authentication.dart';
import 'package:mingle/providers/auth.dart';
import 'package:mingle/themes.dart';

enum Status {
  login,
  signUp,
}

Status type = Status.login;

class LoginPage extends ConsumerStatefulWidget {
  static const routename = '/LoginPage';

  const LoginPage({Key? key}) : super(key: key);
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _isLoading = false;

  void _loading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  void _switchType() {
    if (type == Status.signUp) {
      setState(() {
        type = Status.login;
      });
    } else {
      setState(() {
        type = Status.signUp;
      });
    }
  }

  void _showError(String error) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error Occured'),
        content: Text(error),
        actions: [
          TextButton(
            onPressed: (() {
              Navigator.of(context).pop();
            }),
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }

  late final Authentication auth = ref.watch(authProvider);

  Future<void> _onPressedFunction() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _loading();

    try {
      if (type == Status.login) {
        await auth.login(_email.text, _password.text);

        if (!mounted) {
          return;
        }

        await Navigator.pushReplacementNamed(context, 'HomePage.routename');
      } else {
        await auth.signUp(_email.text, _password.text);
        if (!mounted) {
          return;
        }

        await Navigator.pushReplacementNamed(
            context, 'CreateAccountPage.routename');
      }

      _loading();
    } on AppwriteException catch (e, st) {
      _showError(e.message!);
      _loading();
    }
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            reverse: true,
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height - 30,
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(
                            top: 40,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Image.asset(
                                  'assets/images/logo.png',
                                  height: 100,
                                ),
                              ),
                              const Spacer(
                                flex: 1,
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 14,
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 4),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 2,
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: TextFormField(
                                  controller: _email,
                                  autocorrect: true,
                                  enableSuggestions: true,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    hintText: 'Email address',
                                    hintStyle: TextStyle(
                                      color: MingleTheme.lightBlueShade,
                                    ),
                                    icon: Icon(
                                      Icons.email_outlined,
                                      color: Colors.blue.shade700,
                                      size: 24,
                                    ),
                                    alignLabelWithHint: true,
                                    border: InputBorder.none,
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty ||
                                        !value.contains('@')) {
                                      return 'Invalid email!';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 8,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 2,
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: TextFormField(
                                  controller: _password,
                                  obscureText: true,
                                  validator: (value) {
                                    if (value!.isEmpty || value.length < 8) {
                                      return 'Password is too short!';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Password',
                                    hintStyle: TextStyle(
                                      color: MingleTheme.lightBlueShade,
                                    ),
                                    icon: Icon(
                                      CupertinoIcons.lock_circle,
                                      color: Colors.blue.shade700,
                                      size: 24,
                                    ),
                                    alignLabelWithHint: true,
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              if (type == Status.signUp)
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 600),
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 8,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 2,
                                        color: Colors.white,
                                      ),
                                      borderRadius: BorderRadius.circular(12)),
                                  child: TextFormField(
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      hintText: 'Confirm password',
                                      hintStyle: TextStyle(
                                        color: MingleTheme.lightBlueShade,
                                      ),
                                      icon: Icon(
                                        CupertinoIcons.lock_circle,
                                        color: Colors.blue.shade700,
                                        size: 24,
                                      ),
                                      alignLabelWithHint: true,
                                      border: InputBorder.none,
                                    ),
                                    validator: type == Status.signUp
                                        ? ((value) {
                                            if (value != _password.text) {
                                              return 'Passwords do not match!';
                                            }
                                            return null;
                                          })
                                        : null,
                                  ),
                                ),
                              const Spacer(),
                            ],
                          ),
                        ),
                        flex: 3,
                      ),
                      Expanded(
                        child: SizedBox(
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(
                                  top: 32.0,
                                ),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                width: double.infinity,
                                child: _isLoading
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : MaterialButton(
                                        onPressed: _onPressedFunction,
                                        textColor: Colors.blue.shade700,
                                        textTheme: ButtonTextTheme.primary,
                                        minWidth: 100,
                                        padding: const EdgeInsets.all(18),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          side: BorderSide(
                                              color: Colors.blue.shade700),
                                        ),
                                        child: Text(
                                          (type == Status.login)
                                              ? 'Log in'
                                              : 'Sign up',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(
                                  top: 32.0,
                                ),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                width: double.infinity,
                                child: MaterialButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context)
                                        .showMaterialBanner(
                                      MaterialBanner(
                                          backgroundColor:
                                              MingleTheme.lightBlueShade,
                                          padding: const EdgeInsets.only(
                                            top: 16,
                                          ),
                                          content: const Text(
                                              'Gimme Credit Card and I will give you Google Authentication'),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  ScaffoldMessenger.of(context)
                                                      .clearMaterialBanners();
                                                },
                                                child:
                                                    const Text('Haha Noob Lol'))
                                          ]),
                                    );
                                  },
                                  color: Colors.blue.shade200,
                                  textColor: Colors.blue.shade700,
                                  minWidth: 100,
                                  padding: const EdgeInsets.all(18),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    side: BorderSide(
                                      color: Colors.blue.shade700,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      FaIcon(FontAwesomeIcons.google),
                                      Text(
                                        'Login with Google',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 24.0,
                                ),
                                child: RichText(
                                  text: TextSpan(
                                    text: type == Status.login
                                        ? 'Don\'t have an account? '
                                        : 'Already have an account? ',
                                    style: TextStyle(
                                      color: MingleTheme.whiteShade1,
                                    ),
                                    children: [
                                      TextSpan(
                                          text: type == Status.login
                                              ? 'Sign up now'
                                              : 'Log in',
                                          style: TextStyle(
                                            color: Colors.blue.shade700,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              _switchType();
                                            }),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        flex: 2,
                      ),
                    ],
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
