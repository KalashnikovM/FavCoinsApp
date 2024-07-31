import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../app_colors.dart';
import '../../data/user_repository/user_repository.dart';
import '../../router/router.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _emailController;
  late TextEditingController _currentPasswordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmNewPasswordController;
  String get error => di<UserRepository>().error;
  bool _passwordVisible = false;
  bool updating = false;
  bool _saveButtonEnabled = false;

  @override
  void initState() {
    _emailController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmNewPasswordController = TextEditingController();
    _currentPasswordController = TextEditingController();

    _emailController.addListener(_checkForChanges);
    _newPasswordController.addListener(_checkForChanges);
    _confirmNewPasswordController.addListener(_checkForChanges);
    _currentPasswordController.addListener(_checkForChanges);

    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    _currentPasswordController.dispose();

    super.dispose();
  }

  void _checkForChanges() {
    setState(() {
      _saveButtonEnabled = _emailController.text.isNotEmpty ||
          _newPasswordController.text.isNotEmpty || _currentPasswordController.text.isNotEmpty;
    });
  }

  void _validateAndSave() {
    if (_newPasswordController.text != _confirmNewPasswordController.text) {
      alertDialog(context, 'Passwords do not match');
      return;
    }

    if (_emailController.text.isEmpty || !_emailController.text.contains('@')) {
      alertDialog(context, 'Please enter a valid email');
      return;
    }

    if (_currentPasswordController.text.isEmpty) {
      alertDialog(context, 'Please enter current password');
      return;
    }

    // Call save function (update user details)
    saveUserProfile();
  }

  void saveUserProfile() async {
    setState(() {
      updating = true;
      FocusScope.of(context).unfocus();
    });

    bool res = await di<UserRepository>().updateUserProfile(
      email: _emailController.text,
      newPassword: _newPasswordController.text,
      oldPassword: _currentPasswordController.text
    );

    if (res) {
      Navigator.of(context).pop();
    } else {
      setState(() {
        updating = false;
        alertDialog(context, di<UserRepository>().error);
      });
    }
  }

  void deleteUserProfile() async {
    setState(() {
      updating = true;
      FocusScope.of(context).unfocus();
    });
    AppRouter().maybePop();

    bool res = await di<UserRepository>().deleteUserProfile();

    if (res) {
      Navigator.of(context).pop();
      AppRouter().maybePop();
    } else {
      setState(() {
        updating = false;
        alertDialog(context, di<UserRepository>().error);
      });
    }
  }

  alertDialog(context, errorString) {
    return showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Error'),
          content: Text(errorString),
          actions: [
            CupertinoDialogAction(
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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.modalBackgroundColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.boxDecorationGrey,
                  borderRadius: BorderRadius.circular(10),
                ),
                width: 60,
                height: 8,
              ),
            ),
            const Expanded(
              child: SizedBox(),
            ),
            SizedBox(
              height: 52,
              child: TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(16),
                  labelText: 'Enter your new email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: AppColors.mainRed),
                  ),
                  labelStyle: TextStyle(
                    color: AppColors.textFieldBorderColor,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 52,
              child: TextFormField(
                controller: _currentPasswordController,
                obscureText: !_passwordVisible,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(16),
                  labelText: 'Enter your current password',
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: AppColors.mainRed),
                  ),
                  labelStyle: const TextStyle(
                    color: AppColors.textFieldBorderColor,
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
                        color: AppColors.textFieldBorderColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 52,
              child: TextFormField(
                controller: _newPasswordController,
                obscureText: !_passwordVisible,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(16),
                  labelText: 'Enter your new password',
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: AppColors.mainRed),
                  ),
                  labelStyle: const TextStyle(
                    color: AppColors.textFieldBorderColor,
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
                        color: AppColors.textFieldBorderColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 52,
              child: TextFormField(
                controller: _confirmNewPasswordController,
                obscureText: !_passwordVisible,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(16),
                  labelText: 'Confirm your new password',
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: AppColors.mainRed),
                  ),
                  labelStyle: const TextStyle(
                    color: AppColors.textFieldBorderColor,
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
                        color: AppColors.textFieldBorderColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Expanded(
              flex: 3,
              child: SizedBox(),
            ),
            if (updating)
              const CircularProgressIndicator(
                color: AppColors.mainGreen,
                strokeWidth: 2,
              )
            else
              ElevatedButton(
                onPressed: _saveButtonEnabled ? _validateAndSave : null,
                style: ElevatedButton.styleFrom(
                  // foregroundColor: AppColors.mainGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: const BorderSide(
                      color: AppColors.mainGreen,
                    ),
                  ),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'SF Pro Text',
                    color: AppColors.mainGreen,
                  ),
                ),
              ),
            const Expanded(
              child: SizedBox(),
            ),
            ElevatedButton(
              onPressed: () => showCupertinoModalPopup<void>(
                context: context,
                builder: (BuildContext context) => CupertinoActionSheet(
                  cancelButton: CupertinoActionSheetAction(
                    isDefaultAction: true,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Cancel",
                    ),
                  ),
                  actions: <CupertinoActionSheetAction>[
                    CupertinoActionSheetAction(
                      isDestructiveAction: true,
                      onPressed: () {
                        Navigator.pop(context);
                      deleteUserProfile();
                      },
                      child: const Text(
                        'Delete',
                      ),
                    ),
                  ],
                ),
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: AppColors.mainRed,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  side: const BorderSide(
                    color: AppColors.mainRed,
                  ),
                ),
              ),
              child: const Text(
                'Delete Profile',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'SF Pro Text',
                  color: AppColors.mainRed,
                ),
              ),
            ),
            const Expanded(
              child: SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
