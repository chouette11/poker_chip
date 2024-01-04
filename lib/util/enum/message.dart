enum MessageTypeEnum {
  join('join'),
  joined('joined'),
  action('action');

  const MessageTypeEnum(this.displayName);

  final String displayName;
}