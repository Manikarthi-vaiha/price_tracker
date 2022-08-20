import 'package:equatable/equatable.dart';
import 'package:price_tracker/symbol_model.dart';

abstract class SymbolState extends Equatable {}

class SymbolInitial extends SymbolState {
  @override
  List<Object?> get props => [];
}

// ignore: must_be_immutable
class LoadingState extends SymbolInitial {
  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class LoadedState extends SymbolInitial {
  LoadedState(this.symbols);
  final List<ActiveSymbols> symbols;

   List<ActiveSymbols> fetchFilterdSymbold(String name) =>
    symbols.where((element) => (element.submarket ?? "").contains(name)).toList();
  

  @override
  List<Object> get props => [symbols];
}

// ignore: must_be_immutable
class ErrorState extends SymbolInitial {
  @override
  List<Object> get props => [];
}
