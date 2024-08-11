import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tabasco_escapes/models/tarjeta_credito.dart';

part 'pagar_event.dart';
part 'pagar_state.dart';

class PagarBloc extends Bloc<PagarEvent, PagarState> {
  PagarBloc() : super(PagarState(tarjeta: TarjetaCredito(
    cardNumberHidden: "cardNumberHidden", 
    cardNumber: "cardNumber", 
    brand: "brand", 
    cvv: "cvv", 
    expiracyDate: "expiracyDate", 
    cardHolderName: "cardHolderNam"
  )));

  
  Stream<PagarState> mapEventToState( PagarEvent event ) async* {
    if (event is OnSelectCard ){
      yield state.copyWith(
        tarjeta: event.tarjeta,
        tarjetaActiva: true
      );
    }
    else if(event is OnDeactivateCard){
      yield state.copyWith(
        tarjetaActiva: false
      );
    }
  }


}
