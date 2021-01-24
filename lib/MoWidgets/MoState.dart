class MoState{
  /// a class to show at what state the
  /// background program is at

  static const String LOADING = "LOADING";
  static const String START = "START";
  static const String WAIT = "WAIT";

  String _currentState;

  MoState(String cs){
    this._currentState = cs;
  }

  String get currentState => _currentState;


  set currentState(String value) {
    _currentState = value;
  }

  void setState(String newState)
  {
    this._currentState = newState;
  }


  bool start()
  {
    return this._currentState == MoState.START;
  }

  bool loading()
  {
    return this._currentState == MoState.LOADING;
  }

  bool wait()
  {
    return this._currentState == MoState.WAIT;
  }


}