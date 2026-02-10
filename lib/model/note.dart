class NoteModel {
  int? _id;
  String _title;
  String _description;
  int _priority;
  String _date;

  NoteModel(this._title, this._date, this._priority, [this._description = '']);

  NoteModel.withId(
    this._id,
    this._title,
    this._date,
    this._priority, [
    this._description = '',
  ]);

  int? get id => _id;
  String get title => _title;
  String get description => _description;
  int get priority => _priority;
  String get date => _date;

  set title(String value) => _title = value;
  set description(String value) => _description = value;
  set priority(int value) => _priority = value;
  set date(String value) => _date = value;

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'title': _title,
      'description': _description,
      'priority': _priority,
      'date': _date,
    };
    if (_id != null) map['id'] = _id;
    return map;
  }

  NoteModel.fromMap(Map<String, dynamic> map)
      : _id = map['id'],
        _title = map['title'],
        _description = map['description'] ?? '',
        _priority = map['priority'],
        _date = map['date'];
}
