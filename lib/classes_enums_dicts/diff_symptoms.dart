class DiffSymptoms {
  
  bool _sFS=false;
  bool _sDOB=false;
  bool _sLOA=false;
  bool _sC=false;
  bool _sLS=false;
  bool _sCPP=false;
  bool _sFever=false;
  bool _sFatigue=false;
  late String _sMore='';

  void setsMore(String value){
    _sMore=value;
  }
  
  String get getsMore {
    return _sMore;
  }

  void setsFatigue(bool value){
    _sFatigue=value;
  }
  
  bool get getsFatigue {
    return _sFatigue;
  }

  void setsFever(bool value){
    _sFever=value;
  }
  
  bool get getsFever {
    return _sFever;
  }

  void setsCPP(bool value){
    _sCPP=value;
  }
  
  bool get getsCPP {
    return _sCPP;
  }

  void setsLS(bool value){
    _sLS=value;
  }
  
  bool get getsLS {
    return _sLS;
  }

  void setsC(bool value){
    _sC=value;
  }
  
  bool get getsC {
    return _sC;
  }

  void setsLOA(bool value){
    _sLOA=value;
  }
  
  bool get getsLOA {
    return _sLOA;
  }

  void setsDOB(bool value){
    _sDOB=value;
  }
  
  bool get getsDOB {
    return _sDOB;
  }

  void setsFS(bool value){
    _sFS=value;
  }
  
  bool get getsFS {
    return _sFS;
  }

  void setFalseAll(){
    _sFS=false;
    _sDOB=false;
    _sLOA=false;
    _sC=false;
    _sLS=false;
    _sCPP=false;
    _sFever=false;
    _sFatigue=false;
  }
}