import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gtk_flutter/src/Deliciouslyyy/AddRecipesPage.dart';
import 'package:gtk_flutter/src/Deliciouslyyy/InitialAllRecipesPage.dart';
import 'package:gtk_flutter/src/Deliciouslyyy/MyRecipes.dart';
import 'package:gtk_flutter/src/Deliciouslyyy/MySavedRecipes.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'UserProfileScreen.dart';
import 'start_screen.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  bool shouldShow = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  QueryDocumentSnapshot<Map<String, dynamic>>? currentUser;

  User? user;
  var user_detail;

  Future<void> checkAuthentication() async {
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.push<void>(
            context, MaterialPageRoute(builder: (context) => const Start()));
      }
      if (mounted) {
        setState(() {});
      }
    });
  }

  Future getUserDetailsById() async {
    if (user?.uid != null) {
      await firestore
          .collection('users')
          .where('user_id', isEqualTo: user?.uid)
          .get()
          .then((value) {
        var data = value.docs[0].data();
        setState(() {
          user_detail = data;
        });
      });
    }
  }

  void getUser() {
    User? _localuser = _auth.currentUser;
    _localuser?.reload();
    if (_localuser != null) {
      setState(() {
        user = _localuser;
        getUserDetailsById();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    checkAuthentication();
    getUser();
    
  }

  void signout() {
    _auth.signOut();
  }

  Future getUserInfo() async {
    firestore
        .collection('users')
        .where('user_id', isEqualTo: user?.uid)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          currentUser = querySnapshot.docs[0];
        });
      }
    });
  }

  void showLogoutDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Are you sure you want to log out?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('NO',
                  style: TextStyle(color: Color.fromRGBO(18, 23, 64, 1))),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('YES', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                await _auth.signOut();
              },
            ),
          ],
        );
      },
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (currentUser == null) {
      getUserInfo();
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: Scaffold(
        appBar: AppBar(
            backgroundColor: const Color.fromRGBO(18, 23, 64, 1),
            title: const Text('Deliciouslyyy'),
            actions: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      showLogoutDialog(context);
                    },
                    child: const Icon(
                      Icons.logout,
                      size: 25,
                    ),
                  )),
            ]),
        body: pageToDisplay(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: const Color.fromRGBO(18, 23, 64, 1),
          unselectedItemColor: Colors.grey.shade600,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.dining_sharp),
              label: 'My Recipes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Saved recipes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_box),
              label: 'Profile',
            ),
          ],
        ),
        floatingActionButton: !shouldShow? null:GestureDetector(
          onTap: () => showBarModalBottomSheet(
            expand: true,
            isDismissible: true,
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context) => AddRecipesPage(),
          ),
          child: Container(
            padding: EdgeInsets.only(left: 8, right: 15, top: 10, bottom: 15),
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.indigo,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 20,
                ),
                SizedBox(
                  width: 2,
                ),
                Text(
                  "Add Recipe",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  StatefulWidget pageToDisplay(int selectedIndex) {
    StatefulWidget? sw;
    switch (selectedIndex) {
      case 1:
        sw = MyRecipesPage();
        setState(() {
          shouldShow = true;
        });
        break;
      case 2:
        sw = MySavedRecipes();
        setState(() {
          shouldShow = false;
        });
        break;
      case 3:
        sw = UserProfilePage(user_detail: user_detail);
        setState(() {
          shouldShow = false;
        });
        break;
      default:
        sw = InitialAllRecipesPage();
        setState(() {
          shouldShow = false;
        });
        break;
    }
    return sw;
  }
}
