import 'package:rxdart/rxdart.dart';

extension StreamExtension<T> on Stream<T> {
  ValueConnectableStream<T> asValueConnectableStream({bool sync = false}) {
    if (this is ValueConnectableStream<T>) {
      return this as ValueConnectableStream<T>;
    }
    return ValueConnectableStream(this, sync: sync)..connect();
  }
}
