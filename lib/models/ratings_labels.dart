enum RatingsLabels {
  tresMauvaise('Très mauvaise', 1),
  mauvaise('Mauvaise', 2),
  neutre('Neutre', 3),
  bonne('Bonne', 4),
  tresBonne('Très bonne', 5);

  final String label;
  final int value;

  const RatingsLabels(this.label, this.value);
}
