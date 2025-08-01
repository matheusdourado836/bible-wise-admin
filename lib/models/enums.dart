enum ReportReason {
  SEXUAL_CONTENT('Conteúdo sexual'),
  VIOLENT_OR_REPULSIVE_CONTENT('Conteúdo violento ou repulsivo'),
  HATESPEECH_OR_ABUSE('Conteúdo de incitação ao ódio ou abusivo'),
  BULLYING_OR_HARASSMENT('Assédio ou bullying'),
  VIOLATE_MY_RIGHTS('Viola meus direitos'),
  NOT_LISTED('Não listado');

  final String description;
  const ReportReason(this.description);

  static ReportReason fromInt(int index) {
    return ReportReason.values.firstWhere((report) => report == ReportReason.values[index]);
  }
}