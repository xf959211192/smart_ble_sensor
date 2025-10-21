/// 蓝牙服务异常码定义
enum BluetoothErrorCode {
  scanFailed,
  connectionFailed,
  disconnectionFailed,
  deviceNotConnected,
  writeCharacteristicNotFound,
}

/// 蓝牙服务内部抛出的统一异常类型
class BluetoothServiceException implements Exception {
  BluetoothServiceException(this.code, {this.cause});

  final BluetoothErrorCode code;
  final Object? cause;

  @override
  String toString() => 'BluetoothServiceException(code: $code, cause: $cause)';
}
