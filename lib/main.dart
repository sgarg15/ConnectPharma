import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_connect/src/screens/Pharmacist/Sign Up/1pharmacistSignUp.dart';
import 'package:pharma_connect/src/screens/login.dart';
import 'package:pharma_connect/src/screens/Pharmacy/Sign Up/1pharmacy_signup.dart';

import 'src/providers/auth_provider.dart';

final authProvider2 = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider();
});

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  const bool USE_EMULATOR = false;

  // ignore: dead_code
  if (USE_EMULATOR) {
    const localHostString = 'localhost';
    // [Firestore | localhost:8080]
    FirebaseFirestore.instance.settings = const Settings(
      host: "$localHostString:8080",
      sslEnabled: false,
      persistenceEnabled: false,
    );

    // [Authentication | localhost:9099]
    await FirebaseAuth.instance.useEmulator('http://$localHostString:9099');

    // [Storage | localhost:9199]
    await FirebaseStorage.instance.useStorageEmulator(
      '$localHostString',
      9199,
    );

    FirebaseFunctions functions = FirebaseFunctions.instance;
    functions.useFunctionsEmulator("$localHostString", 5001);
  }

  await dotenv.load();
  runApp(
    ProviderScope(
      child: MaterialApp(
        home: PharmaConnect(),
        debugShowCheckedModeBanner: false,
      ),
    ),
  );
}

class PharmaConnect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            //Pharma Text
            Container(
              alignment: Alignment(-0.45, -0.55),
              child: RichText(
                text: TextSpan(
                  text: "Pharma",
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 50.0,
                      color: Colors.black),
                ),
              ),
            ),
            //Connect Text
            Container(
              //top: 240,
              // left: 130,
              alignment: Alignment(0.45, -0.35),
              child: RichText(
                text: TextSpan(
                  text: "Connect",
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 50.0,
                      color: Colors.black),
                ),
              ),
            ),
            //Register Text
            Container(
              //top: 360,
              alignment: Alignment(0, 0.2),
              child: RichText(
                text: TextSpan(
                  text: "Register",
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 35.0,
                      color: Colors.black),
                ),
              ),
            ),
            //Button For Pharmacist Registration
            Container(
              alignment: Alignment(0, 0.4),
              child: SizedBox(
                width: 300,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    //Send to Pharmacist Sign Up Page
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PharmacistSignUpPage()));
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "Pharmacist",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            //Button For Pharmacy Registration
            Container(
              alignment: Alignment(0, 0.6),
              child: SizedBox(
                width: 300,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    //Send to Pharmacy Sign Up Page
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PharmacySignUpPage()));
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "Pharmacy",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // //Button to test Cloud Functions
            // Container(
            //   alignment: Alignment(0, 0.8),
            //   child: SizedBox(
            //     width: 300,
            //     height: 50,
            //     child: ElevatedButton(
            //       onPressed: () {
            //         //Send to Pharmacy Sign Up Page
            //         context
            //             .read(authProvider2.notifier)
            //             .uploadTestInformaiton();
            //       },
            //       child: RichText(
            //         text: TextSpan(
            //           text: "Test Cloud Functions",
            //           style: TextStyle(
            //             fontSize: 20,
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),

            //Log In Text and Button
            Container(
              alignment: Alignment(0, 0.95),
              child: GestureDetector(
                child: RichText(
                  text: TextSpan(
                    text: "Log In",
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 25.0,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                onTap: () {
                  //Push to Login Screen
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LogInPage()));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
