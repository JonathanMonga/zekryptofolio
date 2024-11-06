import 'package:zekryptofolio/favourite/favourite.dart';
import 'package:zekryptofolio/home/home.dart';
import 'package:zekryptofolio/login/auth_page.dart';
import 'package:zekryptofolio/market/market.dart';
import 'package:zekryptofolio/portfolio/portfolio.dart';
import 'package:zekryptofolio/profile/profile.dart';
import 'package:zekryptofolio/profile/community.dart';
import 'package:zekryptofolio/profile/support.dart';

var appRoutes = {
  "/": (context) => const HomeScreen(),
  "/login": (context) => const AuthPage(),
  "/market": (context) => const MarketScreen(),
  "/portfolio": (context) => const PortfolioScreen(),
  "/profile": (context) => const ProfileScreen(),
  "/favourite": (context) => const FavouriteScreen(),
  "/community": (context) => const CommunityScreen(),
  "/support": (context) => const SupportScreen(),
  "/register": (context) => const AuthPage()
};
