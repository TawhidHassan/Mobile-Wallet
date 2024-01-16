import 'dart:ui';

import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget {
  final String? balance;
  CustomAppBar({Key? key, this.balance="0.0"}) : super(key: key);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool _isAnimation = false;
  bool _isBallanceShown = false;
  bool _isBallance = true;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: changeState,
        child: Container(
            width: 160,
            height: 34,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50)),
            child: Stack(
                alignment: Alignment.center,
                children: [
              ///৳ 50.00
              AnimatedOpacity(
                  opacity: _isBallanceShown ? 1 : 0,
                  duration: Duration(milliseconds: 500),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Text(widget.balance??"",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor, fontSize: 16)),
                  )),

              /// ব্যালেন্স দেখুন
              AnimatedOpacity(
                  opacity: _isBallance ? 1 : 0,
                  duration: const Duration(milliseconds: 300),
                  child:  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Text('See Balance',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor, fontSize: 16),textAlign: TextAlign.center,),
                  )),

              /// Circle
              AnimatedPositioned(
                  duration: const Duration(milliseconds: 1100),
                  left: _isAnimation == false ? 5 : 135,
                  curve: Curves.fastOutSlowIn,
                  child: Container(
                      height: 24,
                      width: 24,
                      // padding: const EdgeInsets.only(bottom: 4),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(50)),
                      child: const FittedBox(
                          child: Text('৳',
                              style: TextStyle(color: Colors.white, fontSize: 18),
                            textAlign: TextAlign.center,
                          )
                      )
                  ))
            ])));
  }

  bkashLogo() =>
      SizedBox(width: 45, child: Image.asset('assets/bKash.png'));

  Widget userLogo() => CircleAvatar(
      backgroundColor: Colors.green.shade50,
      radius: 20,
      child: Icon(
        Icons.person,
        color: Theme
              .of(context)
              .primaryColor,
        size: 28,
      ));

  void changeState() async {
    _isAnimation = true;
    _isBallance = false;
    setState(() {});

    await Future.delayed(Duration(milliseconds: 800),
            () => setState(() => _isBallanceShown = true));
    await Future.delayed(
        Duration(seconds: 3), () => setState(() => _isBallanceShown = false));
    await Future.delayed(Duration(milliseconds: 200),
            () => setState(() => _isAnimation = false));
    await Future.delayed(
        Duration(milliseconds: 800), () => setState(() => _isBallance = true));
  }
}