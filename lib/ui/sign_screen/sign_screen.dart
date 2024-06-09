import 'package:crypto_tracker/router/router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../data/user_repository/user_repository.dart';

class SignScreen extends StatefulWidget {
  const SignScreen({super.key});

  @override
  State<SignScreen> createState() => _SignScreenState();
}

class _SignScreenState extends State<SignScreen> {
  bool isLogin = true;
  bool authorization = false;
  bool _passwordVisible = true;
  bool hasError = false; // Add this variable to track error state
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  login() async {
    setState(() {
      authorization = true;
      hasError = false;
      FocusScope.of(context).unfocus();
    });

    try {
      if (isLogin) {
        await di<UserRepository>().loginUser(
          email: _emailController.text,
          password: _passwordController.text,
        );

      } else {
        await di<UserRepository>().registerUser(
          email: _emailController.text,
          password: _passwordController.text,
        );

      }
      // If successful, navigate to the next screen or do something else

    } catch (error) {
      debugPrint(error.toString());
      setState(() {
        hasError = true;
        String errorString = di<UserRepository>().error;

        // Show CupertinoAlertDialog
        showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: const Text('Error'),
              content: Text(errorString),
              actions: [
                CupertinoDialogAction(
                  child: const Text('OK', style: TextStyle(color: Colors.white),),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      });
    } finally {
      setState(() {
        authorization = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white10,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(10),
                ),
                width: 60,
                height: 8,
              ),
            ),
            const Expanded(child: SizedBox(),),
            SizedBox(
              height: 52,
              child: TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(16),
                  labelText: 'Enter your email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Color(0xFFFA2D48)),
                  ),
                  labelStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 52,
              child: TextFormField(
                controller: _passwordController,
                obscureText: _passwordVisible,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(16),
                  labelText: 'Enter your password',
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Color(0xFFFA2D48)),
                  ),
                  labelStyle: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                  suffix: InkWell(
                    splashColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    onTap: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Icon(
                        _passwordVisible
                            ? CupertinoIcons.eye_fill
                            : CupertinoIcons.eye_slash_fill,
                        color: CupertinoColors.systemGrey3,
                      ),
                    ),
                  ),
                ),
                // validator: (value) => value!.isValidPassword
                //     ? null
                //     : (S.of(context).password_error),
              ),
            ),
            const Expanded(child: SizedBox(),),

            authorization
                  ? const CircularProgressIndicator(
                color: Color(0xFF76CD26),
              strokeWidth: 2,
              )
                  : TextButton(
                child: Text(
                  isLogin ? 'Sign In' : 'Sign Up',
                  style: const TextStyle(
                    fontSize: 24,
                    fontFamily: 'SF Pro Text',
                    color: Color(0xFF76CD26),

                    // fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () => login(),
              ),

            const Expanded(child: SizedBox(),),
            TextButton(
                onPressed: () {
                  setState(() {
                    isLogin = !isLogin;
                  });
                },
                child: Text(
                  isLogin ? 'Sign Up' : 'Sign In',
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'SF Pro Text',
                    color: Color(0xFF76CD26),
                    // fontWeight: FontWeight.w600,
                  ),
                )),
            const Expanded(child: SizedBox(),),

          ],
        ),
      ),
    );
  }
}
