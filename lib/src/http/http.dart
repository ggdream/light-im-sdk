import 'package:dio/dio.dart';

import 'model/model.dart';
import 'status.dart';

export 'model/model.dart';

class LightIMSDKHttp {
  LightIMSDKHttp._();

  static late final Dio dio;

  static void init({
    required String baseUrl,
    // required String userId,
    // required String token,
  }) {
    final opts = BaseOptions(
      connectTimeout: const Duration(seconds: 5),
      sendTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      baseUrl: baseUrl,
      responseType: ResponseType.json,
      contentType: Headers.jsonContentType,
      headers: {
        'user-agent': 'light-im',
        'referer': 'flutter',
      },
    );

    dio = Dio(opts);
  }

  static void auth({
    required String userId,
    required String token,
  }) {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers.addAll({
          'light-im-uid': userId,
          'light-im-token': token,
        });

        return handler.next(options);
      },
    ));
  }

  static void close() => dio.close();

  static Future<ResponseModel<T?>?> post<T>(
      String path,
      Map<String, dynamic> data,
      T Function(Map<String, dynamic> map) fromMap) async {
    try {
      final res = await dio.post<Map<String, dynamic>>(path, data: data);
      if (res.data == null) return null;
      if (res.data!['code'] != Status.success) {
        checkCode(res.data!['code']);
        return ResponseModel.fromMap(res.data!, (_) => null);
      }
      if (!res.data!.containsKey('data')) {
        return ResponseModel.fromMap(res.data!, (_) => null);
      }

      return ResponseModel.fromMap(res.data!, fromMap);
    } on DioException {
      rethrow;
    } catch (e) {
      return null;
    }
  }

  static bool checkRes<T>(ResponseModel<T?>? model) {
    if (model == null) return false;
    if (model.code != Status.success) return false;

    return true;
  }

  static void checkCode(int code) {
    switch (code) {
      case Status.success:
        //   if (Get.currentRoute != AppRouter.loginBySms) {
        //     Get.offAllNamed(AppRouter.loginBySms);
        //   }
        break;
      default:
    }
  }

  static String getErrorMsg(DioException error) {
    String msg = '';

    switch (error.type) {
      case DioExceptionType.connectionError:
        msg = '连接错误';
        break;
      case DioExceptionType.connectionTimeout:
        msg = '连接超时';
        break;
      case DioExceptionType.sendTimeout:
        msg = '请求超时';
        break;
      case DioExceptionType.receiveTimeout:
        msg = '响应超时';
        break;
      case DioExceptionType.cancel:
        msg = '取消请求';
        break;
      case DioExceptionType.badResponse:
        final errCode = error.response?.statusCode;
        switch (errCode) {
          case 400:
            msg = '取消语法请求';
            break;
          case 401:
            msg = '没有权限';
            break;
          case 403:
            msg = '服务器拒绝执行';
            break;
          case 405:
            msg = '请求方法被禁止';
            break;
          case 500:
            msg = '服务器内部错误';
            break;
          case 502:
            msg = '无效请求';
            break;
          case 503:
            msg = '服务器异常';
            break;
          case 505:
            msg = '不支持HTTP协议请求';
            break;
          default:
            msg = '未知错误: $errCode';
        }
        break;
      case DioExceptionType.badCertificate:
        msg = '错误证书';
        break;
      case DioExceptionType.unknown:
        msg = '未知错误';
        break;
      default:
        msg = '未知错误';
    }

    return msg;
  }

  static Future<bool?> filePresignPut({
    required String url,
    required dynamic data,
    required int length,
    required String contentType,
  }) async {
    try {
      final res = await Dio().put(
        url,
        data: data,
        options: Options(
          headers: {
            'Content-Length': length,
            'Content-Type': contentType,
          },
        ),
      );
      if (res.statusCode != 200) {
        return false;
      }

      return true;
    } on DioException {
      rethrow;
    } catch (e) {
      return null;
    }
  }

  /// 退出登录
  static Future<ResponseModel<ConnectLogoutResModel?>?> logout() async {
    return post(
      '/connect/logout',
      {},
      (map) => ConnectLogoutResModel.fromMap(map),
    );
  }

  /// 获取用户信息
  static Future<ResponseModel<UserProfileResModel?>?> profileUser({
    required String userId,
  }) async {
    return post(
      '/user/profile',
      {
        'user_id': userId,
      },
      (map) => UserProfileResModel.fromMap(map),
    );
  }

  /// 发送聊天消息
  static Future<ResponseModel<MessageSendResModel?>?> sendMessage({
    required String userId,
    required int type,
    required int timestamp,
    String? text,
    String? image,
    String? audio,
    String? video,
    String? custom,
  }) async {
    return post(
      '/message/send',
      {
        'receiver_id': userId,
        'type': type,
        'timestamp': timestamp,
        'text': text,
        'image': image,
        'audio': audio,
        'video': video,
        'custom': custom,
      },
      (map) => MessageSendResModel.fromMap(map),
    );
  }

  /// 获取历史消息
  static Future<ResponseModel<MessagePullResModel?>?> pullMessage({
    required String userId,
    required int sequence,
  }) async {
    return post(
      '/message/pull',
      {
        'user_id': userId,
        'sequence': sequence,
      },
      (map) => MessagePullResModel.fromMap(map),
    );
  }

  /// 已读历史消息
  static Future<ResponseModel<MessageMarkResModel?>?> markMessage({
    required String userId,
    required int sequence,
  }) async {
    return post(
      '/message/mark',
      {
        'user_id': userId,
        'sequence': sequence,
      },
      (map) => MessageMarkResModel.fromMap(map),
    );
  }

  /// 获取未读数量
  static Future<ResponseModel<MessageUnreadResModel?>?> unreadMessage() async {
    return post(
      '/message/unread',
      {},
      (map) => MessageUnreadResModel.fromMap(map),
    );
  }

  /// 获取会话列表
  static Future<ResponseModel<ConversationPullResModel?>?>
      pullConversation() async {
    return post(
      '/conv/pull',
      {},
      (map) => ConversationPullResModel.fromMap(map),
    );
  }

  /// 删除某个会话
  static Future<ResponseModel<ConversationDeleteResModel?>?>
      deleteConversation({
    required String userId,
  }) async {
    return post(
      '/conv/delete',
      {
        'user_id': userId,
      },
      (map) => ConversationDeleteResModel.fromMap(map),
    );
  }

  /// 获取会话信息
  static Future<ResponseModel<ConversationDetailResModel?>?>
      detailConversation({
    required String userId,
  }) async {
    return post(
      '/conv/detail',
      {
        'user_id': userId,
      },
      (map) => ConversationDetailResModel.fromMap(map),
    );
  }
}
