import 'dart:convert';

import 'pkt_data.dart';
import 'typedef.dart';

export 'pkt_data.dart';
export 'typedef.dart';

class Packet {
  final int type;
  final PacketDataModel data;

  const Packet({
    required this.type,
    required this.data,
  });

  factory Packet.fromMap(Map<String, dynamic> json) {
    final int type = json['type'];
    final jsonData = json['data'];

    late final PacketDataModel data;
    switch (type) {
      case PacketType.pass:
        data = PassPktDataModel.fromMap(jsonData);
        break;
      case PacketType.pong:
        data = PongPktDataModel.fromMap(jsonData);
        break;
      case PacketType.message:
        data = MessagePktDataModel.fromMap(jsonData);
        break;
      default:
    }

    return Packet(type: type, data: data);
  }

  Map<String, dynamic> toMap() => {
        'type': type,
        'data': data.toMap(),
      };

  String toJson() => jsonEncode(toMap());
}
