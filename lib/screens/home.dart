import 'package:flutter/material.dart';
import 'package:livestream/constants/spacing.dart';

import '../../widgets/custom_outlined_button.dart';
import '../../widgets/home/home_app_bar.dart';
import '../../widgets/utils/custom_list.dart';
import '../config/app_style.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //FirebaseStorageServices _firebaseStorageServices = FirebaseStorageServices();

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: const HomeAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          //padding: const EdgeInsets.all(10),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 600,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomListView(
                    isVertical: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: 15,
                    itemBuilder: (context, index){
                      return const Padding(
                        padding: EdgeInsets.only(right: 5),
                        child: CustomOutlinedButton(
                          aspectRatio: 2,
                            child: Text("Category")
                        ),
                      );
                    }
                ),

                kVerticalSpace,

                CustomListView(
                    isVertical: 120,
                    itemCount: 15,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemBuilder: (context, index){
                      return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: CustomOutlinedButton(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: Image.network(
                                          "https://cdn.pixabay.com/photo/2022/11/10/07/15/portrait-7582123_640.jpg",
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.cover, // Ensures the image covers the area without exceeding
                                        ),
                                      ),
                                    )
                                ),
                              ),

                              Container(
                                width: 90,
                                margin: const EdgeInsets.symmetric(vertical: 3),
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: MyThemes.primaryColor.withOpacity(0.75),
                                ),
                                child: const Text("Mariem Abdi", style: TextStyle(color: Colors.white, overflow: TextOverflow.ellipsis, fontSize: 12), textAlign: TextAlign.center,),
                              )
                            ],
                          )
                      );
                    }
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }
}
