
import 'package:flutter/material.dart';
import 'package:flutter_directory_app/login_page.dart';
import 'package:flutter_directory_app/show_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 0;
  List<Widget> pages = [
    // HomePage(),
    ShowData(),
   
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "All India Palliwal Jain Association",
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1.2,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Lato',
          ),
        ),
        titleSpacing: 00.0,
        centerTitle: true,
        toolbarHeight: 60.2,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            bottomLeft: Radius.circular(25),
          ),
        ),
        elevation: 0.00,
        backgroundColor:const Color.fromRGBO(5, 111, 146, 1),
        // actions: [
        //    IconButton(
        //       onPressed: logout,
        //       icon: const Icon(Icons.exit_to_app),
        //       color: Colors.white,
        //     ),
        // ],
      ),
      body: IndexedStack(
        index: currentPage,
        children: [
          homeContent(),
          ...pages,
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage,
        onTap: (value) {
          setState(() {
            currentPage = value;
          });
        },
        iconSize: 30,
        selectedFontSize: 0,
        unselectedFontSize: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: '',
          ),
          
        ],
      ),
    );
  }

  homeContent() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                const SizedBox(height:20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        height: 200,
                        width: 200,
                        child: Image.asset('assets/images/logo.jpeg')
                      ),
                    ),
                  ],
                ),
                SizedBox(height:20),
               Column(
                    children: [
                      const SizedBox(height: 15),
                     
                      Text(
                        "Introduction Booklet",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 10,),
                      Text(
                        "or",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 10,),
                      const Text(
                        "Telephone Directory",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize:
                              25,
                          letterSpacing: 1.5,
                          shadows: [
                            Shadow(
                              color: const Color.fromRGBO(5, 111, 146, 1),
                              blurRadius: 7.0, 
                              offset: Offset(-2.0, 2.0),
                              ),
                          ],
                            ),
                        ),
                    ],
                  ),
                
                const SizedBox(height: 60 ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromRGBO(5, 111, 146, 1),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25))
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()));
                      },
                      child: Row(
                        children: [
                          const Text(
                            'Get Started',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: constraints.maxWidth * 0.01,
                          ),
                         const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  //  void logout() async {
  //   await FirebaseAuth.instance.signOut();
  //   Navigator.popUntil(context, (route) => route.isFirst);
  //   Navigator.pushReplacement(
  //       context, MaterialPageRoute(builder: (context) => LoginPage()));
  // }
}
