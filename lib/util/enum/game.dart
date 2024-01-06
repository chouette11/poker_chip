enum GameTypeEnum {
  pot('pot'),
  anty('anty'),
  btn('btn'),
  blind('blind'),
  preFlop('preFlop'),
  flop('flop'),
  turn('turn'),
  river('river');

  const GameTypeEnum(this.displayName);

  final String displayName;
}