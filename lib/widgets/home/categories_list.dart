import 'package:flutter/material.dart';

import '../utils/custom_list.dart';
import '../utils/custom_outlined_button.dart';


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
                child: Text("Category")
            ),
          );
        }
    );
  }
}
