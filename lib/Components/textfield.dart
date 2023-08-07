import 'package:flutter/material.dart';
import 'package:flutter_firebase/constants/constants.dart';

class CustomTextFormField extends FormField<String> {
  CustomTextFormField({
    Key? key,
    FormFieldValidator<String>? validator,
    TextEditingController? controller,
    TextInputType keyboardType = TextInputType.text,
    String? hintText,
    int maxLines = 1,
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
                  borderSide: BorderSide(color: AppColors.colorGreen),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: AppColors.colorGreen),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Colors.red),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Colors.red),
                ),
                errorText: state.errorText,
                prefixIcon :prefixIcon,
              ),
            );
          },
        );
}
