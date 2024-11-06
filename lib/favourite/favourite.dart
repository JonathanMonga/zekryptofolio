import "package:flutter/material.dart";
import 'package:zekryptofolio/model/favourite.dart';
import 'package:zekryptofolio/services/api.dart';

import 'package:zekryptofolio/market/market_item.dart';
import 'package:zekryptofolio/services/supabase_service.dart';
import 'package:zekryptofolio/shared/error.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({Key? key}) : super(key: key);

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Favourite>>(
        stream: SupabaseService().getFavourites(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: ErrorMessage(message: snapshot.error.toString()),
            );
          } else if (snapshot.hasData) {
            var data =
                snapshot.data!.map((toElement) => toElement.coin).toList();
            return FutureBuilder<List>(
                future: Api().fetchMarketData(coins: data),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: ErrorMessage(message: snapshot.error.toString()),
                    );
                  } else if (snapshot.hasData) {
                    var data = snapshot.data!;

                    if (data.isEmpty) {
                      return Scaffold(
                          appBar: AppBar(
                            automaticallyImplyLeading: false,
                            backgroundColor:
                                const Color.fromARGB(255, 33, 33, 33),
                            title: Row(
                              children: const [
                                Expanded(
                                    child: Text('Favourites',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25,
                                        )))
                              ],
                            ),
                          ),
                          body: Container(
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                              image: AssetImage('assets/Background_base.jpg'),
                              fit: BoxFit.cover,
                            )),
                            child: const Center(
                                child: Text(
                              "You do not have any favourite coins yet!",
                              textDirection: TextDirection.ltr,
                            )),
                          ));
                    }

                    return Scaffold(
                      appBar: AppBar(
                        title: const Text("Favourites"),
                        backgroundColor: const Color.fromARGB(255, 33, 33, 33),
                      ),
                      body: Container(
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                          image: AssetImage('assets/Background_base.jpg'),
                          fit: BoxFit.cover,
                        )),
                        child: RefreshIndicator(
                          onRefresh: () async {
                            setState(() {});
                          },
                          child: ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (BuildContext context, index) {
                                return MarketItem(coin: data[index], id: index);
                              }),
                        ),
                      ),
                    );
                  } else {
                    return const Text("No market data found in the api",
                        textDirection: TextDirection.ltr);
                  }
                });
          } else {
            return const Text("No market data found in the api",
                textDirection: TextDirection.ltr);
          }
        });
  }
}
