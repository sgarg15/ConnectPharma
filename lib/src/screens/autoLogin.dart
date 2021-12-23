import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_connect/src/screens/login.dart';

import 'Pharmacist/Main/jobHistoryPharmacist.dart';
import 'Pharmacy/Main/jobHistoryPharmacy.dart';

class AutoLogin extends ConsumerStatefulWidget {
  AutoLogin({Key? key}) : super(key: key);

  @override
  _AutoLoginState createState() => _AutoLoginState();
}

class _AutoLoginState extends ConsumerState<AutoLogin> {
  Future logInUser(WidgetRef ref) async {
    String? userType = await ref.read(authProviderLogin.notifier)
        .getCurrentUserData(FirebaseAuth.instance.currentUser?.uid);
    print("User Type in Log In User: $userType");

    if (userType == "Pharmacist") {
      print("Pharmacist");
      ref.read(logInProvider.notifier).clearAllValue();
      ref.read(userProviderLogin.notifier)
          .changeUserUID(FirebaseAuth.instance.currentUser?.uid);

      //send to pharmacist main page
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => JobHistoryPharmacist()));
    } else if (userType == "Pharmacy") {
      print("Pharmacy");

      ref.read(logInProvider.notifier).clearAllValue();
      ref.read(userProviderLogin.notifier)
          .changeUserUID(FirebaseAuth.instance.currentUser?.uid);

      //send to pharmacy main page
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => JobHistoryPharmacy()));
    } else if (userType == "Pharmacy Assistant") {
      print("Pharmacy Assistant");

      print("Sending to Pharmacist SignUp page1");
      ref.read(logInProvider.notifier).clearAllValue();

      print("Sending to Pharmacist SignUp page2");
      ref.read(userProviderLogin.notifier)
          .changeUserUID(FirebaseAuth.instance.currentUser?.uid);

      print("Sending to Pharmacist SignUp page3");

      //send to pharmacy main page
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => JobHistoryPharmacist()));
    } else if (userType == "Pharmacy Technician") {
      print("Pharmacy Technician");

      print("Sending to Pharmacist SignUp page1");
      ref.read(logInProvider.notifier).clearAllValue();

      print("Sending to Pharmacist SignUp page2");
      ref.read(userProviderLogin.notifier).changeUserUID(FirebaseAuth.instance.currentUser?.uid);

      print("Sending to Pharmacist SignUp page3");

      //send to pharmacy main page
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => JobHistoryPharmacist()));
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      logInUser(ref);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.45,
          ),
          Center(
              child: Text(
            "Loading....",
            style: TextStyle(fontSize: 20),
          )),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Center(child: CircularProgressIndicator()),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.33,
          ),
          Center(child: Text("Not loading? Log In Manually...")),
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 51,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.resolveWith<Color>((states) {
                        if (states.contains(MaterialState.disabled)) {
                          return Colors.grey; // Disabled color
                        }
                        return Color(0xFF5DB075); // Regular color
                      }),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ))),
                  onPressed: () {
                    ref.read(authProviderLogin.notifier).signOut();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LogInPage()));
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "Log In",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
