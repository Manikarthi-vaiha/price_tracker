import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:price_tracker/constants.dart';
import 'package:price_tracker/cubit/symbol_state.dart';
import 'package:price_tracker/symbol_model.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;


class SymbolCubit extends Cubit<SymbolState> {
  SymbolCubit() : super(SymbolInitial()) {
    fetchSymbols();
    listeningStream();
    symbolParams();
  }
  WebSocketChannel? channel;
  fetchSymbols() {
    emit(LoadingState());
    channel?.sink.close(status.noStatusReceived);
    channel = WebSocketChannel.connect(
      Uri.parse(APPURL.symbolURL),
    );
  }

  symbolParams() => channel?.sink.add(AppDefaultParams.activeParams);
  listeningStream() => channel?.stream.listen(
        (data) {
          // print(data);
          if (data is String) {
            Map<String, dynamic> userMap = jsonDecode(data);
            var user = SymbolModel.fromJson(userMap);
            var activeSymbolList = user.symbol?.toSet().toList();
            emit(LoadedState(activeSymbolList ?? []));
          }
        },
        onError: (error) => emit(ErrorState()),
      );
}
