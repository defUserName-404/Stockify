import '../model/asset_status.dart';
import '../model/device_type.dart';

class ItemInputValidator {
  ItemInputValidator._();

  static String? validateAssetNo(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter asset number';
    }
    return null;
  }

  static String? validateModelNo(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter model number';
    }
    return null;
  }

  static String? validateSerialNo(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter serial number';
    }
    return null;
  }

  static String? validateWarrantyDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select warranty date';
    }
    return null;
  }

  static String? validateDeviceType(DeviceType? value) {
    if (value == null) {
      return 'Please select device type';
    }
    return null;
  }

  static String? validateAssetStatus(AssetStatus? value) {
    if (value == null) {
      return 'Please select asset status';
    }
    return null;
  }
}
