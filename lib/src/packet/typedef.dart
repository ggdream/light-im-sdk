// enum PacketType {
//   ping(1),
//   pong(2),
//   message(3);

//   final int value;
//   const PacketType(this.value);
// }

class PacketType {
  static const ping = 1;
  static const pong = 2;
  static const auth = 3;
  static const pass = 4;
  static const message = 5;
}

abstract class PacketDataModel {
  Map<String, dynamic> toMap();
}
