class ResponseModel<T> {
  final int code;
  final String desc;
  final T? data;

  ResponseModel.fromMap(
      Map<String, dynamic> map, T? Function(Map<String, dynamic> map) fromMap)
      : code = map['code'],
        desc = map['desc'],
        data = fromMap(map['data'] ?? {});
}
