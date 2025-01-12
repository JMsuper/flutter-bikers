import 'package:bikers/pages/secondpage/regionAndCategory.dart';
import 'package:flutter/material.dart';
import 'package:select_dialog/select_dialog.dart';

class CategorySelctor {
  static Future selectCategoryNoBike(BuildContext context, int preSelected) async {
    List<String> categoryList = RegionNCategory.categoryListNoBike;
    String? selected;
    if (preSelected == -1) {
      await SelectDialog.showModal<String>(
        context,
        label: "Simple Example",
        showSearchBox: false,
        items: categoryList,
        onChange: (String item) {
          selected = item;
        },
      );
    } else {
      selected = categoryList[preSelected];
      await SelectDialog.showModal<String>(
        context,
        label: "Simple Example",
        showSearchBox: false,
        selectedValue: categoryList[preSelected],
        items: categoryList,
        onChange: (String item) {
          selected = item;
        },
      );
    }
    if (selected == null) {
      return -1;
    } else {
      return categoryList.indexOf(selected!);
    }
  }

    static Future selectCategoryWithBike(BuildContext context, int preSelected) async {
    List<String> categoryList = RegionNCategory.categoryListWithBike;
    String? selected;
    if (preSelected == -1) {
      await SelectDialog.showModal<String>(
        context,
        label: "Simple Example",
        showSearchBox: false,
        items: categoryList,
        onChange: (String item) {
          selected = item;
        },
      );
    } else {
      selected = categoryList[preSelected];
      await SelectDialog.showModal<String>(
        context,
        label: "Simple Example",
        showSearchBox: false,
        selectedValue: categoryList[preSelected],
        items: categoryList,
        onChange: (String item) {
          selected = item;
        },
      );
    }
    if (selected == null) {
      return -1;
    } else {
      return categoryList.indexOf(selected!);
    }
  }

  static Future selectRegion(BuildContext context, int preSelected) async {
    List<String> regionList = RegionNCategory.regionList;
    String? selected;
    if (preSelected == -1) {
      await SelectDialog.showModal<String>(
        context,
        label: "Simple Example",
        showSearchBox: false,
        items: regionList,
        onChange: (String item) {
          selected = item;
        },
      );
    } else {
      selected = regionList[preSelected];
      await SelectDialog.showModal<String>(
        context,
        label: "Simple Example",
        selectedValue: regionList[preSelected],
        showSearchBox: false,
        items: regionList,
        onChange: (String item) {
          selected = item;
        },
      );
    }
    if (selected == null) {
      return -1;
    } else {
      return regionList.indexOf(selected!);
    }
  }
}
