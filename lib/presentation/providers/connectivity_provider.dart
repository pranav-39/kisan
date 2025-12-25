import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/utils/connectivity_helper.dart';

class ConnectivityProvider extends ChangeNotifier {
  final ConnectivityHelper _connectivityHelper = ConnectivityHelper();
  
  ConnectionStatus _status = ConnectionStatus.online;
  StreamSubscription<ConnectionStatus>? _subscription;
  
  ConnectionStatus get status => _status;
  bool get isOnline => _status == ConnectionStatus.online;
  bool get isOffline => _status == ConnectionStatus.offline;
  
  ConnectivityProvider() {
    _init();
  }
  
  Future<void> _init() async {
    await _connectivityHelper.init();
    _status = _connectivityHelper.currentStatus;
    
    _subscription = _connectivityHelper.connectionStatusStream.listen((status) {
      if (_status != status) {
        _status = status;
        notifyListeners();
      }
    });
    
    notifyListeners();
  }

  Future<bool> checkConnection() async {
    return _connectivityHelper.checkConnection();
  }
  
  @override
  void dispose() {
    _subscription?.cancel();
    _connectivityHelper.dispose();
    super.dispose();
  }
}
