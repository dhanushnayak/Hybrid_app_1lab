class User {
  int _id;
  String _usn;
  String _password;

  User(this._usn, this._password);
  User.withId(this._id, this._usn, this._password);
  User.fromMap(dynamic obj) {
    this._id = obj["id"];
    this._usn = obj['usn'];
    this._password = obj['password'];
  }
  int get id => _id;
  String get usn => _usn;
  String get password => _password;
  set usn(String newTitle) {
    if (newTitle.length <= 255) {
      this._usn = newTitle;
    }
  }

  set password(String newDescription) {
    if (newDescription.length <= 255) {
      this._password = newDescription;
    }
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
      print("ID $_id");
    }
    map["usn"] = _usn;
    map["password"] = _password;
    return map;
  }

  User.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._usn = map['usn'];

    this._password = map['password'];
  }
}
