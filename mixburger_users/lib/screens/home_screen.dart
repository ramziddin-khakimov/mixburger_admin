import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mixburger_users/assistantMethods/assistant_methods.dart';
import 'package:mixburger_users/widgets/items_avatar_carousel.dart';
import 'package:mixburger_users/widgets/my_drawer.dart';
import 'package:mixburger_users/widgets/progress_bar.dart';

import '../authentication/login.dart';
import '../models/sellers.dart';
//import '../widgets/seller_avatar_carousel.dart';
import '../widgets/design/sellers_design.dart';
import '../widgets/user_info.dart';
import 'menus_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final TextEditingController _controller = TextEditingController();
 late Sellers mod;
  @override
  void initState() {
    super.initState();

    clearCartNow(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: FractionalOffset(-2.0, 0.0),
            end: FractionalOffset(5.0, -1.0),
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFFFAC898),
            ],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            //appbar
            SliverAppBar(
              elevation: 1,
              pinned: true,
              backgroundColor: const Color(0xFFFAC898),
              foregroundColor: Colors.black,
              expandedHeight: 50,
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: FractionalOffset(-1.0, 0.0),
                    end: FractionalOffset(4.0, -1.0),
                    colors: [
                      Color(0xFFFFFFFF),
                      Color(0xFFFAC898),
                    ],
                  ),
                ),
                child: FlexibleSpaceBar(
                  title: Text(
                    'Mix Burger',
                    style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                  centerTitle: false,
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: GestureDetector(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.amber,
                      ),
                      child: const Icon(Icons.exit_to_app),
                    ),
                    onTap: () {
                      firebaseAuth.signOut().then((value) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (c) => const LoginScreen(),
                          ),
                        );
                        _controller.clear();
                      });
                    },
                  ),
                ),
              ],
            ),
            //Carausel
            SliverToBoxAdapter(
              child: Container(
                child: UserInformation(),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection("sellers").snapshots(),
              builder: (context, snapshot) {
                return !snapshot.hasData
                    ? SliverToBoxAdapter(
                        child: Center(
                          child: circularProgress(),
                        ),
                      )
                    : SliverStaggeredGrid.countBuilder(
                        staggeredTileBuilder: (c) => const StaggeredTile.fit(1),
                        crossAxisCount: 1,
                        mainAxisSpacing: 1,
                        crossAxisSpacing: 1,
                        itemBuilder: (context, index) {
                          Sellers smodel = Sellers.fromJson(
                              snapshot.data!.docs[index].data()!
                                  as Map<String, dynamic>);
                          return MenusScreen(model: smodel,);
                        },
                        itemCount: snapshot.data!.docs.length,
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}
