import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../models/on_boarding.dart';
import '../config/app_style.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final GetStorage getStorage = GetStorage();

  int _currentPage = 0;
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController();
    super.initState();
  }

  List bgColors = [
    const Color(0xffffaf4e),
    const Color(0xff1eb090),
    const Color(0xffffbe97),
    MyThemes.primaryLight,//Colors.indigo.shade500,
  ];

  List buttonColors = [
    MyThemes.primaryLight,
    const Color(0xffffaf4e),
    const Color(0xff1eb090),
    const Color(0xffffbe97),
  ];

  AnimatedContainer _buildDots({
    int? index,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(50),
        ),
        color: buttonColors[_currentPage],
      ),
      margin: const EdgeInsets.only(right: 5),
      height: 10,
      curve: Curves.easeIn,
      width: _currentPage == index ? 20 : 10,
    );
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final double blockV = height / 100;

    return Scaffold(
      backgroundColor: bgColors[_currentPage],
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: PageView.builder(
                physics: const BouncingScrollPhysics(),
                controller: _controller,
                onPageChanged: (value) => setState(() => _currentPage = value),
                itemCount: contents.length,
                itemBuilder: (context, i) {
                  return Column(
                    children: [
                      //FIRST & SKIP BUTTONS
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //FIRST
                          _currentPage==0?Container(height: 20,):TextButton(
                            onPressed: () {
                              _controller.jumpToPage(0);
                            },
                            style: TextButton.styleFrom(
                              elevation: 0,
                              textStyle: GoogleFonts.ptSans(fontWeight: FontWeight.w600,
                                fontSize: 12,),
                            ),
                            child: Text(
                              "FIRST",
                              style: GoogleFonts.ptSansCaption(
                                  textStyle: TextStyle(
                                      color: Colors.grey.shade800,
                                      decoration: TextDecoration.underline)),
                            ),
                          ),

                          //SKIP
                          _currentPage==bgColors.length-1?Container(height: 20,):TextButton(
                            onPressed: () {
                              _controller.jumpToPage(3);
                            },
                            style: TextButton.styleFrom(
                              elevation: 0,
                              textStyle: GoogleFonts.ptSans(fontWeight: FontWeight.w600,
                                fontSize: 12,),
                            ),
                            child: Text(
                              "SKIP",
                              style: GoogleFonts.ptSansCaption(
                                  textStyle: const TextStyle(
                                      color: Colors.white,
                                      decoration: TextDecoration.underline)),
                            ),
                          ),
                        ],
                      ),
                      //IMAGE, TITLE & DESCRIPTION
                      Padding(
                        padding: const EdgeInsets.only(left: 40, right: 40),
                        child: Column(
                          children: [
                            Lottie.asset(
                              contents[i].imageUrl,
                              height: blockV * 35,
                              width: width*0.8
                            ),
                            SizedBox(
                              height: (height >= 840) ? 60 : 30,
                            ),
                            Text(
                              contents[i].title,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.ptSans(
                                  textStyle: GoogleFonts.ptSans(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 25,
                                      color: Colors.white,
                                  ),),
                            ),
                            const SizedBox(height: 15),
                            Flexible(
                              child: Text(
                                contents[i].description,
                                style: GoogleFonts.ptSansCaption(
                                    textStyle: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 16,
                                        color: Colors.grey.shade900)),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.fade,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            //FOOTER
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _currentPage + 1 == contents.length
                      ? Padding(
                          padding: const EdgeInsets.all(30),
                          child: ElevatedButton(
                            onPressed: () {
                              getStorage.write("onBoarding", true);
                              //Navigator.popAndPushNamed(context, LoginScreen.routeName);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange.shade600,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              padding: (width <= 550) //Button's padding
                                  ? const EdgeInsets.symmetric(
                                      horizontal: 100, vertical: 20)
                                  : EdgeInsets.symmetric(
                                      horizontal: width * 0.2, vertical: 25),
                              textStyle: GoogleFonts.ptSans(fontSize: 13)
                            ),
                            child: const Text("START"),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: _currentPage==0?null:(){
                                  _controller.previousPage(
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeIn,
                                  );
                                },
                                style: IconButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  elevation: 0,
                                  padding: (width <= 550)
                                      ? const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10)
                                      : const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 25),
                                ),
                                child: const Icon(
                                  CupertinoIcons.arrowtriangle_left_fill,
                                  color: Colors.black,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  contents.length,
                                      (int index) => _buildDots(
                                    index: index,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  _controller.nextPage(
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeIn,
                                  );
                                },
                                style: IconButton.styleFrom(
                                  backgroundColor: buttonColors[_currentPage],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  elevation: 0,
                                  padding: (width <= 550)
                                      ? const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10)
                                      : const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 25),
                                ),
                                child: const Icon(
                                  CupertinoIcons.arrowtriangle_right_fill,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
