enum MessageTypeEnum {
  join('join'),
  joined('joined'),
  sit('sit'),
  userSetting('userSetting'),
  game('game'),
  action('action'),
  res('res');

  const MessageTypeEnum(this.displayName);

  final String displayName;
}