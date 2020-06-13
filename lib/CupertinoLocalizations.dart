import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class _CupertinoLocalizationsDelegate  extends LocalizationsDelegate<CupertinoLocalizations>{


  @override
  bool isSupported(Locale locale) {
    // TODO: implement isSupported
    return locale.languageCode == 'zh';
  }



  @override
  bool shouldReload(LocalizationsDelegate old) {
    // TODO: implement shouldReload
    return false;
  }

  @override
  Future<CupertinoLocalizations> load(Locale locale) {
    // TODO: implement load
    return ChineseCupertinoLocalizations.load(locale);
  }

  const _CupertinoLocalizationsDelegate();
}

class ChineseCupertinoLocalizations implements CupertinoLocalizations{

  static const LocalizationsDelegate<CupertinoLocalizations> delegate = _CupertinoLocalizationsDelegate();

  ChineseCupertinoLocalizations(Locale locale);
  
  @override
  // TODO: implement alertDialogLabel
  String get alertDialogLabel =>'';

  @override
  // TODO: implement anteMeridiemAbbreviation
  String get anteMeridiemAbbreviation => throw UnimplementedError();

  @override
  // TODO: implement copyButtonLabel
  String get copyButtonLabel => '复制';

  @override
  // TODO: implement cutButtonLabel
  String get cutButtonLabel => '剪切';

  @override
  // TODO: implement datePickerDateOrder
  DatePickerDateOrder get datePickerDateOrder => throw UnimplementedError();

  @override
  // TODO: implement datePickerDateTimeOrder
  DatePickerDateTimeOrder get datePickerDateTimeOrder => throw UnimplementedError();

  @override
  String datePickerDayOfMonth(int dayIndex) {
    // TODO: implement datePickerDayOfMonth
    throw UnimplementedError();
  }

  @override
  String datePickerHour(int dayInd){
    // TODO: implement datePickerHour
    throw UnimplementedError();
  }

  @override
  String datePickerHourSemanticsLabel(int dayInd){
    // TODO: implement datePickerHourSemanticsLabel
    throw UnimplementedError();
  }

@override
  String datePickerMediumDate(DateTime date) {
    // TODO: implement datePickerMediumDate
    throw UnimplementedError();
  }

  @override
  String datePickerMinute(int dayInd) {
    // TODO: implement datePickerMinute
    throw UnimplementedError();
  }

  @override
  String datePickerMinuteSemanticsLabel(int dayInd) {
    // TODO: implement datePickerMinuteSemanticsLabel
    throw UnimplementedError();
  }

  @override
  String datePickerMonth(int dayIndndex) {
    // TODO: implement datePickerMonth
    throw UnimplementedError();
  }

  @override
  String datePickerYear(int dayInddex) {
    // TODO: implement datePickerYear
    throw UnimplementedError();
  }

  @override
  // TODO: implement pasteButtonLabel
  String get pasteButtonLabel => '粘贴';

  @override
  // TODO: implement postMeridiemAbbreviation
  String get postMeridiemAbbreviation => throw UnimplementedError();

  @override
  // TODO: implement selectAllButtonLabel
  String get selectAllButtonLabel => '全选';

  @override
  String timerPickerHour(int dayInd){
    // TODO: implement timerPickerHour
    throw UnimplementedError();
  }

  @override
  String timerPickerHourLabel(int dayInd){
    // TODO: implement timerPickerHourLabel
    throw UnimplementedError();
  }

  @override
  String timerPickerMinute(int dayInd) {
    // TODO: implement timerPickerMinute
    throw UnimplementedError();
  }

  @override
  String timerPickerMinuteLabel(int dayInd) {
    // TODO: implement timerPickerMinuteLabel
    throw UnimplementedError();
  }

  @override
  String timerPickerSecond(int dayInd) {
    // TODO: implement timerPickerSecond
    throw UnimplementedError();
  }

  @override
  String timerPickerSecondLabel(int dayInd) {
    // TODO: implement timerPickerSecondLabel
    throw UnimplementedError();
  }

  @override
  // TODO: implement todayLabel
  String get todayLabel => throw UnimplementedError();

  static Future<CupertinoLocalizations> load(Locale locale) {
    return SynchronousFuture<CupertinoLocalizations>(ChineseCupertinoLocalizations(locale));
  }

}