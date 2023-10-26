extension ImagePathExtension on String {
  String get toSVG => 'asset/svg/$this.svg';
}

extension LanguageExtension on String {
  String get toLanguageHeader {
    switch (this) {
      case 'US':
        return 'E';
      case 'TR':
        return 'T';

      default:
        return '';
    }
  }

  String get toLanguageString {
    switch (this) {
      case 'US':
        return 'EN';
      case 'TR':
        return 'TR';

      default:
        return '';
    }
  }
}
