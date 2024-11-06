import "package:flutter/material.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zekryptofolio/favourite/favourite.dart';
import 'package:zekryptofolio/login/auth_page.dart';
import 'package:zekryptofolio/login/login_screen.dart';
import 'package:zekryptofolio/market/market.dart';
import 'package:zekryptofolio/portfolio/portfolio.dart';
import 'package:zekryptofolio/profile/profile.dart';
import 'package:zekryptofolio/services/auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
        stream: AuthService().getAuthStateChange(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Error", textDirection: TextDirection.ltr),
            );
          } else if (snapshot.hasData) {
            switch (snapshot.data!.event) {
              case AuthChangeEvent.initialSession:
                {
                  if (snapshot.data!.session != null &&
                      !snapshot.data!.session!.isExpired) {
                    return const MainScreen();
                  } else {
                    return const AuthPage();
                  }
                }
              case AuthChangeEvent.signedIn:
                return const MainScreen();
              case AuthChangeEvent.signedOut:
                return const AuthPage();
              case AuthChangeEvent.passwordRecovery:
                return const MainScreen();
              case AuthChangeEvent.tokenRefreshed:
                return const MainScreen();
              case AuthChangeEvent.userUpdated:
                return const MainScreen();
              case AuthChangeEvent.userDeleted:
                return const AuthPage();
              case AuthChangeEvent.mfaChallengeVerified:
                return const AuthPage();
              default:
                return const AuthPage();
            }
          } else {
            return const AuthPage();
          }
        });
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    PortfolioScreen(),
    MarketScreen(),
    FavouriteScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        iconSize: 20,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color.fromARGB(255, 33, 33, 33),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.chartLine,
            ),
            label: 'Porfolio',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.briefcase,
            ),
            label: 'Market',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.heart,
            ),
            label: 'Favourite',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.userAlt,
            ),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
