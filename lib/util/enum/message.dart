enum MessageTypeEnum {
  join('join'),
  joined('joined'),
  userSetting('userSetting'),
  game('game'),
  action('action');

  const MessageTypeEnum(this.displayName);

  final String displayName;
}