part of 'quantity_button_bloc.dart';

// ignore: must_be_immutable
class QuantityButtonState {
  final int quantity;
  QuantityButtonState({required this.quantity});
}

class QuantityInitialState extends QuantityButtonState {
  QuantityInitialState({required super.quantity});
}
