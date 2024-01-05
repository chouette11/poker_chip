enum MessageTypeEnum {
  join('join'),
  joined('joined'),
  game('game'),
  action('action');

  const MessageTypeEnum(this.displayName);

  final String displayName;
}