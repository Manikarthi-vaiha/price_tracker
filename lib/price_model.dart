class PriceModel {
  EchoReq? echoReq;
  String? msgType;
  Subscription? subscription;
  Tick? tick;
  Error? error;

  PriceModel(
      {this.echoReq, this.msgType, this.subscription, this.tick, this.error});

  PriceModel.fromJson(Map<String, dynamic> json) {
    echoReq = json['echo_req'] != null
        ?  EchoReq.fromJson(json['echo_req'])
        : null;
    msgType = json['msg_type'];
    subscription = json['subscription'] != null
        ?  Subscription.fromJson(json['subscription'])
        : null;
    tick = json['tick'] != null ?  Tick.fromJson(json['tick']) : null;
    error = json['error'] != null ?  Error.fromJson(json['error']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    if (echoReq != null) {
      data['echo_req'] = echoReq!.toJson();
    }
    data['msg_type'] = msgType;
    if (subscription != null) {
      data['subscription'] = subscription!.toJson();
    }
    if (tick != null) {
      data['tick'] = tick!.toJson();
    }
    if (error != null) {
      data['error'] = error!.toJson();
    }
    return data;
  }
}

class EchoReq {
  int? subscribe;
  String? ticks;

  EchoReq({this.subscribe, this.ticks});

  EchoReq.fromJson(Map<String, dynamic> json) {
    subscribe = json['subscribe'];
    ticks = json['ticks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['subscribe'] = subscribe;
    data['ticks'] = ticks;
    return data;
  }
}

class Subscription {
  String? id;

  Subscription({this.id});

  Subscription.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['id'] = id;
    return data;
  }
}

class Tick {
  double? ask;
  double? bid;
  int? epoch;
  String? id;
  int? pipSize;
  double? quote;
  String? symbol;

  Tick(
      {this.ask,
      this.bid,
      this.epoch,
      this.id,
      this.pipSize,
      this.quote,
      this.symbol});

  Tick.fromJson(Map<String, dynamic> json) {
    ask = json['ask'];
    bid = json['bid'];
    epoch = json['epoch'];
    id = json['id'];
    pipSize = json['pip_size'];
    quote = json['quote'];
    symbol = json['symbol'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['ask'] = ask;
    data['bid'] = bid;
    data['epoch'] = epoch;
    data['id'] = id;
    data['pip_size'] = pipSize;
    data['quote'] = quote;
    data['symbol'] = symbol;
    return data;
  }
}

class Error {
  String? code;
  Details? details;
  String? message;

  Error({this.code, this.details, this.message});

  Error.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    details =
        json['details'] != null ?  Details.fromJson(json['details']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['code'] = code;
    if (details != null) {
      data['details'] = details!.toJson();
    }
    data['message'] = message;
    return data;
  }
}

class Details {
  String? field;

  Details({this.field});

  Details.fromJson(Map<String, dynamic> json) {
    field = json['field'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['field'] = field;
    return data;
  }
}