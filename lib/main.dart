import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:tabasco_escapes/bloc/bloc/pagar_bloc.dart';
import 'package:tabasco_escapes/pages/anuncios.dart';
import 'package:tabasco_escapes/pages/comunity_page.dart';
import 'package:tabasco_escapes/pages/detalle_anuncio_page.dart';
import 'package:tabasco_escapes/pages/home_page.dart';
import 'package:tabasco_escapes/pages/planner_page.dart';
import 'package:tabasco_escapes/pages/portal_empresa.dart';
import 'package:tabasco_escapes/pages/rutas.dart';
import 'package:tabasco_escapes/pages/pago_page.dart';
import 'package:tabasco_escapes/preferences/preferences.dart';
import 'package:tabasco_escapes/services/notification_service.dart';
import 'firebase_options.dart';

import 'dart:io' show Platform;
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences.init();
  Stripe.publishableKey = "pk_live_51Nk96OIkn5iPfYiHYVU9122iX2lnB1aEq9qVnXYO7TK7f8bfCU19RgVqFSxSqA32qiTwfRA9aloz88zG603lBKcf00u5CBfpsZ";
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Stripe.instance.applySettings();
  await NotificationServices().initNotifications();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_)=> PagarBloc(),)
      ],
      child: MaterialApp(
        title: 'PlayTab',
        theme: ThemeData(
            primaryColor: const Color.fromARGB(255, 158, 30, 68),
            appBarTheme:
                const AppBarTheme(color: Color.fromARGB(255, 158, 30, 68))),
        initialRoute:
            FirebaseAuth.instance.currentUser != null ? "home" : "login",
        //initialRoute: "home",
        debugShowCheckedModeBanner: false,
        locale: const Locale('es'),
        localizationsDelegates: [
          FirebaseUILocalizations.withDefaultOverrides(const LabelOverrides()),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          FirebaseUILocalizations.delegate
        ],
        routes: {
          "home": (context) => const HomePage(),
          "rutas": (context) => const Rutas(),
          "comunity": (context) => ComunityPage(),
          "dashboard": (context) => PortalEmpresa(),
          "upgrade": (context) => PagoPage(),
          "planner": (context) => PlannerPage(),
          "anuncios": (context) => Anuncios(),
          "detalleAnuncio": (context)=> DetalleAnuncioPage(),
          "profile": (context) => ProfileScreen(
                providers: [
                  EmailAuthProvider(),
                  GoogleProvider(
                      clientId:
                          Platform.isIOS ? "718367715543-ogp7nuj35gdgq67rg57r2atuubokmvkm.apps.googleusercontent.com" : "718367715543-k0ns3laihb1jnk9rpgs5lqos67oj08tp.apps.googleusercontent.com")
                ],
                actions: [
                  SignedOutAction((context) {
                    Preferences.isUpgraded = false;
                    Navigator.pushReplacementNamed(context, 'login');
                  }),
                ],
                appBar: AppBar(
                  title: const Text("Mi perfil"),
                ),
              ),
          "login": (context) => SignInScreen(
                providers: [
                  EmailAuthProvider(),
                  GoogleProvider(
                      clientId:
                          Platform.isIOS ? "718367715543-ogp7nuj35gdgq67rg57r2atuubokmvkm.apps.googleusercontent.com" : "718367715543-k0ns3laihb1jnk9rpgs5lqos67oj08tp.apps.googleusercontent.com")
                ],
                headerBuilder: (context, constraints, _) {
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: Image.asset("assets/img/logo.png"),
                  );
                },
                actions: [
                  AuthStateChangeAction<SignedIn>((context, _) async {
                    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
                    //print(FirebaseAuth.instance.currentUser?.uid);
                    DocumentSnapshot snapshot = await _firestore.collection("Empresas").doc(FirebaseAuth.instance.currentUser?.uid).get();
                    //print(snapshot.toString());
                    if(snapshot.exists){
                      Map<String, dynamic> documentData = snapshot.data() as Map<String, dynamic>;                      
                      DateTime ultimoPago = DateTime.parse(documentData["last_payment"]);
                      DateTime hoy = DateTime.now();
                      DateTime vencimiento = DateTime(ultimoPago.year, ultimoPago.month + 1, ultimoPago.day);

                      int activo = hoy.compareTo(vencimiento);
                      print(activo);
                      if(activo<0){
                        Preferences.isUpgraded = true;
                        Preferences.nombreEmpresa = documentData["Nombre"];
                        Preferences.logotipo = "";
                        print(activo);
                      }
                      else if(activo==0){
                        Preferences.isUpgraded = true;
                        Preferences.nombreEmpresa = documentData["nombre"];
                        Preferences.logotipo = "";
                        print(activo);
                      }
                      else{
                        Preferences.isUpgraded = false;
                      }
                    }
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            "Bienvendio ${FirebaseAuth.instance.currentUser?.displayName} !")));
                    Navigator.pushReplacementNamed(context, "home");
                  }),
                  AuthStateChangeAction<UserCreated>((context, _) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Bienvendio")));
                    Navigator.pushReplacementNamed(context, "home");
                  })
                ],
              ),
        },
      ),
    );
  }
}

class LabelOverrides extends DefaultLocalizations {
  const LabelOverrides();

  @override
  String get emailInputLabel => "Ingresa tu Correo";

  @override
  String get signInText => "Iniciar Sesión";

  @override
  String get passwordInputLabel => "Ingresa tu contraseña";

  @override
  String get signInActionText => "Iniciar Sesion";

  @override
  String get registerActionText => "Registrate";

  @override
  String get signInWithGoogleButtonText => "Iniciar Sesión con Google";

  @override
  String get registerText => "Registrate";

  @override
  String get registerHintText => "¿No tienes cuenta?";

  @override
  String get signOutButtonText => "Cerrar sesión";

  @override
  String get deleteAccount => "Eliminar cuenta";

  @override
  String get forgotPasswordViewTitle => "¿Olvidaste tu contraseña?";

  @override
  String get forgotPasswordButtonLabel => "¿Olvidaste tu contraseña?";

  @override
  String get resetPasswordButtonLabel => "Reestablecer contraseña";

  @override
  String get forgotPasswordHintText =>
      "Ingresa tu correo electrónico y te enviaremos un correo con un enlace para reestabecer tu contraseña";

  @override
  String get goBackButtonLabel => "Regresar";

  @override
  String get confirmPasswordInputLabel => "Por favor, confirma tu contraseña";
}
