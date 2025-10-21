import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('zh'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In zh, this message translates to:
  /// **'SmartBLESensor'**
  String get appTitle;

  /// 底部导航中的设备标签
  ///
  /// In zh, this message translates to:
  /// **'设备'**
  String get homeTabDevice;

  /// 底部导航中的监控标签
  ///
  /// In zh, this message translates to:
  /// **'监控'**
  String get homeTabMonitoring;

  /// 底部导航中的记录标签
  ///
  /// In zh, this message translates to:
  /// **'记录'**
  String get homeTabRecords;

  /// 设备管理页标题
  ///
  /// In zh, this message translates to:
  /// **'设备管理'**
  String get deviceManagementTitle;

  /// 设备管理页中当前设备卡片标题
  ///
  /// In zh, this message translates to:
  /// **'当前连接设备'**
  String get deviceManagementCardTitle;

  /// 设备状态：已连接
  ///
  /// In zh, this message translates to:
  /// **'已连接'**
  String get deviceStatusConnected;

  /// 设备状态：未连接
  ///
  /// In zh, this message translates to:
  /// **'未连接'**
  String get deviceStatusDisconnected;

  /// 未能识别设备名称时的占位文案
  ///
  /// In zh, this message translates to:
  /// **'未知设备'**
  String get deviceUnknownName;

  /// 尚未连接设备时的占位提示
  ///
  /// In zh, this message translates to:
  /// **'暂无连接设备'**
  String get deviceNonePlaceholder;

  /// 断开连接按钮文本
  ///
  /// In zh, this message translates to:
  /// **'断开连接'**
  String get deviceDisconnectButton;

  /// 连接设备按钮文本
  ///
  /// In zh, this message translates to:
  /// **'连接设备'**
  String get deviceConnectButton;

  /// 设备信息卡片标题
  ///
  /// In zh, this message translates to:
  /// **'设备信息'**
  String get deviceInfoTitle;

  /// 设备信息卡片中 RSSI 标签
  ///
  /// In zh, this message translates to:
  /// **'信号强度:'**
  String get deviceInfoRssiLabel;

  /// 语言切换菜单标题
  ///
  /// In zh, this message translates to:
  /// **'选择语言'**
  String get languageMenuTitle;

  /// 菜单项：简体中文
  ///
  /// In zh, this message translates to:
  /// **'简体中文'**
  String get languageChinese;

  /// 菜单项：英语
  ///
  /// In zh, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// 通用操作：保存
  ///
  /// In zh, this message translates to:
  /// **'保存'**
  String get commonSave;

  /// 通用操作：删除
  ///
  /// In zh, this message translates to:
  /// **'删除'**
  String get commonDelete;

  /// 通用操作：取消
  ///
  /// In zh, this message translates to:
  /// **'取消'**
  String get commonCancel;

  /// 通用操作：确定
  ///
  /// In zh, this message translates to:
  /// **'确定'**
  String get commonConfirm;

  /// 通用操作：应用
  ///
  /// In zh, this message translates to:
  /// **'应用'**
  String get commonApply;

  /// 通用操作：关闭
  ///
  /// In zh, this message translates to:
  /// **'关闭'**
  String get commonClose;

  /// 通用操作：复制
  ///
  /// In zh, this message translates to:
  /// **'复制'**
  String get commonCopy;

  /// 通用操作：新增
  ///
  /// In zh, this message translates to:
  /// **'新增'**
  String get commonAdd;

  /// 通用操作：编辑
  ///
  /// In zh, this message translates to:
  /// **'编辑'**
  String get commonEdit;

  /// 数据监控页标题
  ///
  /// In zh, this message translates to:
  /// **'实时监控'**
  String get monitoringTitle;

  /// 提示用户需要先连接设备
  ///
  /// In zh, this message translates to:
  /// **'请先连接设备'**
  String get monitoringConnectRequired;

  /// 提示尚无可用的特征配置
  ///
  /// In zh, this message translates to:
  /// **'暂无已保存的特征配置'**
  String get monitoringNoSavedConfigs;

  /// 选择特征配置对话框标题
  ///
  /// In zh, this message translates to:
  /// **'选择特征配置'**
  String get monitoringSelectConfigDialogTitle;

  /// 创建特征配置对话框标题
  ///
  /// In zh, this message translates to:
  /// **'新增特征配置'**
  String get monitoringCreateConfigTitle;

  /// 编辑特征配置对话框标题
  ///
  /// In zh, this message translates to:
  /// **'编辑特征配置'**
  String get monitoringEditConfigTitle;

  /// 新增特征配置成功提示
  ///
  /// In zh, this message translates to:
  /// **'已添加新的特征配置'**
  String get monitoringConfigCreateSuccess;

  /// 更新特征配置成功提示
  ///
  /// In zh, this message translates to:
  /// **'配置已更新'**
  String get monitoringConfigUpdateSuccess;

  /// 删除特征配置成功提示
  ///
  /// In zh, this message translates to:
  /// **'配置已删除'**
  String get monitoringConfigDeleteSuccess;

  /// 保存特征配置失败提示
  ///
  /// In zh, this message translates to:
  /// **'保存配置失败'**
  String get monitoringConfigSaveFailed;

  /// 删除特征配置失败提示
  ///
  /// In zh, this message translates to:
  /// **'删除配置失败'**
  String get monitoringConfigDeleteFailed;

  /// 特征配置表单-名称标签
  ///
  /// In zh, this message translates to:
  /// **'名称'**
  String get uuidConfigNameLabel;

  /// 特征配置表单-名称示例
  ///
  /// In zh, this message translates to:
  /// **'例如：温度传感器'**
  String get uuidConfigNameHint;

  /// 特征配置表单-名称校验提示
  ///
  /// In zh, this message translates to:
  /// **'请输入名称'**
  String get uuidConfigNameRequired;

  /// 特征配置表单-Service UUID 提示
  ///
  /// In zh, this message translates to:
  /// **'可选，格式：xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'**
  String get uuidConfigServiceHint;

  /// 特征配置表单-Service UUID 校验提示
  ///
  /// In zh, this message translates to:
  /// **'请输入有效的 Service UUID'**
  String get uuidConfigServiceInvalid;

  /// 特征配置表单-特征 UUID 标签
  ///
  /// In zh, this message translates to:
  /// **'Characteristic UUID'**
  String get uuidConfigCharacteristicLabel;

  /// 特征配置表单-特征 UUID 提示
  ///
  /// In zh, this message translates to:
  /// **'格式：xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'**
  String get uuidConfigCharacteristicHint;

  /// 特征配置表单-特征 UUID 必填提示
  ///
  /// In zh, this message translates to:
  /// **'请输入特征 UUID'**
  String get uuidConfigCharacteristicRequired;

  /// 特征配置表单-特征 UUID 校验提示
  ///
  /// In zh, this message translates to:
  /// **'请输入有效的特征 UUID'**
  String get uuidConfigCharacteristicInvalid;

  /// 特征配置表单-单位标签
  ///
  /// In zh, this message translates to:
  /// **'数据单位'**
  String get uuidConfigUnitLabel;

  /// 特征配置表单-单位提示
  ///
  /// In zh, this message translates to:
  /// **'例如 ℃、%RH、ppm'**
  String get uuidConfigUnitHint;

  /// 特征配置表单-备注标签
  ///
  /// In zh, this message translates to:
  /// **'备注'**
  String get uuidConfigDescriptionLabel;

  /// 特征配置表单-备注提示
  ///
  /// In zh, this message translates to:
  /// **'可选，描述该特征用途'**
  String get uuidConfigDescriptionHint;

  /// 特征配置缺少有效特征 UUID 提示
  ///
  /// In zh, this message translates to:
  /// **'配置未提供有效的特征 UUID'**
  String get monitoringConfigNotProvided;

  /// 选择特征配置对话框-新增按钮文本
  ///
  /// In zh, this message translates to:
  /// **'新增配置'**
  String get monitoringDialogCreateButton;

  /// 监控状态卡片标题
  ///
  /// In zh, this message translates to:
  /// **'连接状态'**
  String get monitoringStatusTitle;

  /// 监控状态卡片-无选择提示
  ///
  /// In zh, this message translates to:
  /// **'未选择特征'**
  String get monitoringStatusNoSelection;

  /// 监控状态卡片-选择数量提示
  ///
  /// In zh, this message translates to:
  /// **'已选 {count} 个特征'**
  String monitoringStatusSelectionCount(int count);

  /// 监控状态卡片-监听中提示
  ///
  /// In zh, this message translates to:
  /// **'监听中 ({activeCount}/{totalCount})'**
  String monitoringStatusActive(int activeCount, int totalCount);

  /// 监控状态卡片-未监听提示
  ///
  /// In zh, this message translates to:
  /// **'未监听'**
  String get monitoringStatusIdle;

  /// 开始监听按钮
  ///
  /// In zh, this message translates to:
  /// **'开始监听'**
  String get monitoringButtonStart;

  /// 停止监听按钮
  ///
  /// In zh, this message translates to:
  /// **'停止监听'**
  String get monitoringButtonStop;

  /// 清空数据按钮
  ///
  /// In zh, this message translates to:
  /// **'清空数据'**
  String get monitoringButtonClear;

  /// 开启监听成功提示
  ///
  /// In zh, this message translates to:
  /// **'监听已启动'**
  String get monitoringSnackStartSuccess;

  /// 开启监听失败提示
  ///
  /// In zh, this message translates to:
  /// **'未能成功开启监听'**
  String get monitoringSnackStartFailure;

  /// 停止监听成功提示
  ///
  /// In zh, this message translates to:
  /// **'监听已停止'**
  String get monitoringSnackStopSuccess;

  /// 停止监听失败提示
  ///
  /// In zh, this message translates to:
  /// **'未能停止监听'**
  String get monitoringSnackStopFailure;

  /// 重新选择配置后提示监听已停止
  ///
  /// In zh, this message translates to:
  /// **'监听已停止，请重新启动'**
  String get monitoringSnackStoppedForUpdate;

  /// 提示需要先选择特征配置
  ///
  /// In zh, this message translates to:
  /// **'请先选择特征配置'**
  String get monitoringSnackSelectConfig;

  /// 没有正在监听的特征提示
  ///
  /// In zh, this message translates to:
  /// **'没有正在监听的特征'**
  String get monitoringSnackNoActive;

  /// 清空监控数据成功提示
  ///
  /// In zh, this message translates to:
  /// **'已清除所选特征的数据'**
  String get monitoringSnackClearSuccess;

  /// 无法启用数据通知提示
  ///
  /// In zh, this message translates to:
  /// **'无法启用数据通知'**
  String get monitoringSnackCannotEnable;

  /// 当前数据卡片标题
  ///
  /// In zh, this message translates to:
  /// **'当前特征数据'**
  String get monitoringCurrentDataTitle;

  /// 特征卡片-正在监听标签
  ///
  /// In zh, this message translates to:
  /// **'监听中'**
  String get monitoringChipActive;

  /// 特征卡片-未监听标签
  ///
  /// In zh, this message translates to:
  /// **'未监听'**
  String get monitoringChipInactive;

  /// 特征卡片-最后更新时间标签
  ///
  /// In zh, this message translates to:
  /// **'更新时间：{time}'**
  String monitoringLastUpdated(String time);

  /// 特征卡片-无数据提示
  ///
  /// In zh, this message translates to:
  /// **'无传感器数值'**
  String get monitoringNoSensorValues;

  /// 无选择时当前数据卡片标题
  ///
  /// In zh, this message translates to:
  /// **'实时数据'**
  String get monitoringEmptyCurrentTitle;

  /// 无选择时当前数据卡片提示
  ///
  /// In zh, this message translates to:
  /// **'未选择特征'**
  String get monitoringEmptyCurrentMessage;

  /// 监控折线图标题
  ///
  /// In zh, this message translates to:
  /// **'实时折线图'**
  String get monitoringChartTitle;

  /// 监控折线图无数据提示
  ///
  /// In zh, this message translates to:
  /// **'暂无历史数据可显示'**
  String get monitoringChartEmptyMessage;

  /// 监控折线图悬浮提示
  ///
  /// In zh, this message translates to:
  /// **'{name}\n数值：{value}\n时间：{time}'**
  String monitoringTooltip(String name, String value, String time);

  /// 特征卡片 Service UUID 标签
  ///
  /// In zh, this message translates to:
  /// **'Service: {uuid}'**
  String monitoringServiceLabel(String uuid);

  /// 特征卡片单位标签
  ///
  /// In zh, this message translates to:
  /// **'单位：{unit}'**
  String monitoringUnitLabel(String unit);

  /// 特征卡片 Characteristic UUID 标签
  ///
  /// In zh, this message translates to:
  /// **'Characteristic: {uuid}'**
  String monitoringCharacteristicLabel(String uuid);

  /// 删除确认对话框标题
  ///
  /// In zh, this message translates to:
  /// **'确认删除'**
  String get dialogConfirmDeleteTitle;

  /// 删除特征配置确认内容
  ///
  /// In zh, this message translates to:
  /// **'确认要删除配置「{name}」吗？'**
  String monitoringConfirmDeleteConfig(String name);

  /// 记录页签标题
  ///
  /// In zh, this message translates to:
  /// **'数据记录'**
  String get recordsTabTitle;

  /// 记录页导出按钮提示
  ///
  /// In zh, this message translates to:
  /// **'导出CSV'**
  String get recordsExportCsvTooltip;

  /// 记录状态卡片标题
  ///
  /// In zh, this message translates to:
  /// **'记录状态'**
  String get recordsStatusTitle;

  /// 记录状态徽标：记录中
  ///
  /// In zh, this message translates to:
  /// **'记录中'**
  String get recordsStatusRecording;

  /// 记录状态徽标：已停止
  ///
  /// In zh, this message translates to:
  /// **'已停止'**
  String get recordsStatusStopped;

  /// 指标：总记录数
  ///
  /// In zh, this message translates to:
  /// **'总记录数'**
  String get recordsMetricTotalRecords;

  /// 指标：采集特征数量
  ///
  /// In zh, this message translates to:
  /// **'采集特征数'**
  String get recordsMetricFeatureCount;

  /// 指标：最后记录时间
  ///
  /// In zh, this message translates to:
  /// **'最后记录时间'**
  String get recordsMetricLastTime;

  /// 当前记录特征标题
  ///
  /// In zh, this message translates to:
  /// **'当前记录特征'**
  String get recordsCurrentFeaturesTitle;

  /// 记录列表为空时的提示
  ///
  /// In zh, this message translates to:
  /// **'暂无记录数据\n点击右上角播放按钮开始记录'**
  String get recordsEmptyMessage;

  /// 记录项无数据提示
  ///
  /// In zh, this message translates to:
  /// **'无传感器数值'**
  String get recordsNoSensorValues;

  /// 提示选择记录特征
  ///
  /// In zh, this message translates to:
  /// **'请先选择需要记录的特征'**
  String get recordsSnackbarSelectFeatures;

  /// 开始记录提示
  ///
  /// In zh, this message translates to:
  /// **'开始记录数据'**
  String get recordsSnackbarRecordingStarted;

  /// 停止记录提示
  ///
  /// In zh, this message translates to:
  /// **'已停止记录'**
  String get recordsSnackbarRecordingStopped;

  /// 记录失败提示
  ///
  /// In zh, this message translates to:
  /// **'记录数据时发生错误: {error}'**
  String recordsSnackbarRecordingError(String error);

  /// 无数据可导出提示
  ///
  /// In zh, this message translates to:
  /// **'无数据可导出'**
  String get recordsSnackbarNoData;

  /// 导出数据对话框标题
  ///
  /// In zh, this message translates to:
  /// **'导出数据'**
  String get recordsExportDialogTitle;

  /// 导出记录数量提示
  ///
  /// In zh, this message translates to:
  /// **'导出 {count} 条记录'**
  String recordsExportRecordCount(int count);

  /// 导出特征数量提示
  ///
  /// In zh, this message translates to:
  /// **'采集特征数 {count}'**
  String recordsExportFeatureCount(int count);

  /// 导出方式提示
  ///
  /// In zh, this message translates to:
  /// **'请选择导出方式：'**
  String get recordsExportChooseFormat;

  /// 导出保存到文件按钮
  ///
  /// In zh, this message translates to:
  /// **'保存到文件'**
  String get recordsExportSaveFile;

  /// 导出预览按钮
  ///
  /// In zh, this message translates to:
  /// **'预览/复制'**
  String get recordsExportPreview;

  /// 导出进行中提示
  ///
  /// In zh, this message translates to:
  /// **'正在导出...'**
  String get recordsExporting;

  /// 导出成功标题
  ///
  /// In zh, this message translates to:
  /// **'导出成功'**
  String get recordsExportSuccessTitle;

  /// 导出成功文件路径标签
  ///
  /// In zh, this message translates to:
  /// **'文件已保存到:'**
  String get recordsExportSuccessPathLabel;

  /// 导出成功文件大小标签
  ///
  /// In zh, this message translates to:
  /// **'文件大小:'**
  String get recordsExportSuccessSizeLabel;

  /// 导出成功记录数量标签
  ///
  /// In zh, this message translates to:
  /// **'记录条数:'**
  String get recordsExportSuccessRecordsLabel;

  /// 导出成功特征数量标签
  ///
  /// In zh, this message translates to:
  /// **'采集特征数:'**
  String get recordsExportSuccessFeaturesLabel;

  /// 导出失败提示
  ///
  /// In zh, this message translates to:
  /// **'导出失败: {error}'**
  String recordsExportFailed(String error);

  /// CSV预览标题
  ///
  /// In zh, this message translates to:
  /// **'CSV数据预览'**
  String get recordsCsvPreviewTitle;

  /// CSV复制成功提示
  ///
  /// In zh, this message translates to:
  /// **'CSV数据已复制到剪贴板'**
  String get recordsCsvCopied;

  /// CSV 文件表头
  ///
  /// In zh, this message translates to:
  /// **'序号,时间'**
  String get recordsCsvHeader;

  /// 清空记录确认消息
  ///
  /// In zh, this message translates to:
  /// **'确认要删除所有记录数据吗？此操作不可恢复'**
  String get recordsConfirmDeleteAllMessage;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
