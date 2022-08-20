import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:price_tracker/price_model.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import '../constants.dart';

class PriceCubit extends Cubit<PriceState> {
  PriceCubit({required this.assetID}) : super(InitialPriceState()) {
    fetchSymbols();
  }

  String assetID;

  WebSocketChannel? channel;
  fetchSymbols() {
    channel?.sink.close(status.noStatusReceived);
    channel = WebSocketChannel.connect(
      Uri.parse(APPURL.symbolURL),
    );
    channel?.sink.add(AppDefaultParams.getPrice(assetID));
    emit(StreamState(stream: channel?.stream));
  }
}

abstract class PriceState extends Equatable {}

class InitialPriceState extends PriceState {
  @override
  List<Object?> get props => [];
}

// ignore: must_be_immutable
class LoadedPriceState extends PriceState {
  double amount;
  LoadedPriceState({required this.amount});
  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class ErrorState extends PriceState {
  String errorDescription;
  ErrorState({required this.errorDescription});
  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class StreamState extends PriceState {
  Stream<dynamic>? stream;

  Map<String, String>? listeningStream(dynamic data) {
    if (data is String) {
      Map<String, dynamic> userMap = jsonDecode(data);
      var user = PriceModel.fromJson(userMap);
      String? errorMsg = user.error?.message;
      if (errorMsg != null) {
        return {"error": errorMsg};
      } else {
        var amount = user.tick?.quote;
        if (amount != null) {
          return {"amount": '$amount'};
        } else {
          return null;
        }
      }
    } else {
      return null;
    }
  }

  bool compareAmount(double oldAmount, double newAmount) =>
      oldAmount < newAmount;

  StreamState({required this.stream});

  @override
  List<Object> get props => [];
}
