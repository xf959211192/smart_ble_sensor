// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'SmartBLESensor';

  @override
  String get homeTabDevice => '设备';

  @override
  String get homeTabMonitoring => '监控';

  @override
  String get homeTabRecords => '记录';

  @override
  String get deviceManagementTitle => '设备管理';

  @override
  String get deviceManagementCardTitle => '当前连接设备';

  @override
  String get deviceStatusConnected => '已连接';

  @override
  String get deviceStatusDisconnected => '未连接';

  @override
  String get deviceUnknownName => '未知设备';

  @override
  String get deviceNonePlaceholder => '暂无连接设备';

  @override
  String get deviceDisconnectButton => '断开连接';

  @override
  String get deviceConnectButton => '连接设备';

  @override
  String get deviceInfoTitle => '设备信息';

  @override
  String get deviceInfoNameLabel => '设备名称:';

  @override
  String get deviceInfoMacLabel => 'MAC 地址:';

  @override
  String get deviceInfoRssiLabel => '信号强度:';

  @override
  String get languageMenuTitle => '选择语言';

  @override
  String get languageChinese => '简体中文';

  @override
  String get languageEnglish => 'English';

  @override
  String get commonSave => '保存';

  @override
  String get commonDelete => '删除';

  @override
  String get commonCancel => '取消';

  @override
  String get commonConfirm => '确定';

  @override
  String get commonApply => '应用';

  @override
  String get commonClose => '关闭';

  @override
  String get commonCopy => '复制';

  @override
  String get commonAdd => '新增';

  @override
  String get commonEdit => '编辑';

  @override
  String get monitoringTitle => '实时监控';

  @override
  String get monitoringConnectRequired => '请先连接设备';

  @override
  String get monitoringNoSavedConfigs => '暂无已保存的特征配置';

  @override
  String get monitoringSelectConfigDialogTitle => '选择特征配置';

  @override
  String get monitoringCreateConfigTitle => '新增特征配置';

  @override
  String get monitoringEditConfigTitle => '编辑特征配置';

  @override
  String get monitoringConfigCreateSuccess => '已添加新的特征配置';

  @override
  String get monitoringConfigUpdateSuccess => '配置已更新';

  @override
  String get monitoringConfigDeleteSuccess => '配置已删除';

  @override
  String get monitoringConfigSaveFailed => '保存配置失败';

  @override
  String get monitoringConfigDeleteFailed => '删除配置失败';

  @override
  String get uuidConfigNameLabel => '名称';

  @override
  String get uuidConfigNameHint => '例如：温度传感器';

  @override
  String get uuidConfigNameRequired => '请输入名称';

  @override
  String get uuidConfigServiceHint =>
      '可选，格式：xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx';

  @override
  String get uuidConfigServiceInvalid => '请输入有效的 Service UUID';

  @override
  String get uuidConfigCharacteristicLabel => 'Characteristic UUID';

  @override
  String get uuidConfigCharacteristicHint =>
      '格式：xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx';

  @override
  String get uuidConfigCharacteristicRequired => '请输入特征 UUID';

  @override
  String get uuidConfigCharacteristicInvalid => '请输入有效的特征 UUID';

  @override
  String get uuidConfigUnitLabel => '数据单位';

  @override
  String get uuidConfigUnitHint => '例如 ℃、%RH、ppm';

  @override
  String get uuidConfigDescriptionLabel => '备注';

  @override
  String get uuidConfigDescriptionHint => '可选，描述该特征用途';

  @override
  String get monitoringConfigNotProvided => '配置未提供有效的特征 UUID';

  @override
  String get monitoringDialogCreateButton => '新增配置';

  @override
  String get monitoringStatusTitle => '连接状态';

  @override
  String get monitoringStatusNoSelection => '未选择特征';

  @override
  String monitoringStatusSelectionCount(int count) {
    return '已选 $count 个特征';
  }

  @override
  String monitoringStatusActive(int activeCount, int totalCount) {
    return '监听中 ($activeCount/$totalCount)';
  }

  @override
  String get monitoringStatusIdle => '未监听';

  @override
  String get monitoringButtonStart => '开始监听';

  @override
  String get monitoringButtonStop => '停止监听';

  @override
  String get monitoringButtonClear => '清空数据';

  @override
  String get monitoringSnackStartSuccess => '监听已启动';

  @override
  String get monitoringSnackStartFailure => '未能成功开启监听';

  @override
  String get monitoringSnackStopSuccess => '监听已停止';

  @override
  String get monitoringSnackStopFailure => '未能停止监听';

  @override
  String get monitoringSnackStoppedForUpdate => '监听已停止，请重新启动';

  @override
  String get monitoringSnackSelectConfig => '请先选择特征配置';

  @override
  String get monitoringSnackNoActive => '没有正在监听的特征';

  @override
  String get monitoringSnackClearSuccess => '已清除所选特征的数据';

  @override
  String get monitoringSnackCannotEnable => '无法启用数据通知';

  @override
  String get monitoringCurrentDataTitle => '当前特征数据';

  @override
  String get monitoringChipActive => '监听中';

  @override
  String get monitoringChipInactive => '未监听';

  @override
  String monitoringLastUpdated(String time) {
    return '更新时间：$time';
  }

  @override
  String get monitoringNoSensorValues => '无传感器数值';

  @override
  String get monitoringEmptyCurrentTitle => '实时数据';

  @override
  String get monitoringEmptyCurrentMessage => '未选择特征';

  @override
  String get monitoringChartTitle => '实时折线图';

  @override
  String get monitoringChartEmptyMessage => '暂无历史数据可显示';

  @override
  String monitoringTooltip(String name, String value, String time) {
    return '$name\n数值：$value\n时间：$time';
  }

  @override
  String monitoringServiceLabel(String uuid) {
    return 'Service: $uuid';
  }

  @override
  String monitoringUnitLabel(String unit) {
    return '单位：$unit';
  }

  @override
  String monitoringCharacteristicLabel(String uuid) {
    return 'Characteristic: $uuid';
  }

  @override
  String get dialogConfirmDeleteTitle => '确认删除';

  @override
  String monitoringConfirmDeleteConfig(String name) {
    return '确认要删除配置「$name」吗？';
  }

  @override
  String get recordsTabTitle => '数据记录';

  @override
  String get recordsExportCsvTooltip => '导出CSV';

  @override
  String get recordsStatusTitle => '记录状态';

  @override
  String get recordsStatusRecording => '记录中';

  @override
  String get recordsStatusStopped => '已停止';

  @override
  String get recordsMetricTotalRecords => '总记录数';

  @override
  String get recordsMetricFeatureCount => '采集特征数';

  @override
  String get recordsMetricLastTime => '最后记录时间';

  @override
  String get recordsCurrentFeaturesTitle => '当前记录特征';

  @override
  String get recordsEmptyMessage => '暂无记录数据\n点击右上角播放按钮开始记录';

  @override
  String get recordsNoSensorValues => '无传感器数值';

  @override
  String get recordsSnackbarSelectFeatures => '请先选择需要记录的特征';

  @override
  String get recordsSnackbarRecordingStarted => '开始记录数据';

  @override
  String get recordsSnackbarRecordingStopped => '已停止记录';

  @override
  String recordsSnackbarRecordingError(String error) {
    return '记录数据时发生错误: $error';
  }

  @override
  String get recordsSnackbarNoData => '无数据可导出';

  @override
  String get recordsExportDialogTitle => '导出数据';

  @override
  String recordsExportRecordCount(int count) {
    return '导出 $count 条记录';
  }

  @override
  String recordsExportFeatureCount(int count) {
    return '采集特征数 $count';
  }

  @override
  String get recordsExportChooseFormat => '请选择导出方式：';

  @override
  String get recordsExportSaveFile => '保存到文件';

  @override
  String get recordsExportPreview => '预览/复制';

  @override
  String get recordsExporting => '正在导出...';

  @override
  String get recordsExportSuccessTitle => '导出成功';

  @override
  String get recordsExportSuccessPathLabel => '文件已保存到:';

  @override
  String get recordsExportSuccessSizeLabel => '文件大小:';

  @override
  String get recordsExportSuccessRecordsLabel => '记录条数:';

  @override
  String get recordsExportSuccessFeaturesLabel => '采集特征数:';

  @override
  String recordsExportFailed(String error) {
    return '导出失败: $error';
  }

  @override
  String get recordsCsvPreviewTitle => 'CSV数据预览';

  @override
  String get recordsCsvCopied => 'CSV数据已复制到剪贴板';

  @override
  String get recordsCsvHeader => '序号,时间';

  @override
  String get recordsConfirmDeleteAllMessage => '确认要删除所有记录数据吗？此操作不可恢复';
}
