part of 'pagar_bloc.dart';


class PagarState {
  final double montoPagar;
  final String moneda;
  final bool tarjetaActiva;
  late TarjetaCredito tarjeta;
  
  PagarState({this.montoPagar = 200.00, this.moneda = "MXN", this.tarjetaActiva = false, required this.tarjeta});

  PagarState copyWith({
    double? montoPagar,
    String? moneda,
    bool? tarjetaActiva,
    TarjetaCredito? tarjeta,
  }) => PagarState(
    montoPagar: montoPagar?? this.montoPagar,
    moneda: moneda ?? this.moneda,
    tarjetaActiva: tarjetaActiva ?? this.tarjetaActiva,
    tarjeta: tarjeta ?? this.tarjeta
    
  );


}

