import 'package:flutter/material.dart';

class StripeService {
  StripeService._privateConstructor();

  static final StripeService _instance = StripeService._privateConstructor();

  factory StripeService(){
    return _instance;
  }

  String _paymentAPIUrl = "https://api.stripe.com/v1/payment_intents";
  String _secretKey = "sk_test_51Nk96OIkn5iPfYiHq52Yubbyp3Z9eaeDS7hTGH01SVOxncP2k11rF4jaapYobqC1eIdMYwiMba1xTvjGHfCrsR7j007Z3JjOfu";

  void init(){

  }

  Future payWithAnExistingCard(
    @required String amount,
    @required String currency
  ) async {

  }

  Future payWithNewCard() async {

  }

  Future payWithAppleOrGooglePay()async {

  }

  Future _crearPaymentIntent() async {

  }

  Future _pay() async {

  }
}