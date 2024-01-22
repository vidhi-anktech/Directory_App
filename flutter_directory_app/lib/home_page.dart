import 'package:flutter/material.dart';
import 'package:flutter_directory_app/login_page.dart';
import 'package:flutter_directory_app/register_details_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 0;
  List<Widget> pages = [
    // HomePage(),
    LoginPage(),
    RegistrationPage(),
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
        backgroundColor: const Color.fromARGB(255, 124, 167, 241),
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
            icon: Icon(Icons.login),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add),
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: CircleAvatar(
                        radius: constraints.maxWidth * 0.2,
                        child: Image.asset('images/logo.jpg'),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Sakal Palliwal Jain Society,",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        "Jaipur",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "WELCOMES YOU",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize:
                              constraints.maxWidth * 0.05, // Removed const
                          letterSpacing:
                              constraints.maxWidth * 0.005, // Removed const
                          shadows: [
                            Shadow(
                              color: Colors.blue,
                              blurRadius:
                                  constraints.maxWidth * 0.012, // Removed const
                              offset: Offset(
                                -constraints.maxWidth * 0.01, // Removed const
                                constraints.maxWidth * 0.01, // Removed const
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "at",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Introduction Booklet",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        "or",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        "Telephone Directory",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 109, 158, 243),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(25),
                            bottomRight: Radius.circular(25),
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                      },
                      child: Row(
                        children: [
                          Text(
                            'Get Started',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: constraints.maxWidth * 0.04,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: constraints.maxWidth * 0.01,
                          ),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: constraints.maxWidth * 0.03,
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
}
