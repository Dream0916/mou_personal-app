import 'dart:async';

import 'package:dio/dio.dart';
import 'package:mou_app/core/services/wifi_service.dart';

import 'resource.dart';

class NetworkBoundResource<RequestType, ResultType> {
  Completer<Resource<ResultType>> _result = Completer<Resource<ResultType>>();

  Future<Resource<ResultType>> getAsObservable() => _result.future;

  RequestType processResponse(Resource<RequestType> response) => response.data!;

  final Future<Response> Function() createCall;

  final bool shouldFetch;

  final Future<ResultType>? Function()? loadFromDb;

  final Future<void>? Function(ResultType result)? saveCallResult;

  final ResultType Function(dynamic data) parsedData;

  NetworkBoundResource({
    required this.createCall,
    required this.parsedData,
    this.saveCallResult,
    this.loadFromDb,
    this.shouldFetch = true,
  }) {
    _fetchData();
  }

  void _fetchData() async {
    bool hasInternet = await WifiService.isConnectivity();
    if (shouldFetch && hasInternet) {
      try {
        Response response = await createCall(); // call request network
        ResultType result = parsedData(response.data); // convert HapMap
        if (result != null) {
          await saveCallResult?.call(result); // cache database
        }
        _result.complete(Resource.withHasData(result)); // request success
      } on DioException catch (e) {
        ResultType? result = await loadFromDb?.call(); // call request from database
        _result.complete(Resource.withError(e, data: result));
      }
    } else {
      await _fetchFromDB(); // call request database
    }
  }

  _fetchFromDB() async {
    ResultType? result = await loadFromDb?.call(); // call request from database
    if (result != null) {
      _result.complete(Resource.withHasData(result));
    } else {
      _result.complete(Resource.withNotData());
    }
  }
}
