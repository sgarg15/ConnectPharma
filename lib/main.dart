import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './src/screens/Pharmacist/Sign Up/1pharmacistSignUp.dart';
import './src/screens/Pharmacy/Main/jobHistoryPharmacy.dart';
import './src/screens/autoLogin.dart';
import './src/screens/login.dart';
import './src/screens/Pharmacy/Sign Up/1pharmacy_signup.dart';

import 'src/providers/auth_provider.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

//TODO: Change Registration Province In Pharmacist to ask for Full province and not abbreviation for pharmacist signup
//Decrease Registration Number from 5 to 4 digits for pharmacist signup
//Add a option to select usertype at the end of pharmacist signup in case the value is null or empty

final authProvider2 = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider();
});

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate();
  //String? token = await FirebaseAppCheck.instance.getToken();
  //print("The token is: $token");

  const bool useEmulator = false;

  // ignore: dead_code
  if (useEmulator) {
    const localHostString = "192.168.1.93";
    // [Firestore | localhost:8080]
    FirebaseFirestore.instance.settings = const Settings(
      host: "$localHostString:8080",
      sslEnabled: false,
      persistenceEnabled: false,
    );

    // [Authentication | localhost:9099] "http://$localHostString:9099"
    await FirebaseAuth.instance.useAuthEmulator(localHostString, 9099);

    // [Storage | localhost:9199]
    await FirebaseStorage.instance.useStorageEmulator(
      localHostString,
      9199,
    );

    FirebaseFunctions functions = FirebaseFunctions.instance;
    functions.useFunctionsEmulator(localHostString, 5001);
  }

  await dotenv.load();
  runApp(
    const ProviderScope(
      child: MaterialApp(
        home: ConnectPharma(),
        debugShowCheckedModeBanner: false,
      ),
    ),
  );
}

class ConnectPharma extends ConsumerStatefulWidget {
  const ConnectPharma({Key? key}) : super(key: key);

  @override
  _ConnectPharmaState createState() => _ConnectPharmaState();
}

class _ConnectPharmaState extends ConsumerState<ConnectPharma> {
  @override
  void initState() {
    super.initState();
    print("Inside main page");
    print("Current User: ${FirebaseAuth.instance.currentUser?.uid}");
    print(ref.read(pharmacyMainProvider.notifier).userData);
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (FirebaseAuth.instance.currentUser != null &&
          FirebaseAuth.instance.currentUser!.emailVerified) {
        print("Current User: ${FirebaseAuth.instance.currentUser}");
        print("Logging In");
        //logInUser();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AutoLogin()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            //Pharma Text
            Container(
              alignment: const Alignment(-0.45, -0.55),
              child: RichText(
                text: const TextSpan(
                  text: "Pharma",
                  style:
                      TextStyle(fontWeight: FontWeight.w300, fontSize: 50.0, color: Colors.black),
                ),
              ),
            ),
            //Connect Text
            Container(
              //top: 240,
              // left: 130,
              alignment: const Alignment(0.45, -0.35),
              child: RichText(
                text: const TextSpan(
                  text: "Connect",
                  style:
                      TextStyle(fontWeight: FontWeight.w300, fontSize: 50.0, color: Colors.black),
                ),
              ),
            ),
            //Register Text
            Container(
              //top: 360,
              alignment: const Alignment(0, -0.1),
              child: RichText(
                text: const TextSpan(
                  text: "Register",
                  style:
                      TextStyle(fontWeight: FontWeight.w300, fontSize: 35.0, color: Colors.black),
                ),
              ),
            ),
            //Button For Pharmacist Registration
            Container(
              alignment: const Alignment(0, 0.1),
              child: SizedBox(
                width: 300,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    //Send to Pharmacist Sign Up Page
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PharmacistSignUpPage(
                                  userType: "Pharmacist",
                                )));
                  },
                  child: RichText(
                    text: const TextSpan(
                      text: "Pharmacist",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            //Pharmacy Assistant
            Container(
              alignment: const Alignment(0, 0.3),
              child: SizedBox(
                width: 300,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    //Send to Pharmacy Assistant Sign Up Page
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PharmacistSignUpPage(
                                  userType: "Pharmacy Assistant",
                                )));
                  },
                  child: RichText(
                    text: const TextSpan(
                      text: "Pharmacy Assistant",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            //Pharmacy Technician
            Container(
              alignment: const Alignment(0, 0.5),
              child: SizedBox(
                width: 300,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    //Send to Pharmacy Assistant Sign Up Page
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PharmacistSignUpPage(
                                  userType: "Pharmacy Technician",
                                )));
                  },
                  child: RichText(
                    text: const TextSpan(
                      text: "Pharmacy Technician",
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
              alignment: const Alignment(0, 0.7),
              child: SizedBox(
                width: 300,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    //Send to Pharmacy Sign Up Page
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => const PharmacySignUpPage()));
                  },
                  child: RichText(
                    text: const TextSpan(
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
            // Center(
            //   child: Consumer(
            //     builder: (context, watch, child) {
            //       watch(pharmacistSignUpProvider);
            //       return SizedBox(
            //         width: 324,
            //         height: 51,
            //         child: ElevatedButton(
            //           style: ButtonStyle(
            //               backgroundColor:
            //                   MaterialStateProperty.resolveWith<Color>(
            //                       (states) {
            //                 if (states.contains(MaterialState.disabled)) {
            //                   return Colors.grey; // Disabled color
            //                 }
            //                 return Color(0xFF5DB075); // Regular color
            //               }),
            //               shape:
            //                   MaterialStateProperty.all<RoundedRectangleBorder>(
            //                       RoundedRectangleBorder(
            //                 borderRadius: BorderRadius.circular(100),
            //               ))),
            //           onPressed: () async {
            //             print("Pressed");
            //             context
            //                 .read(authProviderLogin.notifier)
            //                 .registerWithEmailAndPassword(
            //                     getRandomString(5) + "@gmail.com", "Sat@2003")
            //                 .then((value) async {
            //               print("UPLOADING DATA");
            //               if (value == null) {
            //                 print("ERROR");
            //                 final snackBar = SnackBar(
            //                   content: Text(
            //                       "There was an error trying to register you. Please check your email and password and try again."),
            //                 );
            //                 ScaffoldMessenger.of(context)
            //                     .showSnackBar(snackBar);
            //                 //value!.user!.delete();
            //                 return null;
            //               } else {
            //                 context
            //                     .read(authProviderLogin.notifier)
            //                     .uploadTestInformaiton(value, context)
            //                     .then((value) async {
            //                   final snackBar = SnackBar(
            //                     content: Text("User Registered"),
            //                   );
            //                   ScaffoldMessenger.of(context)
            //                       .showSnackBar(snackBar);
            //                   print("DATA UPLOADED");
            //                   await value?.user
            //                       ?.sendEmailVerification()
            //                       .then((_) {
            //                     context
            //                         .read(pharmacistSignUpProvider.notifier)
            //                         .clearAllValues();
            //                     Navigator.push(
            //                         context,
            //                         MaterialPageRoute(
            //                             builder: (context) => PharmaConnect()));
            //                     showDialog(
            //                         context: context,
            //                         builder: (context) => AlertDialog(
            //                               title: Text("Verification Email"),
            //                               content: Text(
            //                                   "An verification email was sent to you. Please follow the link and verify your email. Once finished you may log in using your email and password."),
            //                               actions: <Widget>[
            //                                 new TextButton(
            //                                   child: new Text("Ok"),
            //                                   onPressed: () {
            //                                     Navigator.of(context).pop();
            //                                   },
            //                                 ),
            //                               ],
            //                             ));
            //                   });
            //                 });
            //               }
            //             });
            //           },
            //           child: RichText(
            //             text: TextSpan(
            //               text: "Submit",
            //               style: TextStyle(
            //                 fontSize: 16,
            //                 color: Colors.white,
            //                 fontWeight: FontWeight.bold,
            //               ),
            //             ),
            //           ),
            //         ),
            //       );
            //     },
            //   ),
            // ),

            //Log In Text and Button
            Container(
              alignment: const Alignment(0, 0.95),
              child: GestureDetector(
                child: RichText(
                  text: const TextSpan(
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

                  Navigator.push(context, MaterialPageRoute(builder: (context) => const LogInPage()));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
