class ItemModal {
  int _id;
  DateTime _date;
  String _event;
  ItemModal(this._id, this._date, this._event){
    this._id = id;
    this._date = date;
    this._event = event;
  }
  int get id => this._id;
  DateTime get date => this._date;
  String get event => this._event;
}
