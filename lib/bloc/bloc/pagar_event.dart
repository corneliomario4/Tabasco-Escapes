part of 'pagar_bloc.dart';

@immutable
class PagarEvent {}

class OnSelectCard extends PagarEvent {
  final TarjetaCredito tarjeta;
  OnSelectCard(this.tarjeta);

}

class OnDeactivateCard extends PagarEvent {

}
