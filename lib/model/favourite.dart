import 'package:objectbox/objectbox.dart';

@Entity()
class Favourite {
  @Id()
  int id;
  String coin;

  Favourite(this.coin, {this.id = 0});
}
