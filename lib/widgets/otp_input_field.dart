import 'package:employee_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class OtpInputField extends StatefulWidget {
  const OtpInputField({
    super.key,
    this.length = 6,
    this.onChanged,
    this.onCompleted,
    this.hasError = false,
    this.autoFocus = true,
  });

  final int length;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;
  final bool hasError;
  final bool autoFocus;

  @override
  State<OtpInputField> createState() => OtpInputFieldState();
}

class OtpInputFieldState extends State<OtpInputField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    if (widget.autoFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void clear() {
    _controller.clear();
    _focusNode.requestFocus();
    widget.onChanged?.call('');
  }

  String get value => _controller.text;

  void _onTextChanged(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    final trimmed = digits.length > widget.length
        ? digits.substring(0, widget.length)
        : digits;

    if (trimmed != _controller.text) {
      _controller.value = TextEditingValue(
        text: trimmed,
        selection: TextSelection.collapsed(offset: trimmed.length),
      );
    }

    setState(() {});
    widget.onChanged?.call(trimmed);

    if (trimmed.length == widget.length) {
      widget.onCompleted?.call(trimmed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final boxSize = MediaQuery.of(context).size.width > 400 ? 48.0 : 44.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(widget.length, (index) {
                final char = index < _controller.text.length
                    ? _controller.text[index]
                    : '';
                final isFocused = _focusNode.hasFocus &&
                    (index == _controller.text.length ||
                        (index == widget.length - 1 &&
                            _controller.text.length == widget.length));

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: boxSize,
                  height: boxSize + 8,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.grey50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: widget.hasError
                          ? AppColors.grey700
                          : isFocused
                              ? AppColors.black
                              : AppColors.grey300,
                      width: isFocused ? 1.5 : 1,
                    ),
                    boxShadow: isFocused
                        ? [
                            BoxShadow(
                              color: AppColors.black.withOpacity(0.06),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Text(
                    char,
                    style: GoogleFonts.inter(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                );
              }),
            ),
            SizedBox(
              height: boxSize + 8,
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.oneTimeCode],
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(widget.length),
                ],
                onChanged: _onTextChanged,
                style: const TextStyle(color: Colors.transparent),
                cursorColor: Colors.transparent,
                showCursor: false,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  counterText: '',
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
