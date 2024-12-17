import 'package:flutter/material.dart';

import '../custom_outlined_button.dart';
import '../utils/custom_list.dart';


class CategoriesList extends StatelessWidget {
  const CategoriesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomListView(
        height: 50,
        itemCount: 10,
        itemBuilder: (context, index){
          return const Padding(
            padding: EdgeInsets.only(right: 8),
            child: CustomOutlinedButton(
                aspectRatio: 2,
                child: Text("Category")
            ),
          );
        }
    );
  }
}
