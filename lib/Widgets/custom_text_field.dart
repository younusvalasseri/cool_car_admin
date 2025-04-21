import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;
  final bool isPassword;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool readOnly;
  final String? Function(String?)? validator;
  final List<String>? dropdownItems;
  final void Function(String?)? onChanged;
  final String? value; // ✅ Added value field to display selected dropdown
  final TextInputType? keyboardType; // ✅ Added keyboardType for text fields

  const CustomTextField({
    super.key,
    required this.hint,
    this.controller,
    this.isPassword = false,
    this.icon,
    this.onTap,
    this.readOnly = false,
    this.validator,
    this.dropdownItems,
    this.onChanged,
    this.value, // ✅ Store selected value for dropdowns
    this.keyboardType, // ✅ Allow different input types (numbers, text, etc.)
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 5,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: dropdownItems == null
            ? TextFormField(
                controller: controller,
                obscureText: isPassword,
                readOnly: readOnly,
                onTap: onTap,
                keyboardType: keyboardType, // ✅ Restored keyboardType support
                validator: validator,
                decoration: InputDecoration(
                  hintText: hint,
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 21, 102, 224),
                    ),
                  ),
                  prefixIcon: icon != null
                      ? Icon(icon,
                          color: const Color.fromARGB(255, 21, 102, 224))
                      : null,
                ),
                style: const TextStyle(fontSize: 16),
              )
            : DropdownButtonFormField<String>(
                value: value, // ✅ Show selected dropdown value
                decoration: InputDecoration(
                  hintText: hint,
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 21, 102, 224),
                    ),
                  ),
                  prefixIcon: icon != null
                      ? Icon(icon,
                          color: const Color.fromARGB(255, 21, 102, 224))
                      : null,
                ),
                items: dropdownItems!
                    .map((item) => DropdownMenuItem(
                          value: item,
                          child: Text(item),
                        ))
                    .toList(),
                onChanged: onChanged,
                validator: validator,
              ),
      ),
    );
  }
}
