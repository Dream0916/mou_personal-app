import 'package:flutter/material.dart';
import 'package:mou_app/utils/app_colors.dart';
import 'package:mou_app/utils/app_font_size.dart';

class WordCounterTextField extends StatefulWidget {
  const WordCounterTextField({
    super.key,
    required this.controller,
    this.focusNode,
    this.keyboardType = TextInputType.text,
    this.hintText,
    this.onTap,
    this.onChanged,
    this.onFieldSubmitted,
    this.maxLength = 25,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;
  final TextInputType keyboardType;
  final String? hintText;
  final int maxLength;
  final VoidCallback? onTap;
  final Function(String value)? onChanged;
  final Function(String value)? onFieldSubmitted;

  @override
  State<WordCounterTextField> createState() => _WordCounterTextFieldState();
}

class _WordCounterTextFieldState extends State<WordCounterTextField> {
  final ValueNotifier<int> wordCounter = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    wordCounter.value = widget.controller.text.length;
  }

  @override
  void dispose() {
    wordCounter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: widget.controller,
            focusNode: widget.focusNode,
            keyboardType: widget.keyboardType,
            textCapitalization: TextCapitalization.sentences,
            style: TextStyle(
              color: AppColors.normal,
              fontSize: AppFontSize.textDatePicker,
              fontWeight: FontWeight.normal,
            ),
            decoration: InputDecoration(
              isDense: true,
              isCollapsed: true,
              border: InputBorder.none,
              hintText: widget.hintText,
              hintStyle: TextStyle(
                fontSize: AppFontSize.textDatePicker,
                color: AppColors.textPlaceHolder,
              ),
            ),
            maxLength: widget.maxLength,
            buildCounter: (
              context, {
              required currentLength,
              required isFocused,
              maxLength,
            }) =>
                const SizedBox(),
            onTap: widget.onTap?.call,
            onFieldSubmitted: widget.onFieldSubmitted,
            onChanged: (value) {
              wordCounter.value = value.length;
              widget.onChanged?.call(value);
            },
          ),
        ),
        const SizedBox(width: 12),
        ValueListenableBuilder<int>(
          valueListenable: wordCounter,
          builder: (context, value, child) {
            return value > 0
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Text(
                      '$value/${widget.maxLength}',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.header,
                      ),
                    ),
                  )
                : const SizedBox();
          },
        ),
      ],
    );
  }
}
