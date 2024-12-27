import 'package:bitrate_realm/config/app_style.dart';
import 'package:bitrate_realm/config/validators.dart';
import 'package:bitrate_realm/services/category_services.dart';
import 'package:bitrate_realm/widgets/utils/custom_async_builder.dart';
import 'package:flutter/material.dart';

import '../../models/category.dart';

class CategoryDropdown extends StatelessWidget {
  const CategoryDropdown({Key? key, required this.selectedCategory, this.onChanged}) : super(key: key);

  final Category? selectedCategory;
  final void Function(Category?)? onChanged;
  @override
  Widget build(BuildContext context) {
    return CustomAsyncBuilder(
        future: CategoryServices().getAllCategories(),
        builder: (context, categories){
          return DropdownButtonFormField<Category>(
              validator: Validators().categoryValidation,
              icon: const Icon(Icons.keyboard_arrow_down, color: MyThemes.primaryColor),
              value: selectedCategory,
              dropdownColor: MyThemes.secondaryColor,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                  label: Text("Category"),
                  hintText: "Category",
                  prefixIcon: Icon(Icons.category)
              ),
              items: categories!
                  .map<DropdownMenuItem<Category>>((Category category) {
                return DropdownMenuItem<Category>(
                  value: category,
                  child: Text(
                    category.title,
                  ),
                );
              }).toList(),
              onChanged: onChanged
          );
        }
    );
  }
}
