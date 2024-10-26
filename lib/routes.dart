import 'package:zekryptofolio/favourite/favourite.dart';
import 'package:zekryptofolio/home/home.dart';
import 'package:zekryptofolio/login/login.dart';
import 'package:zekryptofolio/market/market.dart';
import 'package:zekryptofolio/portfolio/portfolio.dart';
import 'package:zekryptofolio/profile/profile.dart';
import 'package:zekryptofolio/profile/community.dart';
import 'package:zekryptofolio/profile/support.dart';

var appRoutes = {
  "/": (context) => const HomeScreen(),
  "/login": (context) => const LoginScreen(),
  "/market": (context) => const MarketScreen(),
  "/portfolio": (context) => const PortfolioScreen(),
  "/profile": (context) => const ProfileScreen(),
  "/favourite": (context) => const FavouriteScreen(),
  "/community": (context) => const CommunityScreen(),
  "/support": (context) => const SupportScreen(),
};
