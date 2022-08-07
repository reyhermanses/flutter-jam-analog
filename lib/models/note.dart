import 'dart:convert';

class Note {
  int? hour;
  int? minute;
  Note({this.hour, this.minute});

  factory Note.fromJsonString(String str) => Note._fromJson(jsonDecode(str));

  String toJsonString() => jsonEncode(_toJson());

  factory Note._fromJson(Map<String, dynamic> json) => Note(
        hour: json['hour'],
        minute: json['minute'],
      );

  Map<String, dynamic> _toJson() => {
        'hour': hour,
        'minute': minute,
      };
}
