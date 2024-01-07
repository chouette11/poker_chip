enum GameTypeEnum {
  pot('pot'),
  anty('anty'),
  btn('btn'),
  blind('blind'),
  preFlop('preFlop'),
  flop('flop'),
  turn('turn'),
  river('river'),
  foldout('foldout'),
  wtsd('wtsd');

  const GameTypeEnum(this.displayName);

  final String displayName;
}