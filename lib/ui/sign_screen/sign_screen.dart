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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          // border: Border.all(
          //              color: Colors.purple,
          //             width: 0.5,
          //           ),
          color: Colors.white10,
        ),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            const SizedBox(
              height: 8,
            ),
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(10),
                  // border: Border.all(
                  //              color: Colors.purple,
                  //             width: 0.5,
                  //           ),
                ),
                width: 60,
                height: 8,
              ),
            ),
            const SizedBox(
              height: 32,
            ),

            SizedBox(
              height: 52,
              child: TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.visiblePassword,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(16),
                  labelText: 'Enter your email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Color(0xFFFA2D48),),
                  ),
                  labelStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),

                ),
                // validator: (value) => value!.isValidPassword
                //     ? null
                //     : (S.of(context).password_error),
              ),
            ),

            const SizedBox(
              height: 32,
            ),

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
                    borderSide: BorderSide(color: Color(0xFFFA2D48),),
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




            const SizedBox(
              height: 16,
            ),


            ElevatedButton(

              child: authorization
                  ? const CircularProgressIndicator()
                  : Text(
                      isLogin ? 'SignIn' : 'SignUp',
                      style: const TextStyle(
                        fontSize: 17,
                        fontFamily: 'SF Pro Text',
                        // fontWeight: FontWeight.w600,
                        color: Color(0xFF76CD26),
                      ),
                    ),
              onPressed: () {
                setState(() {
                  authorization = true;
                  FocusScope.of(context).unfocus();
                  isLogin
                  ?  di<UserRepository>().registerUser(
                      email: _emailController.text,
                      password: _passwordController.text)
                  :  di<UserRepository>().loginUser(
                  email: _emailController.text,
                  password: _passwordController.text);
                });


                // di<AppRouter>().replace(const SplashRoute());
              },
            ),
            const SizedBox(
              height: 16,
            ),
            TextButton(
                onPressed: () {
                  setState(() {
                    isLogin = !isLogin;
                  });
                },
                child: Text(
                  isLogin ? 'SignUp' : 'SignIn',
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'SF Pro Text',
                    // fontWeight: FontWeight.w600,
                    color: Color(0xFF76CD26),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
