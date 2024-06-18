import 'package:crypto_tracker/router/router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../../data/user_repository/user_repository.dart';


class AddFavoriteCoin extends StatefulWidget {
  final String price;
  final String id;

  const AddFavoriteCoin({super.key,
    required this. id,
    required this.price,
  });


  @override
  State<AddFavoriteCoin> createState() => _AddFavoriteCoin();
}

class _AddFavoriteCoin extends State<AddFavoriteCoin> {
  bool isLogin = true;
  bool updatingData = false;
  bool hasError = false; // Add this variable to track error state
  late TextEditingController _valueController;
  late TextEditingController _priceController;
  late String errorString;



  @override
  void initState() {
    _valueController = TextEditingController();
    _priceController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _valueController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  addToFavorites(context) async {
    setState(() {
      updatingData = true;
      hasError = false;
      FocusScope.of(context).unfocus();
    });

    try {

        await di<UserRepository>().addToFavorites(
          id: widget.id,
          value: _valueController.text,
          price: _priceController.text,
        );







      Navigator.of(context).pop();
    } catch (error) {
      debugPrint(error.toString());
      setState(() {
        hasError = true;
      //  errorString = di<UserRepository>().error;

        showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: const Text('Error'),
              content: Text("errorString"),
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
        updatingData = false;
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
                controller: _valueController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(16),
                  labelText: 'Enter value',
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
                controller: _priceController,
                keyboardType: TextInputType.visiblePassword,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(16),
                  labelText: 'Enter price',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Color(0xFFFA2D48)),
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
            const Expanded(child: SizedBox(),),

            updatingData
                ? const CircularProgressIndicator(
              color: Color(0xFF76CD26),
              strokeWidth: 2,
            )
                : TextButton(
                    child: const Text(
                    'Add',
                      style: TextStyle(
                        fontSize: 24,
                        fontFamily: 'SF Pro Text',
                        color: Color(0xFF76CD26),

                        // fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () { addToFavorites(context); },
            ),

            const Expanded(child: SizedBox(),),

          ],
        ),
      ),
    );
  }
}
