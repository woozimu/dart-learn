import 'dart:async';
import 'dart:math';

class Server {
  /// [StreamController] simulating an ongoing websocket endpoint.
  StreamController<int>? _controller;

  /// [Timer] periodically adding data to the [_controller].
  Timer? _timer;

  /// Initializes this [Server].
  Future<void> init() async {
    final Random random = Random();

    while (true) {
      _controller = StreamController();
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        _controller?.add(timer.tick);
      });

      // Oops, a crash happened...
      await Future.delayed(
        Duration(milliseconds: (1000 + (5000 * random.nextDouble())).round()),
      );

      // Kill the [StreamController], simulating a network loss.
      _controller?.addError(DisconnectedException());
      _controller?.close();
      _controller = null;

      _timer?.cancel();
      _timer = null;

      // Waiting for server to recover...
      await Future.delayed(
        Duration(milliseconds: (1000 + (5000 * random.nextDouble())).round()),
      );
    }
  }

  /// Returns a [Stream] of data, if this [Server] is up and reachable, or
  /// throws [DisconnectedException] otherwise.
  Future<Stream<int>> connect() async {
    if (_controller != null) {
      return _controller!.stream;
    } else {
      throw DisconnectedException();
    }
  }
}

class DisconnectedException implements Exception {}

class Client {
  Future<void> connect(Server server) async {
    while (true) {
      try {
        final stream = await server.connect();
        await for (final data in stream) {
          print('Received data: $data');
        }
      } catch (e) {
        if (e is DisconnectedException) {
          print('Server disconnected. Reconnecting...');
          // Implement exponential backoff for reconnecting
          await Future.delayed(Duration(seconds: 2));
        } else {
          print('An error occurred: $e');
        }
      }
    }
  }
}

Future<void> main() async {
  Client()..connect(Server()..init());
}
