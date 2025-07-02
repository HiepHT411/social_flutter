class ResponseMetaData<T> {
  final Meta meta;

  final T data;

  ResponseMetaData(this.meta, this.data);

  factory ResponseMetaData.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    return ResponseMetaData(Meta.fromJson(json['meta']), fromJsonT(json['data']));
  }

  factory ResponseMetaData.fromJsonList(
      Map<String, dynamic> json,
      T Function(Map<String, dynamic>) fromJsonT,
      ) {
    // final list = (json['data'] as List)
    //     .map((item) => fromJsonT(item as Map<String, dynamic>))
    //     .toList();

    return ResponseMetaData(
      Meta.fromJson(json['meta']),
      json['data'],
    );
  }
}

class Meta {
  final int code;
  final String message;

  Meta(this.code, this.message);

  factory Meta.fromJson(Map<String, dynamic> map) {
    return Meta(map['code'] as int, map['message'] as String);
  }
}
