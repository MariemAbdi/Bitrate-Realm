import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/category.dart';

class CategoryServices{
  final CollectionReference _categoriesCollection = FirebaseFirestore.instance.collection('categories');

  Future<List<Category>> getAllCategories() async {
    try {
      QuerySnapshot snapshot = await _categoriesCollection.get();
      return snapshot.docs
          .map((doc) => Category.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // Handle any errors appropriately
      debugPrint('Error fetching categories: $e');
      return [];
    }
  }

  Future<Category?> getCategory(String id) async {
    try {
      final docSnapshot = await _categoriesCollection.doc(id).get();

      if (docSnapshot.exists) {
        return Category.fromJson(docSnapshot.data()! as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching category: $e');
      return null;
    }
  }

}