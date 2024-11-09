part of 'internet_cubit.dart';

@immutable
abstract class InternetState {}

class InternetLoading extends InternetState {}

class InternetConnected extends InternetState {
  final InternetConnection internetConnection;

  InternetConnected({
    required this.internetConnection,
  });
}

class InternetDisconnected extends InternetState {}
