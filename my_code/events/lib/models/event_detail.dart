class EventDetail {
  String? id;
  final String _description;
  final String _date;
  final String _startTime;
  final String _endTime;
  final String _speaker;
  final bool _isFavorite;

  EventDetail(
    this.id,
    this._description,
    this._date,
    this._startTime,
    this._endTime,
    this._speaker,
    this._isFavorite,
  );

  String get description => _description;
  String get date => _date;
  String get startTime => _startTime;
  String get endTime => _endTime;
  String get speaker => _speaker;
  bool get isFavorite => _isFavorite;

  EventDetail.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        _description = map['description'],
        _date = map['date'],
        _startTime = map['start_time'],
        _endTime = map['end_time'],
        _speaker = map['speaker'],
        _isFavorite = map['is_favorite'];

  Map<String, dynamic> toMap() {
    return {
      if (id != null) "id": id,
      "description": _description,
      "date": _date,
      "start_time": _startTime,
      "end_time": _endTime,
      "speaker": _speaker,
      "is_favorite": _isFavorite,
    };
  }
}
