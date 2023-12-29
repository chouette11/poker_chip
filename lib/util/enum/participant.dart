enum ParticipantMessageTypeEnum {
  join('join'),
  action('action');

  const ParticipantMessageTypeEnum(this.displayName);

  final String displayName;
}