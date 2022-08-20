import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:price_tracker/constants.dart';
import 'package:price_tracker/cubit/symbol_state.dart';
import 'package:price_tracker/cubit/symbol_state.dart' as symbolError;
import 'cubit/price_cubit.dart' as PriceError;
import 'package:price_tracker/symbol_model.dart';
import 'cubit/price_cubit.dart';
import 'cubit/symbol_cubit.dart';

class SymbolListScreen extends StatefulWidget {
  const SymbolListScreen({Key? key}) : super(key: key);

  @override
  State<SymbolListScreen> createState() => _SymbolListScreenState();
}

class _SymbolListScreenState extends State<SymbolListScreen>
    with TickerProviderStateMixin {
  List<ActiveSymbols> assetList = [];
  List<AnimationController> controllers = [];
  String selectedMarket = "";
  String selectedAsset = "";
  List<bool> isExpand = [];
  PriceCubit? block;

  @override
  void initState() {
    for (var i = 0; i < 2; i++) {
      isExpand.add(false);
      controllers.add(AnimationController(
        duration: const Duration(milliseconds: 300),
        upperBound: 0.5,
        vsync: this,
      ));
    }
    super.initState();
  }

  updateExpand(index) {
    if (isExpand[index] == true) {
      controllers[index].reverse(from: 0.5);
    } else {
      controllers[index].forward(from: 0.0);
    }
    isExpand[index] = !isExpand[index];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<SymbolCubit>(
        create: (context) => SymbolCubit(),
        child: BlocBuilder<SymbolCubit, SymbolState>(builder: (context, state) {
          if (state is LoadingState) {
            return Container(
              color: Colors.white,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (state is symbolError.ErrorState) {
            return const Center(
              child: Icon(Icons.close),
            );
          } else if (state is LoadedState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                marketDropDownView(context, 0),
                marketListView(context, state, 0),
                const SizedBox(
                  height: 10,
                ),
                Visibility(
                  visible: assetList.isNotEmpty,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      marketDropDownView(context, 1),
                      marketListView(context, state, 1),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                ),
                updateAmount()
              ],
            );
          } else {
            return Container(
              color: Colors.white,
            );
          }
        }),
      ),
    );
  }

  Visibility updateAmount() {
    return Visibility(
      visible: selectedAsset.isNotEmpty,
      child: BlocBuilder<PriceCubit, PriceState>(
          bloc: block,
          builder: (context, state) {
            if (state is PriceError.StreamState) {
              return StreamBuilder(
                  stream: state.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var respo = state.listeningStream(snapshot.data);
                      if (respo != null) {
                        if (respo["error"] is String) {
                          return Text(respo["error"] as String, style: const TextStyle(
                                color: Colors.black,
                                fontSize: 19,
                                fontWeight: FontWeight.bold),);
                        } else {
                          return Text(
                            "Price ${respo["amount"] as String}",
                            style: const TextStyle(
                                color: Colors.green,
                                fontSize: 19,
                                fontWeight: FontWeight.bold),
                          );
                        }
                      } else {
                        return Container();
                      }
                    } else {
                      return Container(
                        color: Colors.white,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  });
            } else if (state is PriceError.ErrorState) {
              if (state.errorDescription.isEmpty) {
                return const Center(
                  child: Icon(Icons.close),
                );
              } else {
                return Center(
                  child: Text(state.errorDescription),
                );
              }
            } else {
              return Container();
            }
          }),
    );
  }

  Center marketDropDownView(BuildContext context, int index) => Center(
        child: GestureDetector(
          onTap: () => setState(() => updateExpand(index)),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: 45,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                border: Border.all(color: Colors.black)),
            child: Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                AnimatedOpacity(
                  duration: const Duration(microseconds: 500),
                  opacity: index == 0
                      ? (selectedMarket.isEmpty ? 0.5 : 1.0)
                      : (selectedAsset.isEmpty ? 0.5 : 1.0),
                  child: Text(
                      index == 0
                          ? (selectedMarket.isEmpty
                              ? "Select Market"
                              : selectedMarket)
                          : (selectedAsset.isEmpty
                              ? "Select Asset"
                              : selectedAsset),
                      style: AppTextStyle.chooseMarket),
                ),
                const Spacer(),
                RotationTransition(
                  turns:
                      Tween(begin: 0.0, end: 0.5).animate(controllers[index]),
                  child: IconButton(
                      onPressed: () => setState(() => updateExpand(index)),
                      icon: const Icon(Icons.arrow_right)),
                )
              ],
            ),
          ),
        ),
      );

  AnimatedContainer marketListView(
          BuildContext context, LoadedState state, index) =>
      AnimatedContainer(
          width: MediaQuery.of(context).size.width * 0.8,
          height: isExpand[index]
              ? expandSize(
                  index, index == 0 ? state.symbols.length : assetList.length)
              : 0,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(
                  color: isExpand[index] ? Colors.black : Colors.transparent)),
          duration: const Duration(milliseconds: 500),
          curve: Curves.fastOutSlowIn,
          child: ListView.builder(
              padding: EdgeInsets.zero,
              itemBuilder: ((context, listIndex) {
                return GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      index == 0
                          ? state.symbols[listIndex].submarketDisplayName ?? ""
                          : assetList[listIndex].symbol ?? "",
                      style: AppTextStyle.chooseMarket,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      if (index == 0) {
                        assetList = [];
                        selectedAsset = "";
                        selectedMarket =
                            state.symbols[listIndex].submarketDisplayName ?? "";
                        assetList = state.symbols
                            .where((element) => (element.submarket ?? "")
                                .contains(
                                    state.symbols[listIndex].submarket ?? ""))
                            .toList();
                      } else {
                        selectedAsset = assetList[listIndex].symbol ?? "";
                        block?.fetchSymbols();
                        block = PriceCubit(assetID: selectedAsset);
                      }
                      updateExpand(index);
                    });
                  },
                );
              }),
              itemCount: index == 0 ? state.symbols.length : assetList.length));

  double expandSize(int index, int lenth) => lenth > 5 ? 200 : lenth * 45;
}
