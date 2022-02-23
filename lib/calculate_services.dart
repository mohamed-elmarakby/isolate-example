import 'dart:developer';
import 'dart:isolate';

import 'package:flutter/foundation.dart';

abstract class CalculationInterface {
  Future<int> calculate();
}

class NoIsolateCalculate implements CalculationInterface {
  final int limit;
  NoIsolateCalculate({required this.limit});
  @override
  Future<int> calculate() async {
    int _sum = 0;
    for (var i = 0; i < limit; i++) {
      _sum += i;
    }
    return _sum;
  }
}

class IsolateCalculateWithCompute implements CalculationInterface {
  final int limit;
  IsolateCalculateWithCompute({required this.limit});
  @override
  Future<int> calculate() async {
    int _sum = 0;
    _sum = await compute<int, int>(getCalculation, limit);
    log('from IsolateCalculateWithCompute: $_sum');
    return _sum;
  }
}

class IsolateCalculateWithPort implements CalculationInterface {
  final int limit;
  IsolateCalculateWithPort({required this.limit});
  @override
  Future<int> calculate() async {
    int _sum = 0;
    final recievePort = ReceivePort();
    final response = Response(
        limit: limit, receivePort: recievePort, sendPort: recievePort.sendPort);
    await Isolate.spawn(getCalculationWithPort, response.sendPort);
    response.receivePort.listen((message) {
      log('message from IsolateCalculateWithPort: $message');
      _sum = message;
    });
    log('xyz: ' + _sum.toString());
    return _sum;
  }
}

Future<int> getCalculation(int limit) async {
  int _sum = 0;
  for (var i = 0; i < limit; i++) {
    _sum += i;
  }
  return _sum;
}

getCalculationWithPort(SendPort sendPort) async {
  int sum = 0;
  for (var i = 0; i < 1000000000; i++) {
    sum += i;
  }
  log('$sum');
  sendPort.send(sum);
}

class Response {
  final int limit;
  final SendPort sendPort;
  final ReceivePort receivePort;
  Response(
      {required this.limit, required this.sendPort, required this.receivePort});
}
