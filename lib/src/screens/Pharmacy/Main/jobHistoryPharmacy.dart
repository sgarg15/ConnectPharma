import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_connect/main.dart';
import 'package:pharma_connect/src/providers/auth_provider.dart';

final authProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider();
});

class JobHistoryPharmacy extends StatefulWidget {
  JobHistoryPharmacy({Key? key}) : super(key: key);

  @override
  _JobHistoryState createState() => _JobHistoryState();
}

class _JobHistoryState extends State<JobHistoryPharmacy> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: RichText(
            text: TextSpan(
              text: "Job History",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 24.0,
                  color: Colors.black),
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.black,
            ),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
        ),
        
        drawer: SideMenuDrawer(),
        body: Container(
          child: Stack(
            children: <Widget>[
              Center(
                child: ElevatedButton(
                    onPressed: () {
                      context.read(authProvider.notifier).signOut();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PharmaConnect()));
                    },
                    child: Text("Sign Out")),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SideMenuDrawer extends StatelessWidget {
  const SideMenuDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer();
  }
}
