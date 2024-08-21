import 'package:flutter/material.dart';
import 'package:get/get.dart';
void showSnackBarMessage(BuildContext context, String message, [bool isError = false]){
  
  Get.snackbar("TaskManager: ",message,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: isError ? Colors.red : null,

  );
  /*ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
    backgroundColor: isError ? Colors.red : null,
  ));*/
}