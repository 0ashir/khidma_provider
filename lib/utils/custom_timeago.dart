abstract class TimeagoMessages {
  String prefixAgo();
  String prefixFromNow();
  String suffixAgo();
  String suffixFromNow();
  String lessThanOneMinute(int seconds);
  String aboutAMinute(int minutes);
  String minutes(int minutes);
  String aboutAnHour(int minutes);
  String hours(int hours);
  String aDay(int hours);
  String days(int days);
  String aboutAWeek(int days);
  String weeks(int weeks);
  String aboutAMonth(int days);
  String months(int months);
  String aboutAYear(int year);
  String years(int years);
  String wordSeparator();
}

class _EnMessages implements TimeagoMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => 'ago';
  @override
  String suffixFromNow() => 'from now';
  @override
  String lessThanOneMinute(int seconds) => 'just now';
  @override
  String aboutAMinute(int minutes) => 'a minute';
  @override
  String minutes(int minutes) => '$minutes minutes';
  @override
  String aboutAnHour(int minutes) => 'about an hour';
  @override
  String hours(int hours) => '$hours hours';
  @override
  String aDay(int hours) => 'a day';
  @override
  String days(int days) => '$days days';
  @override
  String aboutAWeek(int days) => 'about a week';
  @override
  String weeks(int weeks) => '$weeks weeks';
  @override
  String aboutAMonth(int days) => 'about a month';
  @override
  String months(int months) => '$months months';
  @override
  String aboutAYear(int year) => 'about a year';
  @override
  String years(int years) => '$years years';
  @override
  String wordSeparator() => ' ';
}

class CustomTimeago {
  static final Map<String, TimeagoMessages> _locales = {'en': _EnMessages()};
  static String _defaultLocale = 'en';

  static void setLocaleMessages(String locale, TimeagoMessages messages) {
    _locales[locale] = messages;
  }

  static void setDefaultLocale(String locale) {
    _defaultLocale = locale;
  }

  static String format(DateTime date, {String? locale}) {
    final msgs = _locales[locale ?? _defaultLocale] ?? _EnMessages();
    final now = DateTime.now();
    final diff = now.difference(date);
    final isPast = !diff.isNegative;
    final elapsed = diff.abs();

    final String msg;
    final int seconds = elapsed.inSeconds;
    final int minutes = elapsed.inMinutes;
    final int hours = elapsed.inHours;
    final int days = elapsed.inDays;

    if (seconds < 45) {
      msg = msgs.lessThanOneMinute(seconds);
    } else if (seconds < 90) {
      msg = msgs.aboutAMinute(1);
    } else if (minutes < 45) {
      msg = msgs.minutes(minutes);
    } else if (minutes < 90) {
      msg = msgs.aboutAnHour(minutes);
    } else if (hours < 24) {
      msg = msgs.hours(hours);
    } else if (hours < 48) {
      msg = msgs.aDay(hours);
    } else if (days < 7) {
      msg = msgs.days(days);
    } else if (days < 14) {
      msg = msgs.aboutAWeek(days);
    } else if (days < 30) {
      msg = msgs.weeks(days ~/ 7);
    } else if (days < 60) {
      msg = msgs.aboutAMonth(days);
    } else if (days < 365) {
      msg = msgs.months(days ~/ 30);
    } else if (days < 730) {
      msg = msgs.aboutAYear(days ~/ 365);
    } else {
      msg = msgs.years(days ~/ 365);
    }

    final sep = msgs.wordSeparator();
    if (isPast) {
      final prefix = msgs.prefixAgo();
      final suffix = msgs.suffixAgo();
      return [
        if (prefix.isNotEmpty) prefix,
        msg,
        if (suffix.isNotEmpty) suffix,
      ].join(sep).trim();
    } else {
      final prefix = msgs.prefixFromNow();
      final suffix = msgs.suffixFromNow();
      return [
        if (prefix.isNotEmpty) prefix,
        msg,
        if (suffix.isNotEmpty) suffix,
      ].join(sep).trim();
    }
  }
}

class JsonTimeagoMessages implements TimeagoMessages {
  final Map<String, dynamic> translations;
  JsonTimeagoMessages(this.translations);

  @override
  String prefixAgo() => translations['timeagoPrefixAgo'] ?? '';
  @override
  String prefixFromNow() => translations['timeagoPrefixFromNow'] ?? '';
  @override
  String suffixAgo() => translations['timeagoSuffixAgo'] ?? 'ago';
  @override
  String suffixFromNow() => translations['timeagoSuffixFromNow'] ?? 'from now';
  @override
  String lessThanOneMinute(int seconds) =>
      translations['timeagoLessThanOneMinute'] ?? 'just now';
  @override
  String aboutAMinute(int minutes) =>
      translations['timeagoAboutAMinute'] ?? 'a minute';
  @override
  String minutes(int minutes) =>
      '$minutes ${translations['timeagoMinutes'] ?? 'minutes'}';
  @override
  String aboutAnHour(int minutes) =>
      translations['timeagoAboutAnHour'] ?? 'about an hour';
  @override
  String hours(int hours) =>
      '$hours ${translations['timeagoHours'] ?? 'hours'}';
  @override
  String aDay(int hours) => translations['timeagoADay'] ?? 'a day';
  @override
  String days(int days) => '$days ${translations['timeagoDays'] ?? 'days'}';
  @override
  String aboutAWeek(int days) =>
      translations['timeagoAboutAWeek'] ?? 'about a week';
  @override
  String weeks(int weeks) =>
      '$weeks ${translations['timeagoWeeks'] ?? 'weeks'}';
  @override
  String aboutAMonth(int days) =>
      translations['timeagoAboutAMonth'] ?? 'about a month';
  @override
  String months(int months) =>
      '$months ${translations['timeagoMonths'] ?? 'months'}';
  @override
  String aboutAYear(int year) =>
      translations['timeagoAboutAYear'] ?? 'about a year';
  @override
  String years(int years) =>
      '$years ${translations['timeagoYears'] ?? 'years'}';
  @override
  String wordSeparator() => translations['timeagoWordSeparator'] ?? ' ';
}
