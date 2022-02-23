import 'calculate_services.dart';
import 'constants.dart';

abstract class TestingInterface {
  TestingInterface();
  calculate();
}

mixin HeavyComputation {
  int _sum = 0;
  late CalculationInterface calculationInterface;
  Future<int> heavyComputation(
      {required int limit, required Status status}) async {
    switch (status) {
      case Status.isolate:
        const withPorts = true;
        calculationInterface = withPorts
            ? IsolateCalculateWithCompute(limit: limit)
            : IsolateCalculateWithPort(limit: limit);
        _sum = await calculationInterface.calculate();
        break;
      case Status.noIsolate:
        calculationInterface = NoIsolateCalculate(limit: limit);
        _sum = await calculationInterface.calculate();
        break;
      default:
    }
    return _sum;
  }
}

class NoIsolate with HeavyComputation implements TestingInterface {
  int limit;
  Status status;
  NoIsolate({required this.limit, required this.status}) : super();
  @override
  Future<int> calculate() async {
    return await heavyComputation(limit: limit, status: status);
  }
}

class WithIsolate with HeavyComputation implements TestingInterface {
  int limit;
  Status status;
  WithIsolate({
    required this.limit,
    required this.status,
  }) : super();
  @override
  Future<int> calculate() async {
    return await heavyComputation(limit: limit, status: status);
  }
}
