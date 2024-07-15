import 'package:flutter/material.dart';

class CustomTextFieldWidet extends StatelessWidget {

  final TextEditingController? editingController;
  final IconData? iconData;
  final String? assetRef;
  final String? labelText;
  final bool? isObscore;

  const CustomTextFieldWidet ({
    super.key,
    this.editingController,
    this.iconData,
    this.assetRef,
    this.labelText,
    this.isObscore,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: editingController,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: iconData != null
          ? Icon(iconData)
          : Padding(
            padding: const EdgeInsets.all(8),
            child: Image.asset(assetRef.toString()),
            ),
        labelStyle: const TextStyle(
          fontSize: 18
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(
            color: Colors.grey
          )
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(
            color: Colors.grey
          )
        ),
      ),
      obscureText: isObscore!,
    );
  }
}