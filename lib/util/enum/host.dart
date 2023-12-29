enum HostMessageTypeEnum {
  joined('joined'),
  action('action');

  const HostMessageTypeEnum(this.displayName);

  final String displayName;
}

