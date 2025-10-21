// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'SmartBLESensor';

  @override
  String get homeTabDevice => 'Devices';

  @override
  String get homeTabMonitoring => 'Monitoring';

  @override
  String get homeTabRecords => 'Records';

  @override
  String get deviceManagementTitle => 'Device Management';

  @override
  String get deviceManagementCardTitle => 'Connected Device';

  @override
  String get deviceStatusConnected => 'Connected';

  @override
  String get deviceStatusDisconnected => 'Disconnected';

  @override
  String get deviceUnknownName => 'Unknown Device';

  @override
  String get deviceNonePlaceholder => 'No device connected';

  @override
  String get deviceDisconnectButton => 'Disconnect';

  @override
  String get deviceConnectButton => 'Connect Device';

  @override
  String get deviceInfoTitle => 'Device Info';

  @override
  String get deviceInfoNameLabel => 'Device name:';

  @override
  String get deviceInfoMacLabel => 'MAC address:';

  @override
  String get deviceInfoRssiLabel => 'Signal strength:';

  @override
  String get languageMenuTitle => 'Choose language';

  @override
  String get languageChinese => '简体中文';

  @override
  String get languageEnglish => 'English';

  @override
  String get commonSave => 'Save';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get commonApply => 'Apply';

  @override
  String get commonClose => 'Close';

  @override
  String get commonCopy => 'Copy';

  @override
  String get commonAdd => 'Add';

  @override
  String get commonEdit => 'Edit';

  @override
  String get monitoringTitle => 'Live Monitoring';

  @override
  String get monitoringConnectRequired => 'Please connect a device first';

  @override
  String get monitoringNoSavedConfigs => 'No saved characteristic presets';

  @override
  String get monitoringSelectConfigDialogTitle => 'Choose Characteristics';

  @override
  String get monitoringCreateConfigTitle => 'Add Characteristic Preset';

  @override
  String get monitoringEditConfigTitle => 'Edit Characteristic Preset';

  @override
  String get monitoringConfigCreateSuccess => 'Characteristic preset added';

  @override
  String get monitoringConfigUpdateSuccess => 'Preset updated';

  @override
  String get monitoringConfigDeleteSuccess => 'Preset deleted';

  @override
  String get monitoringConfigSaveFailed => 'Failed to save preset';

  @override
  String get monitoringConfigDeleteFailed => 'Failed to delete preset';

  @override
  String get uuidConfigNameLabel => 'Name';

  @override
  String get uuidConfigNameHint => 'e.g. Temperature Sensor';

  @override
  String get uuidConfigNameRequired => 'Enter a name';

  @override
  String get uuidConfigServiceHint =>
      'Optional, format: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx';

  @override
  String get uuidConfigServiceInvalid => 'Enter a valid Service UUID';

  @override
  String get uuidConfigCharacteristicLabel => 'Characteristic UUID';

  @override
  String get uuidConfigCharacteristicHint =>
      'Format: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx';

  @override
  String get uuidConfigCharacteristicRequired =>
      'Enter the characteristic UUID';

  @override
  String get uuidConfigCharacteristicInvalid =>
      'Enter a valid characteristic UUID';

  @override
  String get uuidConfigUnitLabel => 'Unit';

  @override
  String get uuidConfigUnitHint => 'e.g. ℃, %RH, ppm';

  @override
  String get uuidConfigDescriptionLabel => 'Notes';

  @override
  String get uuidConfigDescriptionHint =>
      'Optional, describe how this characteristic is used';

  @override
  String get monitoringConfigNotProvided =>
      'Preset does not include a valid characteristic UUID';

  @override
  String get monitoringDialogCreateButton => 'Add Preset';

  @override
  String get monitoringStatusTitle => 'Connection Status';

  @override
  String get monitoringStatusNoSelection => 'No characteristics selected';

  @override
  String monitoringStatusSelectionCount(int count) {
    return '$count characteristics selected';
  }

  @override
  String monitoringStatusActive(int activeCount, int totalCount) {
    return 'Active ($activeCount/$totalCount)';
  }

  @override
  String get monitoringStatusIdle => 'Inactive';

  @override
  String get monitoringButtonStart => 'Start Monitoring';

  @override
  String get monitoringButtonStop => 'Stop Monitoring';

  @override
  String get monitoringButtonClear => 'Clear Data';

  @override
  String get monitoringSnackStartSuccess => 'Monitoring started';

  @override
  String get monitoringSnackStartFailure => 'Unable to start monitoring';

  @override
  String get monitoringSnackStopSuccess => 'Monitoring stopped';

  @override
  String get monitoringSnackStopFailure => 'Unable to stop monitoring';

  @override
  String get monitoringSnackStoppedForUpdate =>
      'Monitoring stopped, please start again';

  @override
  String get monitoringSnackSelectConfig => 'Select characteristics first';

  @override
  String get monitoringSnackNoActive => 'No active characteristics';

  @override
  String get monitoringSnackClearSuccess => 'Selected data cleared';

  @override
  String get monitoringSnackCannotEnable => 'Unable to enable notifications';

  @override
  String get monitoringCurrentDataTitle => 'Current Data';

  @override
  String get monitoringChipActive => 'Active';

  @override
  String get monitoringChipInactive => 'Inactive';

  @override
  String monitoringLastUpdated(String time) {
    return 'Updated at: $time';
  }

  @override
  String get monitoringNoSensorValues => 'No sensor readings';

  @override
  String get monitoringEmptyCurrentTitle => 'Live Data';

  @override
  String get monitoringEmptyCurrentMessage => 'No characteristics selected';

  @override
  String get monitoringChartTitle => 'Live Trends';

  @override
  String get monitoringChartEmptyMessage => 'No history available yet';

  @override
  String monitoringTooltip(String name, String value, String time) {
    return '$name\\nValue: $value\\nTime: $time';
  }

  @override
  String monitoringServiceLabel(String uuid) {
    return 'Service: $uuid';
  }

  @override
  String monitoringUnitLabel(String unit) {
    return 'Unit: $unit';
  }

  @override
  String monitoringCharacteristicLabel(String uuid) {
    return 'Characteristic: $uuid';
  }

  @override
  String get dialogConfirmDeleteTitle => 'Confirm Deletion';

  @override
  String monitoringConfirmDeleteConfig(String name) {
    return 'Delete preset \"$name\"?';
  }

  @override
  String get recordsTabTitle => 'Data Records';

  @override
  String get recordsExportCsvTooltip => 'Export CSV';

  @override
  String get recordsStatusTitle => 'Recording Status';

  @override
  String get recordsStatusRecording => 'Recording';

  @override
  String get recordsStatusStopped => 'Stopped';

  @override
  String get recordsMetricTotalRecords => 'Total records';

  @override
  String get recordsMetricFeatureCount => 'Tracked characteristics';

  @override
  String get recordsMetricLastTime => 'Last record time';

  @override
  String get recordsCurrentFeaturesTitle => 'Current tracked characteristics';

  @override
  String get recordsEmptyMessage =>
      'No records yet\nTap the play button in the top right to start recording';

  @override
  String get recordsNoSensorValues => 'No sensor values';

  @override
  String get recordsSnackbarSelectFeatures =>
      'Select the characteristics to record first';

  @override
  String get recordsSnackbarRecordingStarted => 'Recording started';

  @override
  String get recordsSnackbarRecordingStopped => 'Recording stopped';

  @override
  String recordsSnackbarRecordingError(String error) {
    return 'Error while recording data: $error';
  }

  @override
  String get recordsSnackbarNoData => 'No data available to export';

  @override
  String get recordsExportDialogTitle => 'Export data';

  @override
  String recordsExportRecordCount(int count) {
    return 'Export $count records';
  }

  @override
  String recordsExportFeatureCount(int count) {
    return '$count characteristics recorded';
  }

  @override
  String get recordsExportChooseFormat => 'Choose an export option:';

  @override
  String get recordsExportSaveFile => 'Save to file';

  @override
  String get recordsExportPreview => 'Preview/Copy';

  @override
  String get recordsExporting => 'Exporting...';

  @override
  String get recordsExportSuccessTitle => 'Export complete';

  @override
  String get recordsExportSuccessPathLabel => 'File saved to:';

  @override
  String get recordsExportSuccessSizeLabel => 'File size:';

  @override
  String get recordsExportSuccessRecordsLabel => 'Record count:';

  @override
  String get recordsExportSuccessFeaturesLabel => 'Characteristic count:';

  @override
  String recordsExportFailed(String error) {
    return 'Export failed: $error';
  }

  @override
  String get recordsCsvPreviewTitle => 'CSV Preview';

  @override
  String get recordsCsvCopied => 'CSV data copied to clipboard';

  @override
  String get recordsCsvHeader => 'Index,Time';

  @override
  String get recordsConfirmDeleteAllMessage =>
      'Delete all recorded data? This action cannot be undone.';
}
