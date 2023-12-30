enum ActionTypeEnum {
  call('call'),
  raise('raise'),
  fold('fold'),
  check('check'),
  bet('bet'),
  pot('pot'),
  anty('anty'),
  btn('btn'),
  blind('blind');

  const ActionTypeEnum(this.displayName);

  final String displayName;
}