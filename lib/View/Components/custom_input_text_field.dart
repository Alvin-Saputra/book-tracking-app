import 'package:book_tracker_app/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  const CustomInputField({
    required this.label,
    required this.controller,
    this.validator,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    // Dekorasi yang sama seperti sebelumnya
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
      // Kita gunakan hintText karena label sudah ada di luar
      hintText: 'Enter $label',
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- LABEL MANUAL ---
        Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: 8.0), // Jarak antara label dan text field
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          decoration: inputDecoration,
        ),
      ],
    );
  }
}
