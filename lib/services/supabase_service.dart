import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final currentUser = Supabase.instance.client.auth.currentUser;

  Future<List<Map<String, dynamic>>> getFavourites() async {
    try {
      return Supabase.instance.client
          .from('favourites')
          .select()
          .eq("user_id", currentUser!.id);
    } catch (error) {
      return [];
    }
  }

  void addFavourite(String coin) async {
    await Supabase.instance.client
        .from('favourites')
        .insert({'coins': coin, 'user_id': currentUser!.id});
  }

  void removeFavourite(String id) async {
    await Supabase.instance.client
        .from('favourites')
        .delete()
        .eq('coins', id)
        .eq("user_id", currentUser!.id);
  }

  Future<List<Map<String, dynamic>>> getSummaries([String coinID = ""]) async {
    try {
      if (coinID.isEmpty) {
        return Supabase.instance.client.from('summary').select().eq(
              "user_id",
              currentUser!.id,
            );
      } else {
        return Supabase.instance.client
            .from('summary')
            .select()
            .eq(
              "user_id",
              currentUser!.id,
            )
            .eq("coins", coinID);
      }
    } catch (error) {
      return [];
    }
  }

  void addTransaction(
      String coinID, String image, double amount, double currentPrice) async {
    await Supabase.instance.client.from('transactions').insert(
        {'coins': coinID, 'user_id': currentUser!.id, 'amount': amount});

    addSummary(coinID, image, amount, currentPrice);
  }

  void addSummary(
      String coinID, String image, double amount, double currentPrice) async {
    var total = await getCoinTotal(coinID, currentPrice);
    var summaries = await getSummaries(coinID);

    if (summaries.isEmpty) {
      await Supabase.instance.client.from('summary').insert({
        'coins': coinID,
        'image': image,
        'user_id': currentUser!.id,
        'total': total
      });
    } else {
      await Supabase.instance.client
          .from('summary')
          .update({'total': total})
          .eq("coins", coinID)
          .eq("user_id", currentUser!.id);
    }
  }

  Future<List<Map<String, dynamic>>> getTransactions() async {
    try {
      return Supabase.instance.client
          .from('transactions')
          .select()
          .eq("user_id", currentUser!.id);
    } catch (error) {
      return [];
    }
  }

  Future<double> getCoinTotal(String coin, double currentPrice) async {
    var total = 0.0;

    try {
      var transactions = await Supabase.instance.client
          .from('transactions')
          .select()
          .eq("coins", coin);

      if (transactions.isNotEmpty) {
        for (var transaction in transactions) {
          if (transaction["coins"] == coin) {
            total += transaction["amount"] * currentPrice;
          }
        }

        return total;
      } else {
        return total;
      }
    } catch (error) {
      return total;
    }
  }

  SupabaseStreamBuilder streamFavourite() {
    Supabase.instance.client
        .channel('public:favourites')
        .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: 'favourites',
            callback: (payload) {
              debugPrint('Change received: ${payload.toString()}');
            })
        .subscribe();

    return Supabase.instance.client
        .from('favourites')
        .stream(primaryKey: ['coin'])
        .order('name')
        .limit(10);
  }
}
