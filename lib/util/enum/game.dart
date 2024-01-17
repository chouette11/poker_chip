enum GameTypeEnum {
  sidePot('sidePot'),
  anty('anty'),
  btn('btn'),
  blind('blind'),
  preFlop('preFlop'),
  flop('flop'),
  turn('turn'),
  river('river'),
  foldout('foldout'),
  showdown('showdown');

  const GameTypeEnum(this.displayName);

  final String displayName;
}