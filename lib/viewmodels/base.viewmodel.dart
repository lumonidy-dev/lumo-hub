import 'package:flutter/foundation.dart';

enum ViewState {
  idle,
  busy,
  error,
  success,
}

class BaseViewModel extends ChangeNotifier {
  ViewState _state = ViewState.idle;
  String? _errorMessage;

  // Getter para obtener el estado actual
  ViewState get state => _state;

  // Getter para obtener el mensaje de error
  String? get errorMessage => _errorMessage;

  // Setter para actualizar el estado
  void setState(ViewState viewState) {
    if (_state != viewState) {
      _state = viewState;
      notifyListeners();
    }
  }

  // Método para manejar errores
  void handleError(String errorMessage) {
    _errorMessage = errorMessage;
    setState(ViewState.error);
  }

  // Método para limpiar el mensaje de error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
