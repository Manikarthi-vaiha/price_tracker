class SymbolModel {
List<ActiveSymbols>? _activeSymbols;
  EchoReq? _echoReq;
  String? _msgType;

  symbold(
      {List<ActiveSymbols>? activeSymbols, EchoReq? echoReq, String? msgType}) {    
      _activeSymbols = activeSymbols;        
      _echoReq = echoReq;        
      _msgType = msgType;    
  }

   List<ActiveSymbols>? get symbol => _activeSymbols;
  
  SymbolModel.fromJson(Map<String, dynamic> json) {
    if (json['active_symbols'] != null) {
      _activeSymbols = <ActiveSymbols>[];
      json['active_symbols'].forEach((v) {
        _activeSymbols!.add(ActiveSymbols.fromJson(v));
      });
    }
    _echoReq = json['echo_req'] != null
        ? EchoReq.fromJson(json['echo_req'])
        : null;
    _msgType = json['msg_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (_activeSymbols != null) {
      data['active_symbols'] =
          _activeSymbols!.map((v) => v.toJson()).toList();
    }
    if (_echoReq != null) {
      data['echo_req'] = _echoReq!.toJson();
    }
    data['msg_type'] = _msgType;
    return data;
  }
}

class ActiveSymbols {  
  String? _displayName;  
  String? _submarket;
  String? _submarketDisplayName;
  String? _symbol;
  String? _symbolType;

  String? get displayName => _displayName;
  String? get submarket => _submarket;
  String? get submarketDisplayName => _submarketDisplayName;
  String? get symbol => _symbol;
  String? get symbolType => _symbolType;

  ActiveSymbols({
      String? displayName,                        
      String? submarket,
      String? submarketDisplayName,
      String? symbol,
      String? symbolType}) {              
      _displayName = displayName;        
      _submarket = submarket;    
      _submarketDisplayName = submarketDisplayName;        
      _symbol = symbol;        
      _symbolType = symbolType;
      }      

  ActiveSymbols.fromJson(Map<String, dynamic> json) {    
    _displayName = json['display_name'];    
    _submarket = json['submarket'];
    _submarketDisplayName = json['submarket_display_name'];
    _symbol = json['symbol'];
    _symbolType = json['symbol_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};    
    data['display_name'] = _displayName;    
    data['submarket'] = _submarket;
    data['submarket_display_name'] = _submarketDisplayName;
    data['symbol'] = _symbol;
    data['symbol_type'] = _symbolType;
    return data;
  }
}

class EchoReq {
  String? _activeSymbols;
  String? _productType;

  EchoReq({String? activeSymbols, String? productType}) {    
      _activeSymbols = activeSymbols;    
      _productType = productType;    
  }
  
  EchoReq.fromJson(Map<String, dynamic> json) {
    _activeSymbols = json['active_symbols'];
    _productType = json['product_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['active_symbols'] = _activeSymbols;
    data['product_type'] = _productType;
    return data;
  }
}
