import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:watch_it/watch_it.dart';

import '../../../app_colors.dart';
import '../../../data/user_repository/user_repository.dart';

class AddFavoriteCoin extends StatefulWidget {
  final String price;
  final String id;

  const AddFavoriteCoin({
    super.key,
    required this.id,
    required this.price,
  });

  @override
  State<AddFavoriteCoin> createState() => _AddFavoriteCoin();
}

class _AddFavoriteCoin extends State<AddFavoriteCoin> {
  bool isLogin = true;
  bool alertField = false;

  bool _valueError = false;
  bool _priceError = false;
  bool _upperTargetPriceError = false;
  bool _lowerTargetPriceError = false;

  bool updatingData = false;
  bool hasError = false; // Add this variable to track error state
  late TextEditingController _valueController;
  late TextEditingController _priceController;
  late TextEditingController _upperTargetPrice;
  late TextEditingController _lowerTargetPrice;
  late String errorString;

  @override
  void initState() {
    _valueController = TextEditingController();
    _priceController = TextEditingController(text: widget.price);
    _upperTargetPrice = TextEditingController();
    _lowerTargetPrice = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _valueController.dispose();
    _priceController.dispose();
    _upperTargetPrice.dispose();
    _lowerTargetPrice.dispose();
    super.dispose();
  }

  addToFavorites(context) async {
    setState(() {
      updatingData = true;
      hasError = false;
      FocusScope.of(context).unfocus();
    });

    if (_valueController.text.isEmpty) {
      setState(() {
        _valueError = true;
      });
    } else {
      setState(() {
        _valueError = false;
      });
    }

    if (_priceController.text.isEmpty) {
      setState(() {
        _priceError = true;
      });
    } else {
      setState(() {
        _priceError = false;
      });
    }

    if (alertField) {
      if (_upperTargetPrice.text.isEmpty) {
        setState(() {
          _upperTargetPriceError = true;
        });
      } else {
        setState(() {
          _upperTargetPriceError = false;
        });
      }

      if (_lowerTargetPrice.text.isEmpty) {
        setState(() {
          _lowerTargetPriceError = true;
        });
      } else {
        setState(() {
          _lowerTargetPriceError = false;
        });
      }
    }

    if (_valueError || _priceError || (_upperTargetPriceError && alertField) || (_lowerTargetPriceError && alertField)) {
      setState(() {
        updatingData = false;
      });
      return;
    }

    try {
      await di<UserRepository>().addToFavorites(
        id: widget.id,
        value: _valueController.text,
        price: _priceController.text,
      );
      if(alertField){
        await di<UserRepository>().addAlert(
          id: widget.id,
          upperTargetPrice: _upperTargetPrice.text,
          lowerTargetPrice: _lowerTargetPrice.text,
        );
      }

      Navigator.of(context).pop();
    } catch (error) {
      debugPrint(error.toString());
      setState(() {
        hasError = true;
        showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: const Text('Error'),
              content: const Text("errorString"),
              actions: [
                CupertinoDialogAction(
                  child: const Text(
                    'OK',
                    style: TextStyle(color: AppColors.whiteColor,),
                  ),
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
    debugPrint(widget.price);
    debugPrint('build AddFavoriteCoin');

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.blackColor,
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
            const SizedBox(height: 48,),
            SizedBox(
              height: 52,
              child: TextFormField(
                controller: _valueController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp('[0-9.]+')),
                ],
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(16),
                  labelText: 'Enter value',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: AppColors.mainRed,),
                  ),
                  labelStyle: TextStyle(
                    color: AppColors.labelStyleGrey,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 52,
              child: TextFormField(
                controller: _priceController,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp('[0-9.]+')),
                ],
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(16),
                  labelText: 'Price',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: AppColors.mainRed,),
                  ),
                  labelStyle: TextStyle(
                    color: AppColors.labelStyleGrey,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 48),
            Row(
              children: [
                GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(

                      alertField ? Icons.add_alert : Icons.add_alert_outlined,
                      size: 28,
                      color:  AppColors.labelStyleGrey,
                    ),
                  ),
                  onTap: () =>
                    setState(() {
                      alertField = !alertField;
                    }),
                ),
                const Flexible(
                  child: Text(
                    'Receive a push notification if the price goes up or down',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                    softWrap: true,
                    overflow: TextOverflow.visible,
                  ),
                )
              ],
            ),

            Visibility(
              visible: alertField,
              child: Column(
              children: [
                const SizedBox(height: 24),

                SizedBox(
                  height: 52,
                  child: TextFormField(
                    controller: _upperTargetPrice,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp('[0-9.]+')),
                    ],
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(16),
                      labelText: 'Enter upper target price',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: AppColors.mainRed,),
                      ),
                      labelStyle: TextStyle(
                        color: AppColors.labelStyleGrey,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 52,
                  child: TextFormField(
                    controller: _lowerTargetPrice,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp('[0-9.]+')),
                    ],
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(16),
                      labelText: 'Enter lower target price',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: AppColors.mainRed,),
                      ),
                      labelStyle: TextStyle(
                        color: AppColors.labelStyleGrey,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
              ),),

            const Expanded(
              child: SizedBox(),
            ),

            SizedBox(
              height: 52,
              child: updatingData
                  ? const CircularProgressIndicator(
                      color: AppColors.mainGreen,
                      strokeWidth: 2,
                    )
                  : ElevatedButton(
                      onPressed: () {
                        addToFavorites(context);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: AppColors.mainGreen,
                        //  backgroundColor: Colors.green, // Text color
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: const BorderSide(
                              color: AppColors.mainGreen,
                            )),
                        // padding: const EdgeInsets.symmetric(
                        //     horizontal: 16.0, vertical: 16.0),
                      ),
                      child: const Text('ADD'),
                      //  const Icon(Icons.add),
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
