import 'dart:async';

import 'package:bloc_example/Connectivity_Example_Bloc/bloc/internet_state.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'internet_event.dart';

class InternetBloc extends Bloc<InternetEvent, InternetStateBloc> {

  Connectivity connectivity = Connectivity();
  StreamSubscription? connectivitySubscription;

  InternetBloc() : super(InternetInitialState()) {
    on<InternetLostEvent>(
      (event, emit) => emit(InternetLostState()),
    );
    on<InternetGainedEvent>(
      (event, emit) => emit(InternetGainedState()),
    );

    connectivitySubscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        add(InternetGainedEvent());
      } else {
        add(InternetLostEvent());
      }
    });
  }

  @override
  Future<void> close() {
    connectivitySubscription?.cancel();
    return super.close();

  }
}
