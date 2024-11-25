class TeleprompterText {
  final String content;
  final double scrollSpeed;

  TeleprompterText({required this.content, this.scrollSpeed = 50.0});

  TeleprompterText copyWith({String? content, double? scrollSpeed}) {
    return TeleprompterText(
      content: content ?? this.content,
      scrollSpeed: scrollSpeed ?? this.scrollSpeed,
    );
  }
}
