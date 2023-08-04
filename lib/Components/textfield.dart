import 'package:flutter/material.dart';

class CustomTextFormField extends FormField<String> {
  CustomTextFormField({
    Key? key,
    FormFieldValidator<String>? validator,
    TextEditingController? controller,
    TextInputType keyboardType = TextInputType.text,
    String? hintText,
    int maxLines = 1,
    Widget? suffixIcon,
    Widget? prefixIcon,
  }) : super(
          key: key,
          validator: validator,
          builder: (FormFieldState<String> state) {
            return TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              maxLines: maxLines,
              decoration: InputDecoration(
                hintText: hintText,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                errorText: state.errorText,
                suffixIcon: suffixIcon,
                prefixIcon: prefixIcon, 
              ),
            );
          },
        );
}
