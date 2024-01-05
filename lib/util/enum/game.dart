enum GameTypeEnum {
  pot('pot'),
  anty('anty'),
  btn('btn'),
  option('option'),
  blind('blind');

  const GameTypeEnum(this.displayName);

  final String displayName;
}