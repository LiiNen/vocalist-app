import 'package:flutter/material.dart';
import 'package:emoji_picker/emoji_picker.dart';

class EmojiPickerWidget extends StatelessWidget {
  final ValueChanged<String> onEmojiSelected;
  const EmojiPickerWidget({
    required this.onEmojiSelected,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmojiPicker(
      onEmojiSelected: (emoji, category) => onEmojiSelected(emoji.emoji),
    );
  }
}