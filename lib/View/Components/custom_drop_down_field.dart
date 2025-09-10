import 'package:book_tracker_app/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDropdownField extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final void Function(String?)? onChanged;
  final String? Function(String?)? validator;

  const CustomDropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: AppColors.tertiary,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(32.0),
        borderSide: const BorderSide(color: AppColors.tertiary, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(32.0),
        borderSide: const BorderSide(color: AppColors.secondary, width: 2.0),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: 8.0),
        DropdownButtonFormField<String>(
          value: value,
          items: items.map((String genre) {
            return DropdownMenuItem<String>(
              value: genre,
              child: Text(
                genre,
                style: GoogleFonts.roboto(fontSize: 16, color: AppColors.text),
              ),
            );
          }).toList(),
          onChanged: onChanged,
          validator: validator,
          decoration: inputDecoration.copyWith(hintText: 'Select $label'),
          isExpanded: true, // Agar dropdown selebar parent
        ),
      ],
    );
  }
}
