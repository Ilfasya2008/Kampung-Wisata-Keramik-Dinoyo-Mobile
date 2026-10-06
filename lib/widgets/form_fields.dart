import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

InputDecoration appInputDecoration({
  String? hint,
  IconData? icon,
  Widget? suffix,
}) {
  OutlineInputBorder border(Color c, [double w = 1]) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: c, width: w),
      );
  return InputDecoration(
    hintText: hint,
    hintStyle: AppText.body13,
    filled: true,
    fillColor: AppColors.white,
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
    prefixIcon: icon == null
        ? null
        : Icon(icon, size: 18, color: AppColors.muted),
    prefixIconConstraints: const BoxConstraints(minWidth: 44),
    suffixIcon: suffix,
    border: border(AppColors.border),
    enabledBorder: border(AppColors.border),
    focusedBorder: border(AppColors.primary, 1.5),
    errorBorder: border(AppColors.brick),
    focusedErrorBorder: border(AppColors.brick, 1.5),
  );
}

class FieldLabel extends StatelessWidget {
  const FieldLabel(this.text, {super.key, this.required = false});
  final String text;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text.rich(
        TextSpan(
          text: text,
          style: AppText.inter(size: 13, weight: FontWeight.w600),
          children: [
            if (required)
              TextSpan(
                text: ' *',
                style: AppText.inter(
                    size: 13, weight: FontWeight.w700, color: AppColors.brick),
              ),
          ],
        ),
      ),
    );
  }
}

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.icon,
    this.required = false,
    this.obscure = false,
    this.maxLines = 1,
    this.suffix,
    this.keyboardType,
    this.helper,
    this.validator,
    this.onChanged,
  });

  final String label;
  final String? hint;
  final TextEditingController? controller;
  final IconData? icon;
  final bool required;
  final bool obscure;
  final int maxLines;
  final Widget? suffix;
  final TextInputType? keyboardType;
  final String? helper;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldLabel(label, required: required),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          maxLines: obscure ? 1 : maxLines,
          keyboardType: keyboardType,
          onChanged: onChanged,
          style: AppText.inter(size: 13),
          validator: validator ??
              (required
                  ? (v) => (v == null || v.trim().isEmpty) ? 'Wajib diisi' : null
                  : null),
          decoration: appInputDecoration(hint: hint, icon: icon, suffix: suffix),
        ),
        if (helper != null) ...[
          const SizedBox(height: 6),
          Text(helper!, style: AppText.inter(size: 11, color: AppColors.muted)),
        ],
      ],
    );
  }
}

class AppDropdownField extends StatelessWidget {
  const AppDropdownField({
    super.key,
    required this.label,
    required this.items,
    required this.value,
    required this.onChanged,
    this.hint,
    this.required = false,
  });

  final String label;
  final List<String> items;
  final String? value;
  final ValueChanged<String?> onChanged;
  final String? hint;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldLabel(label, required: required),
        DropdownButtonFormField<String>(
          initialValue: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.muted),
          style: AppText.inter(size: 13),
          decoration: appInputDecoration(hint: hint),
          validator: required ? (v) => v == null ? 'Wajib diisi' : null : null,
          items: [
            for (final i in items) DropdownMenuItem(value: i, child: Text(i)),
          ],
          onChanged: onChanged,
        ),
      ],
    );
  }
}
