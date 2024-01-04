enum GameTypeEnum {
  pot('pot'),
  anty('anty'),
  btn('btn'),
  blind('blind');

  const GameTypeEnum(this.displayName);

  final String displayName;
}