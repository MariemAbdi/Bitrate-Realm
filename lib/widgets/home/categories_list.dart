import 'package:bitrate_realm/services/category_services.dart';
import 'package:bitrate_realm/translations/locale_keys.g.dart';
import 'package:bitrate_realm/widgets/utils/custom_async_builder.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../models/category.dart';
import '../utils/custom_list.dart';
import '../utils/custom_outlined_button.dart';


class CategoriesList extends StatelessWidget {
  const CategoriesList({Key? key, required this.updateCategory, required this.selectedCategory}) : super(key: key);

  final String selectedCategory;
  final void Function(String) updateCategory;
  @override
  Widget build(BuildContext context) {
    return CustomAsyncBuilder(
        future: CategoryServices().getAllCategories(),
        builder: (context, categories){
          List<Category> categoriesList = [
            Category(id: "null", title: LocaleKeys.all.tr()),
            ...categories??[]
          ];
          return CustomListView(
              height: 50,
              itemCount: categoriesList.length,
              itemBuilder: (context, index){
                Category category = categoriesList[index];
                return CustomOutlinedButton(
                    isSelected: category.id == selectedCategory,
                    onPressed: ()=> updateCategory(category.id),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.all(10),
                    child: Text(category.title)
                );
              }
          );
        }
    );
  }
}
