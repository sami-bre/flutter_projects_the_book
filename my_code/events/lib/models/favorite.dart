class Favorite {
  String? id;
  final String _eventId;
  final String _userId;

  String get eventId => _eventId;

  Favorite(this.id, this._eventId, this._userId);

  Favorite.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        _eventId = map['event_id'],
        _userId = map['user_id'];

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'user_id': _userId,
      'event_id': _eventId,
    };
  }
}
