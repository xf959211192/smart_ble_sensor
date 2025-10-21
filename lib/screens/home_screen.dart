import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../l10n/l10n.dart';
import '../providers/providers.dart';
import '../models/models.dart';
import '../services/services.dart';
import 'device_scan_screen.dart';

/// 主屏幕
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const _DeviceManagementTab(),
    const _DataMonitoringTab(),
    const _RecordsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.bluetooth),
            label: l10n.homeTabDevice,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.analytics),
            label: l10n.homeTabMonitoring,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.history),
            label: l10n.homeTabRecords,
          ),
        ],
      ),
    );
  }
}

/// 设备管理标签页
class _DeviceManagementTab extends StatelessWidget {
  const _DeviceManagementTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.deviceManagementTitle),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          Consumer<LocaleProvider>(
            builder: (context, localeProvider, _) {
              return PopupMenuButton<Locale>(
                icon: const Icon(Icons.language),
                tooltip: context.l10n.languageMenuTitle,
                onSelected: localeProvider.switchLocale,
                itemBuilder: (context) => [
                  PopupMenuItem<Locale>(
                    value: const Locale('zh'),
                    child: Text(context.l10n.languageChinese),
                  ),
                  PopupMenuItem<Locale>(
                    value: const Locale('en'),
                    child: Text(context.l10n.languageEnglish),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildConnectedDeviceCard(context),
            const SizedBox(height: 16),
            _buildDeviceInfoCard(),
          ],
        ),
      ),
    );
  }

  /// 构建已连接设备卡片
  Widget _buildConnectedDeviceCard(BuildContext context) {
    return Consumer<BluetoothProvider>(
      builder: (context, bluetoothProvider, child) {
        final isConnected = bluetoothProvider.state.isConnected;
        final connectedDevice = bluetoothProvider.state.connectedDevice;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.l10n.deviceManagementCardTitle,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isConnected ? Colors.green : Colors.grey,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      isConnected
                          ? context.l10n.deviceStatusConnected
                          : context.l10n.deviceStatusDisconnected,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                isConnected
                    ? (connectedDevice?.name ?? context.l10n.deviceUnknownName)
                    : context.l10n.deviceNonePlaceholder,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isConnected
                      ? () => _disconnect(context)
                      : () => _showDeviceScanDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isConnected ? Colors.red : Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    isConnected
                        ? context.l10n.deviceDisconnectButton
                        : context.l10n.deviceConnectButton,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// 构建设备信息卡片
  Widget _buildDeviceInfoCard() {
    return Consumer<BluetoothProvider>(
      builder: (context, bluetoothProvider, child) {
        final isConnected = bluetoothProvider.state.isConnected;
        final connectedDevice = bluetoothProvider.state.connectedDevice;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.deviceInfoTitle,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              _buildInfoRow(
                context.l10n.deviceInfoRssiLabel,
                isConnected ? '${connectedDevice?.rssi ?? '--'} dBm' : '-- dBm',
              ),
            ],
          ),
        );
      },
    );
  }

  /// 构建信息行
  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  /// 断开连接
  void _disconnect(BuildContext context) {
    final bluetoothProvider = Provider.of<BluetoothProvider>(
      context,
      listen: false,
    );
    bluetoothProvider.disconnect();
  }

  /// 显示设备扫描对话框
  void _showDeviceScanDialog(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DeviceScanScreen()),
    );
  }
}

/// 数据监控标签页
class _DataMonitoringTab extends StatefulWidget {
  const _DataMonitoringTab();

  @override
  State<_DataMonitoringTab> createState() => _DataMonitoringTabState();
}

class _DataMonitoringTabState extends State<_DataMonitoringTab> {
  final List<UuidConfig> _selectedConfigs = [];
  bool _isDataNotificationActive = false;

  final UuidConfigService _uuidConfigService = UuidConfigService();
  final Map<String, Color> _colorByUuid = {};

  static const List<Color> _chartColors = [
    Color(0xFF42A5F5),
    Color(0xFFFFA726),
    Color(0xFF66BB6A),
    Color(0xFF26C6DA),
    Color(0xFFAB47BC),
    Color(0xFFFF7043),
    Color(0xFF7E57C2),
    Color(0xFF26A69A),
  ];

  @override
  void initState() {
    super.initState();
    _loadSelectedConfigs();
  }

  Future<void> _loadSelectedConfigs() async {
    final configs = await _uuidConfigService.getSelectedConfigs();
    if (!mounted) return;
    setState(() {
      _selectedConfigs
        ..clear()
        ..addAll(configs);
    });
    _syncColorsWithSelection();
  }

  void _syncColorsWithSelection() {
    final Set<String> activeUuids = _selectedConfigs
        .map((config) => _normalizeUuid(config.characteristicUuid))
        .toSet();

    _colorByUuid.removeWhere((uuid, _) => !activeUuids.contains(uuid));

    for (final String uuid in activeUuids) {
      _colorByUuid.putIfAbsent(
        uuid,
        () => _chartColors[_colorByUuid.length % _chartColors.length],
      );
    }
  }

  Color _colorForUuid(String uuid) {
    final String normalized = _normalizeUuid(uuid);
    return _colorByUuid.putIfAbsent(
      normalized,
      () => _chartColors[_colorByUuid.length % _chartColors.length],
    );
  }

  Set<String> _selectedUuidSet() => _selectedConfigs
      .map((config) => _normalizeUuid(config.characteristicUuid))
      .toSet();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.monitoringTitle),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showCharacteristicSelector,
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: Consumer<BluetoothProvider>(
        builder: (context, bluetoothProvider, child) {
          if (!bluetoothProvider.isConnected) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.bluetooth_disabled, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    l10n.monitoringConnectRequired,
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildConnectionStatus(bluetoothProvider),
                  const SizedBox(height: 16),
                  _buildCurrentDataCard(bluetoothProvider),
                  const SizedBox(height: 16),
                  _buildSensorChart(bluetoothProvider),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showSnackBar(String message, {Color? color}) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  String _normalizeUuid(String uuid) => uuid.trim().toLowerCase();

  Future<void> _startListening(BluetoothProvider bluetoothProvider) async {
    final l10n = context.l10n;
    if (_selectedConfigs.isEmpty) {
      _showSnackBar(l10n.monitoringSnackSelectConfig);
      return;
    }

    final Map<String, Map<String, String>> groupedByService = {};
    final Map<String, String> serviceOriginalByKey = {};
    final Map<String, String> withoutService = {};

    for (final UuidConfig config in _selectedConfigs) {
      final String trimmedCharacteristic = config.characteristicUuid.trim();
      if (trimmedCharacteristic.isEmpty) {
        continue;
      }

      final String normalizedCharacteristic = _normalizeUuid(
        trimmedCharacteristic,
      );

      final String serviceUuid = config.serviceUuid.trim();
      if (serviceUuid.isEmpty) {
        withoutService.putIfAbsent(
          normalizedCharacteristic,
          () => trimmedCharacteristic,
        );
      } else {
        final String normalizedService = _normalizeUuid(serviceUuid);
        serviceOriginalByKey.putIfAbsent(normalizedService, () => serviceUuid);
        final Map<String, String> characteristicMap = groupedByService
            .putIfAbsent(normalizedService, () => <String, String>{});
        characteristicMap.putIfAbsent(
          normalizedCharacteristic,
          () => trimmedCharacteristic,
        );
      }
    }

    if (groupedByService.isEmpty && withoutService.isEmpty) {
      _showSnackBar(l10n.monitoringConfigNotProvided);
      return;
    }

    bool anySuccess = false;

    for (final MapEntry<String, Map<String, String>> entry
        in groupedByService.entries) {
      final String? originalServiceUuid = serviceOriginalByKey[entry.key];
      if (originalServiceUuid == null) continue;

      final bool success = await bluetoothProvider.setupDataNotification(
        serviceUuid: originalServiceUuid,
        characteristicUuids: entry.value.values.toList(),
      );
      anySuccess = anySuccess || success;
    }

    if (withoutService.isNotEmpty) {
      final bool success = await bluetoothProvider.setupDataNotification(
        characteristicUuids: withoutService.values.toList(),
      );
      anySuccess = anySuccess || success;
    }

    if (!mounted) return;

    if (anySuccess) {
      setState(() {
        _isDataNotificationActive = true;
      });
      _showSnackBar(l10n.monitoringSnackStartSuccess, color: Colors.green);
    } else {
      _showSnackBar(l10n.monitoringSnackStartFailure, color: Colors.redAccent);
    }
  }

  Future<bool> _stopListening(
    BluetoothProvider bluetoothProvider, {
    bool showFeedback = true,
  }) async {
    final l10n = context.l10n;
    if (_selectedConfigs.isEmpty) {
      if (showFeedback) _showSnackBar(l10n.monitoringSnackNoActive);
      return false;
    }

    final List<String> targets = _selectedConfigs
        .map((config) => config.characteristicUuid.trim())
        .where((uuid) => uuid.isNotEmpty)
        .toList();

    if (targets.isEmpty) {
      if (showFeedback) _showSnackBar(l10n.monitoringSnackNoActive);
      return false;
    }

    final bool stopped = await bluetoothProvider.stopDataNotification(
      characteristicUuids: targets,
    );

    if (!mounted) return stopped;

    if (stopped) {
      setState(() {
        _isDataNotificationActive = false;
      });
      if (showFeedback) {
        _showSnackBar(l10n.monitoringSnackStopSuccess);
      }
    } else if (showFeedback) {
      _showSnackBar(l10n.monitoringSnackStopFailure);
    }

    return stopped;
  }

  void _clearSelectedData(BluetoothProvider bluetoothProvider) {
    final l10n = context.l10n;
    if (_selectedConfigs.isEmpty) {
      _showSnackBar(l10n.monitoringSnackSelectConfig);
      return;
    }

    final List<String> targets = _selectedConfigs
        .map((config) => config.characteristicUuid.trim())
        .where((uuid) => uuid.isNotEmpty)
        .toList();

    if (targets.isEmpty) {
      _showSnackBar(l10n.monitoringSnackSelectConfig);
      return;
    }

    bluetoothProvider.clearSensorHistory(characteristicUuids: targets);
    _showSnackBar(l10n.monitoringSnackClearSuccess, color: Colors.orange);
  }

  Future<void> _showCharacteristicSelector() async {
    final l10n = context.l10n;
    final BluetoothProvider bluetoothProvider = context
        .read<BluetoothProvider>();

    List<UuidConfig> allConfigs = await _uuidConfigService
        .getAllConfigs();
    if (!mounted) return;

    if (allConfigs.isEmpty) {
      final UuidConfig? created =
          await _showUuidConfigForm(initialConfig: null);
      if (created == null) {
        _showSnackBar(l10n.monitoringNoSavedConfigs);
        return;
      }

      final bool saved = await _uuidConfigService.saveConfig(created);
      if (!saved) {
        _showSnackBar(l10n.monitoringConfigSaveFailed, color: Colors.red);
        return;
      }

      _showSnackBar(l10n.monitoringConfigCreateSuccess, color: Colors.green);
      allConfigs = await _uuidConfigService.getAllConfigs();
      if (!mounted) return;
      if (allConfigs.isEmpty) {
        _showSnackBar(l10n.monitoringNoSavedConfigs);
        return;
      }
    }

    final Set<String> initialSelection = _selectedConfigs
        .map((config) => config.id)
        .toSet();

    bool configsModified = false;
    final List<String>? result = await showDialog<List<String>>(
      context: context,
      builder: (BuildContext dialogContext) {
        final Set<String> tempSelection = Set<String>.from(initialSelection);
        return StatefulBuilder(
          builder: (context, setState) {
            Future<void> refreshConfigs() async {
              final List<UuidConfig> refreshed =
                  await _uuidConfigService.getAllConfigs();
              setState(() {
                allConfigs
                  ..clear()
                  ..addAll(refreshed);
                final Set<String> existingIds =
                    allConfigs.map((config) => config.id).toSet();
                tempSelection.removeWhere(
                  (id) => !existingIds.contains(id),
                );
              });
            }

            Future<void> handleEdit(UuidConfig config) async {
              final UuidConfig? updated =
                  await _showUuidConfigForm(initialConfig: config);
              if (updated == null) return;

              final bool success = await _uuidConfigService.saveConfig(updated);
              if (!success) {
                if (!mounted) return;
                _showSnackBar(l10n.monitoringConfigSaveFailed, color: Colors.red);
                return;
              }
              configsModified = true;
              await refreshConfigs();
              if (!mounted) return;
              _showSnackBar(l10n.monitoringConfigUpdateSuccess, color: Colors.green);
            }

            Future<void> handleDelete(UuidConfig config) async {
              final bool? confirmed = await showDialog<bool>(
                context: dialogContext,
                builder: (context) => AlertDialog(
                  title: Text(l10n.dialogConfirmDeleteTitle),
                  content: Text(
                    l10n.monitoringConfirmDeleteConfig(config.name),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(l10n.commonCancel),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text(l10n.commonDelete),
                    ),
                  ],
                ),
              );
              if (confirmed != true) return;

              final bool success =
                  await _uuidConfigService.deleteConfig(config.id);
              if (!success) {
                if (!mounted) return;
                _showSnackBar(l10n.monitoringConfigDeleteFailed, color: Colors.red);
                return;
              }
              configsModified = true;
              await refreshConfigs();
              setState(() {
                tempSelection.remove(config.id);
              });
              if (!mounted) return;
              _showSnackBar(l10n.monitoringConfigDeleteSuccess, color: Colors.green);
            }

            Future<void> handleCreate() async {
              final UuidConfig? created =
                  await _showUuidConfigForm(initialConfig: null);
              if (created == null) return;

              final bool success = await _uuidConfigService.saveConfig(created);
              if (!success) {
                if (!mounted) return;
                _showSnackBar(l10n.monitoringConfigSaveFailed, color: Colors.red);
                return;
              }
              configsModified = true;
              await refreshConfigs();
              setState(() {
                tempSelection.add(created.id);
              });
              if (!mounted) return;
              _showSnackBar(l10n.monitoringConfigCreateSuccess, color: Colors.green);
            }

            return AlertDialog(
              title: Text(l10n.monitoringSelectConfigDialogTitle),
              content: SizedBox(
                width: double.maxFinite,
                height: 360,
                child: allConfigs.isEmpty
                    ? Center(
                        child: Text(
                          l10n.monitoringNoSavedConfigs,
                          style: TextStyle(color: Colors.black54),
                        ),
                      )
                    : ListView.separated(
                        itemCount: allConfigs.length,
                        separatorBuilder: (context, index) =>
                            const Divider(height: 1, thickness: 0.5),
                        itemBuilder: (context, index) {
                          final UuidConfig config = allConfigs[index];
                          final bool isChecked =
                              tempSelection.contains(config.id);

                          void toggleSelection([bool? nextValue]) {
                            final bool shouldSelect = nextValue ?? !isChecked;
                            setState(() {
                              if (shouldSelect) {
                                tempSelection.add(config.id);
                              } else {
                                tempSelection.remove(config.id);
                              }
                            });
                          }

                          return ListTile(
                            onTap: toggleSelection,
                            leading: Checkbox(
                              value: isChecked,
                              onChanged: (_) => toggleSelection(),
                            ),
                            title: Text(config.name),
                            subtitle: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Service: ${config.serviceUuid}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                                Text(
                                  'Characteristic: ${config.characteristicUuid}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                                if (config.description != null &&
                                    config.description!.isNotEmpty)
                                  Text(
                                    config.description!,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
                                  ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  tooltip: l10n.commonEdit,
                                  icon: const Icon(Icons.edit_outlined),
                                  onPressed: () => handleEdit(config),
                                ),
                                IconButton(
                                  tooltip: l10n.commonDelete,
                                  icon: const Icon(Icons.delete_outline),
                                  onPressed: () => handleDelete(config),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
              actions: [
                TextButton(
                  onPressed: () => handleCreate(),
                  child: Text(l10n.monitoringDialogCreateButton),
                ),
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: Text(l10n.commonCancel),
                ),
                ElevatedButton(
                  onPressed: () =>
                      Navigator.of(dialogContext).pop(tempSelection.toList()),
                  child: Text(l10n.commonApply),
                ),
              ],
            );
          },
        );
      },
    );

    if (result == null) {
      if (configsModified) {
        await _loadSelectedConfigs();
      }
      return;
    }

    final List<String> orderedSelection = <String>[];
    for (final String id in result) {
      if (!orderedSelection.contains(id)) {
        orderedSelection.add(id);
      }
    }

    final Set<String> newSelection = orderedSelection.toSet();
    if (newSelection.length == initialSelection.length &&
        initialSelection.containsAll(newSelection)) {
      return;
    }

    final bool wasListening = _selectedUuidSet().any(
      (uuid) => bluetoothProvider.notificationStatus[uuid] ?? false,
    );

    if (wasListening) {
      await _stopListening(bluetoothProvider, showFeedback: false);
      if (!mounted) return;
      _showSnackBar(l10n.monitoringSnackStoppedForUpdate, color: Colors.orange);
    }

    await _uuidConfigService.setSelectedConfigs(orderedSelection);

    final List<UuidConfig> updatedSelection = <UuidConfig>[];
    for (final String id in orderedSelection) {
      for (final UuidConfig config in allConfigs) {
        if (config.id == id) {
          updatedSelection.add(config);
          break;
        }
      }
    }

    if (!mounted) return;
    setState(() {
      _selectedConfigs
        ..clear()
        ..addAll(updatedSelection);
      _syncColorsWithSelection();
    });

    if (configsModified) {
      await _loadSelectedConfigs();
    }
  }

  Future<UuidConfig?> _showUuidConfigForm({UuidConfig? initialConfig}) async {
    final l10n = context.l10n;
    final bool isEditing = initialConfig != null;
    final TextEditingController nameController = TextEditingController(
      text: initialConfig?.name ?? '',
    );
    final TextEditingController serviceController = TextEditingController(
      text: initialConfig?.serviceUuid ?? '',
    );
    final TextEditingController characteristicController =
        TextEditingController(
      text: initialConfig?.characteristicUuid ?? '',
    );
    final TextEditingController descriptionController = TextEditingController(
      text: initialConfig?.description ?? '',
    );
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return showDialog<UuidConfig>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            isEditing
                ? l10n.monitoringEditConfigTitle
                : l10n.monitoringCreateConfigTitle,
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: l10n.uuidConfigNameLabel,
                      hintText: l10n.uuidConfigNameHint,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.uuidConfigNameRequired;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: serviceController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Service UUID',
                      hintText: l10n.uuidConfigServiceHint,
                    ),
                    validator: (value) {
                      final String text = value?.trim() ?? '';
                      if (text.isEmpty) {
                        return null;
                      }
                      if (!UuidConfigService.isValidUuid(text)) {
                        return l10n.uuidConfigServiceInvalid;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: characteristicController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: l10n.uuidConfigCharacteristicLabel,
                      hintText: l10n.uuidConfigCharacteristicHint,
                    ),
                    validator: (value) {
                      final String text = value?.trim() ?? '';
                      if (text.isEmpty) {
                        return l10n.uuidConfigCharacteristicRequired;
                      }
                      if (!UuidConfigService.isValidUuid(text)) {
                        return l10n.uuidConfigCharacteristicInvalid;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: descriptionController,
                    textInputAction: TextInputAction.done,
                    maxLines: 2,
                    decoration: InputDecoration(
                      labelText: l10n.uuidConfigDescriptionLabel,
                      hintText: l10n.uuidConfigDescriptionHint,
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.commonCancel),
            ),
            ElevatedButton(
              onPressed: () {
                if (!formKey.currentState!.validate()) {
                  return;
                }
                final DateTime now = DateTime.now();
                final String descriptionText =
                    descriptionController.text.trim();
                final UuidConfig? baseConfig = initialConfig;
                final UuidConfig result;
                if (isEditing && baseConfig != null) {
                  result = baseConfig.copyWith(
                    name: nameController.text.trim(),
                    serviceUuid: serviceController.text.trim(),
                    characteristicUuid: characteristicController.text.trim(),
                    description:
                        descriptionText.isEmpty ? null : descriptionText,
                  );
                } else {
                  result = UuidConfig(
                    id: now.microsecondsSinceEpoch.toString(),
                    name: nameController.text.trim(),
                    serviceUuid: serviceController.text.trim(),
                    characteristicUuid: characteristicController.text.trim(),
                    description:
                        descriptionText.isEmpty ? null : descriptionText,
                    createdAt: now,
                  );
                }
                Navigator.of(context).pop(result);
              },
              child: Text(isEditing ? l10n.commonSave : l10n.commonAdd),
            ),
          ],
        );
      },
    );
  }

  Widget _buildConnectionStatus(BluetoothProvider bluetoothProvider) {
    final l10n = context.l10n;
    final DeviceInfo? device = bluetoothProvider.connectedDevice;
    final Map<String, bool> statusMap = bluetoothProvider.notificationStatus;
    final Set<String> selectedUuids = _selectedUuidSet();
    final int activeCount = selectedUuids
        .where((uuid) => statusMap[uuid] ?? false)
        .length;

    final bool hasSelection = selectedUuids.isNotEmpty;
    final bool isActive = hasSelection && activeCount > 0;

    if (_isDataNotificationActive != isActive) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(() {
          _isDataNotificationActive = isActive;
        });
      });
    }

    final String deviceName = (device != null && device.name.isNotEmpty)
        ? device.name
        : l10n.deviceUnknownName;
    final int selectedCount = selectedUuids.length;
    final String selectionLabel = hasSelection
        ? l10n.monitoringStatusSelectionCount(selectedCount)
        : l10n.monitoringStatusNoSelection;

    final String statusLabel;
    final Color statusColor;

    if (!hasSelection) {
      statusLabel = l10n.monitoringStatusNoSelection;
      statusColor = Colors.grey;
    } else if (isActive) {
      statusLabel = l10n.monitoringStatusActive(activeCount, selectedCount);
      statusColor = Colors.green;
    } else {
      statusLabel = l10n.monitoringStatusIdle;
      statusColor = Colors.orange;
    }

    final bool canStart = hasSelection && !isActive;
    final bool canStop = hasSelection && isActive;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.bluetooth_connected,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.monitoringStatusTitle,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      deviceName,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      selectionLabel,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  statusLabel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              ElevatedButton.icon(
                onPressed: canStart
                    ? () => _startListening(bluetoothProvider)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                icon: const Icon(Icons.play_arrow),
                label: Text(l10n.monitoringButtonStart),
              ),
              OutlinedButton.icon(
                onPressed: canStop
                    ? () => _stopListening(bluetoothProvider)
                    : null,
                icon: const Icon(Icons.stop),
                label: Text(l10n.monitoringButtonStop),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: hasSelection
                    ? () => _clearSelectedData(bluetoothProvider)
                    : null,
                icon: const Icon(Icons.cleaning_services_outlined),
                label: Text(l10n.monitoringButtonClear),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentDataCard(BluetoothProvider bluetoothProvider) {
    final l10n = context.l10n;
    if (_selectedConfigs.isEmpty) {
      return _buildEmptyDataCard(
        title: l10n.monitoringEmptyCurrentTitle,
        message: l10n.monitoringEmptyCurrentMessage,
      );
    }

    final Map<String, SensorData> latestData =
        bluetoothProvider.latestSensorDataByUuid;
    final Map<String, bool> statusMap = bluetoothProvider.notificationStatus;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.sensors, color: Colors.green),
              ),
              const SizedBox(width: 12),
              Text(
                l10n.monitoringCurrentDataTitle,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._selectedConfigs.map((config) {
            final String normalized = _normalizeUuid(config.characteristicUuid);
            final SensorData? sensorData = latestData[normalized];
            final bool isActive = statusMap[normalized] ?? false;
            final Color color = _colorForUuid(config.characteristicUuid);
            final String valueText = sensorData?.formattedValue ?? '--';
            final String timeText = sensorData != null
                ? DateFormat('HH:mm:ss').format(sensorData.timestamp)
                : '--';

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.withValues(alpha: 0.4)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    margin: const EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          config.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.monitoringServiceLabel(config.serviceUuid),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                        Text(
                          l10n.monitoringCharacteristicLabel(
                            config.characteristicUuid,
                          ),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isActive ? Colors.green : Colors.grey,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          isActive
                              ? l10n.monitoringChipActive
                              : l10n.monitoringChipInactive,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        valueText,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.monitoringLastUpdated(timeText),
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSensorChart(BluetoothProvider bluetoothProvider) {
    final l10n = context.l10n;
    if (_selectedConfigs.isEmpty) {
      return _buildEmptyChart(
        title: l10n.monitoringChartTitle,
        message: l10n.monitoringEmptyCurrentMessage,
      );
    }

    final Map<String, List<SensorData>> histories = {};
    DateTime? earliest;
    DateTime? latest;
    double minValue = double.infinity;
    double maxValue = -double.infinity;

    for (final UuidConfig config in _selectedConfigs) {
      final String normalized = _normalizeUuid(config.characteristicUuid);
      final List<SensorData> history = bluetoothProvider.getSensorDataHistory(
        normalized,
      );
      if (history.isEmpty) continue;

      histories[normalized] = history;

      for (final SensorData data in history) {
        final DateTime? currentEarliest = earliest;
        if (currentEarliest == null ||
            data.timestamp.isBefore(currentEarliest)) {
          earliest = data.timestamp;
        }
        final DateTime? currentLatest = latest;
        if (currentLatest == null || data.timestamp.isAfter(currentLatest)) {
          latest = data.timestamp;
        }
        if (data.value < minValue) minValue = data.value;
        if (data.value > maxValue) maxValue = data.value;
      }
    }

    if (histories.isEmpty || earliest == null || latest == null) {
      return _buildEmptyChart(
        title: l10n.monitoringChartTitle,
        message: l10n.monitoringChartEmptyMessage,
      );
    }

    final DateTime startTime = earliest;
    final DateTime endTime = latest;
    double maxXSeconds =
        (endTime.millisecondsSinceEpoch - startTime.millisecondsSinceEpoch) /
        1000.0;
    if (maxXSeconds <= 0) {
      maxXSeconds = 1;
    }

    final double range = maxValue - minValue;
    double padding = range.abs() * 0.1;
    if (padding == 0) {
      padding = maxValue == 0 ? 1 : maxValue.abs() * 0.1;
    }
    if (padding == 0) padding = 1;

    double verticalInterval = range.abs() / 4;
    if (verticalInterval <= 0) {
      verticalInterval = (maxValue.abs() / 4).abs();
    }
    if (verticalInterval <= 0) verticalInterval = 1;

    double horizontalInterval = maxXSeconds / 4;
    if (horizontalInterval <= 0) horizontalInterval = 1;

    final List<LineChartBarData> lineBars = [];
    final List<UuidConfig> configOrder = [];

    for (final UuidConfig config in _selectedConfigs) {
      final String normalized = _normalizeUuid(config.characteristicUuid);
      final List<SensorData>? history = histories[normalized];
      if (history == null || history.isEmpty) continue;

      final Color color = _colorForUuid(config.characteristicUuid);
      final List<FlSpot> spots = history
          .map(
            (data) => FlSpot(
              (data.timestamp.millisecondsSinceEpoch -
                      startTime.millisecondsSinceEpoch) /
                  1000.0,
              data.value,
            ),
          )
          .toList();

      lineBars.add(
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: color,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                color.withValues(alpha: 0.18),
                color.withValues(alpha: 0.0),
              ],
            ),
          ),
        ),
      );
      configOrder.add(config);
    }

    if (lineBars.isEmpty) {
      return _buildEmptyChart(
        title: l10n.monitoringChartTitle,
        message: l10n.monitoringChartEmptyMessage,
      );
    }

    final DateFormat timeFormatter = DateFormat('HH:mm:ss');

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.timeline, color: Colors.blue),
              ),
              const SizedBox(width: 12),
              Text(
                l10n.monitoringChartTitle,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 16),
            if (configOrder.length > 1)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildChartLegend(configOrder),
              ),
            SizedBox(
              height: 320,
              child: LineChart(
                LineChartData(
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                    tooltipPadding: const EdgeInsets.all(8),
                    getTooltipColor: (_) => Colors.black87,
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots
                          .map((spot) {
                            if (spot.barIndex >= configOrder.length) {
                              return null;
                            }
                            final UuidConfig config =
                                configOrder[spot.barIndex];
                            final List<SensorData> history =
                                histories[_normalizeUuid(
                                  config.characteristicUuid,
                                )] ??
                                <SensorData>[];
                            final SensorData? data =
                                (spot.spotIndex >= 0 &&
                                    spot.spotIndex < history.length)
                                ? history[spot.spotIndex]
                                : null;
                            final String valueText = data != null
                                ? data.value.toStringAsFixed(2)
                                : spot.y.toStringAsFixed(2);
                            final String timeText = data != null
                                ? timeFormatter.format(data.timestamp)
                                : timeFormatter.format(
                                    startTime.add(
                                      Duration(
                                        milliseconds: (spot.x * 1000).round(),
                                      ),
                                    ),
                                  );

                        return LineTooltipItem(
                          l10n.monitoringTooltip(config.name, valueText, timeText),
                          const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                          })
                          .whereType<LineTooltipItem>()
                          .toList();
                    },
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  drawHorizontalLine: true,
                  verticalInterval: horizontalInterval,
                  horizontalInterval: verticalInterval,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: Colors.blue.withValues(alpha: 0.1),
                    strokeWidth: 1,
                  ),
                  getDrawingVerticalLine: (_) => FlLine(
                    color: Colors.blue.withValues(alpha: 0.1),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: horizontalInterval,
                      getTitlesWidget: (value, meta) {
                        final DateTime labelTime = startTime.add(
                          Duration(milliseconds: (value * 1000).round()),
                        );
                        return SideTitleWidget(
                          meta: meta,
                          space: 6,
                          child: Text(
                            timeFormatter.format(labelTime),
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.black54,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 48,
                      interval: verticalInterval,
                      getTitlesWidget: (value, meta) {
                        return SideTitleWidget(
                          meta: meta,
                          space: 6,
                          child: Text(
                            value.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.black54,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
                ),
                minX: 0,
                maxX: maxXSeconds,
                minY: minValue - padding,
                maxY: maxValue + padding,
                lineBarsData: lineBars,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartLegend(List<UuidConfig> configs) {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: configs.map((config) {
        final Color color = _colorForUuid(config.characteristicUuid);
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
            Text(
              config.name,
              style: const TextStyle(fontSize: 12, color: Colors.black87),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildEmptyDataCard({required String title, required String message}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline, color: Colors.blue),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: Colors.black45),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyChart({required String title, required String message}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.timeline, color: Colors.blue),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: Colors.black45),
          ),
        ],
      ),
    );
  }
}

class _RecordsTab extends StatefulWidget {
  const _RecordsTab();

  @override
  State<_RecordsTab> createState() => _RecordsTabState();
}

class _RecordsTabState extends State<_RecordsTab> {
  final List<SensorRecord> _records = <SensorRecord>[];
  bool _isRecording = false;
  bool _isLoadingRecords = false;

  final CsvExportService _csvExportService = CsvExportService();
  final SensorRecordingService _recordingService = SensorRecordingService();
  final UuidConfigService _uuidConfigService = UuidConfigService();
  final BluetoothService _bluetoothService = BluetoothService();

  StreamSubscription<CharacteristicDataEvent>? _recordingSubscription;
  Set<String> _recordingUuids = <String>{};
  List<String> _displayUuidOrder = <String>[];
  final Map<String, String> _uuidNameByNormalized = <String, String>{};
  DateTime? _lastRecordTime;

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  @override
  void dispose() {
    _recordingSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bool hasRecords = _records.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.recordsTabTitle),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: hasRecords ? _exportToCSV : null,
            tooltip: l10n.recordsExportCsvTooltip,
          ),
          IconButton(
            icon: Icon(_isRecording ? Icons.stop : Icons.play_arrow),
            onPressed: _toggleRecording,
            color: _isRecording ? Colors.red : Colors.green,
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildRecordingStatus(),
            const SizedBox(height: 16),
            _buildRecordsList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _clearAllRecords,
        backgroundColor: Colors.red,
        child: const Icon(Icons.delete_forever, color: Colors.white),
      ),
    );
  }

  Widget _buildRecordingStatus() {
    final l10n = context.l10n;
    final DateTime? lastTime = _lastRecordTime ?? (_records.isNotEmpty ? _records.last.timestamp : null);
    final String lastTimeLabel = lastTime == null
        ? '--'
        : DateFormat('HH:mm:ss').format(lastTime.toLocal());
    final List<String> uuidOrderForDisplay = _displayUuidOrder.isNotEmpty
        ? _displayUuidOrder
        : _csvExportService.collectCharacteristicUuids(_records);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.recordsStatusTitle,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _isRecording ? Colors.green : Colors.grey,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  _isRecording
                      ? l10n.recordsStatusRecording
                      : l10n.recordsStatusStopped,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatusMetric(
                title: l10n.recordsMetricTotalRecords,
                value: '${_records.length}',
                color: Colors.blue,
              ),
              _buildStatusMetric(
                title: l10n.recordsMetricFeatureCount,
                value: '${uuidOrderForDisplay.length}',
                color: Colors.orange,
              ),
              _buildStatusMetric(
                title: l10n.recordsMetricLastTime,
                value: lastTimeLabel,
                color: Colors.teal,
              ),
            ],
          ),
          if (uuidOrderForDisplay.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              l10n.recordsCurrentFeaturesTitle,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: uuidOrderForDisplay
                  .map(
                    (uuid) => Chip(
                      label: Text(_uuidDisplayName(uuid)),
                      backgroundColor: Colors.blue.withValues(alpha: 0.08),
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusMetric({
    required String title,
    required String value,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildRecordsList() {
    final l10n = context.l10n;
    if (_isLoadingRecords) {
      return const Expanded(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: _records.isEmpty
                        ? Center(
                child: Text(
                  l10n.recordsEmptyMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: _records.length,
                itemBuilder: (context, index) {
                  final SensorRecord record =
                      _records[_records.length - 1 - index];
                  return _buildRecordTile(record);
                },
              ),
      ),
    );
  }

  Widget _buildRecordTile(SensorRecord record) {
    final l10n = context.l10n;
    final List<Widget> chips = _buildValueChips(record);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[50],
        border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _formatTimestamp(record.timestamp),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          if (chips.isEmpty)
            Text(
              l10n.recordsNoSensorValues,
              style: TextStyle(fontSize: 12, color: Colors.black45),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: chips,
            ),
        ],
      ),
    );
  }

  List<Widget> _buildValueChips(SensorRecord record) {
    final List<Widget> chips = <Widget>[];
    final Map<String, double> values = record.valuesByUuid;

    final List<String> preferredOrder = _displayUuidOrder.isNotEmpty
        ? _displayUuidOrder
        : _csvExportService.collectCharacteristicUuids(_records);

    final Set<String> appended = <String>{};

    void addChip(String uuid, double? value) {
      if (value == null) return;
      final String displayName = _uuidDisplayName(uuid);
      chips.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
          ),
          child: Text(
            '$displayName: ${value.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 12, color: Colors.black87),
          ),
        ),
      );
      appended.add(_normalizeUuid(uuid));
    }

    for (final String uuid in preferredOrder) {
      addChip(uuid, record.valueForUuid(uuid));
    }

    for (final MapEntry<String, double> entry in values.entries) {
      final String normalized = _normalizeUuid(entry.key);
      if (appended.contains(normalized)) continue;
      addChip(entry.key, entry.value);
    }

    return chips;
  }

  Future<void> _toggleRecording() async {
    if (_isRecording) {
      await _stopRecording();
      return;
    }

    final bool started = await _startRecording();
    if (!started && mounted) {
      setState(() {
        _isRecording = false;
      });
    }
  }

  Future<bool> _startRecording() async {
    final l10n = context.l10n;
    final BluetoothProvider bluetoothProvider =
        Provider.of<BluetoothProvider>(context, listen: false);

    if (!bluetoothProvider.isConnected) {
      _showSnackBar(l10n.monitoringConnectRequired, color: Colors.orange);
      return false;
    }

    final List<UuidConfig> configs =
        await _uuidConfigService.getSelectedConfigs();
    final Set<String> targetUuids = configs
        .map((config) => config.characteristicUuid.trim())
        .where((uuid) => uuid.isNotEmpty)
        .map(_normalizeUuid)
        .toSet();

    if (targetUuids.isEmpty) {
      _showSnackBar(l10n.recordsSnackbarSelectFeatures, color: Colors.orange);
      return false;
    }

    final bool notificationsReady = await _ensureNotifications(
      bluetoothProvider,
      configs,
      targetUuids,
    );

    if (!notificationsReady) {
      _showSnackBar(l10n.monitoringSnackCannotEnable, color: Colors.red);
      return false;
    }

    await _recordingSubscription?.cancel();
    final Map<String, String> namesByUuid = <String, String>{};
    final List<String> order = <String>[];
    for (final UuidConfig config in configs) {
      final String normalized = _normalizeUuid(config.characteristicUuid);
      if (normalized.isEmpty) continue;
      order.add(normalized);
      final String displayName = config.name.trim().isNotEmpty
          ? config.name.trim()
          : config.characteristicUuid.trim();
      namesByUuid[normalized] = displayName;
    }
    if (mounted) {
      setState(() {
        _recordingUuids = targetUuids;
        _displayUuidOrder = order;
        _uuidNameByNormalized
          ..clear()
          ..addAll(namesByUuid);
      });
    } else {
      _recordingUuids = targetUuids;
      _displayUuidOrder = order;
      _uuidNameByNormalized
        ..clear()
        ..addAll(namesByUuid);
    }

    _recordingSubscription =
        _bluetoothService.characteristicDataStream.listen(
      (CharacteristicDataEvent event) {
        final String normalizedUuid = _normalizeUuid(event.characteristicUuid);
        if (!_recordingUuids.contains(normalizedUuid)) {
          return;
        }

        final SensorRecord record = SensorRecord.single(
          uuid: normalizedUuid,
          value: event.data.value,
          timestamp: event.data.timestamp,
        );

        if (!mounted) return;
        setState(() {
          _records.add(record);
          _lastRecordTime = record.timestamp;
          if (!_displayUuidOrder.contains(normalizedUuid)) {
            _displayUuidOrder.add(normalizedUuid);
          }
          _uuidNameByNormalized.putIfAbsent(
            normalizedUuid,
            () => event.characteristicUuid.toUpperCase(),
          );
        });
        _persistRecordsAsync();
      },
      onError: (Object error, StackTrace stackTrace) {
        _handleRecordingError(error);
      },
    );

    if (!mounted) {
      return false;
    }

    setState(() {
      _isRecording = true;
    });
    _showSnackBar(l10n.recordsSnackbarRecordingStarted, color: Colors.green);
    return true;
  }

  Future<void> _stopRecording() async {
    final l10n = context.l10n;
    await _recordingSubscription?.cancel();
    _recordingSubscription = null;
    _recordingUuids = <String>{};

    if (!mounted) return;

    setState(() {
      _isRecording = false;
    });
    _showSnackBar(l10n.recordsSnackbarRecordingStopped);
  }

  void _handleRecordingError(Object error) {
    final l10n = context.l10n;
    _showSnackBar(l10n.recordsSnackbarRecordingError('$error'), color: Colors.red);
    _stopRecording();
  }

  void _clearAllRecords() {
    final l10n = context.l10n;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.dialogConfirmDeleteTitle),
        content: Text(l10n.recordsConfirmDeleteAllMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            onPressed: () async {
              setState(() {
                _records.clear();
                _lastRecordTime = null;
              });
              await _recordingService.clear();
              if (!mounted) return;
              Navigator.of(this.context).pop();
            },
            child: Text(
              l10n.commonDelete,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final DateTime local = timestamp.toLocal();
    return '${local.month.toString().padLeft(2, '0')}-'
        '${local.day.toString().padLeft(2, '0')} '
        '${local.hour.toString().padLeft(2, '0')}:'
        '${local.minute.toString().padLeft(2, '0')}:'
        '${local.second.toString().padLeft(2, '0')}';
  }

  Future<void> _loadRecords() async {
    setState(() {
      _isLoadingRecords = true;
    });

    final List<SensorRecord> storedRecords =
        await _recordingService.loadRecords();
    final List<UuidConfig> configs = await _uuidConfigService.getSelectedConfigs();
    final DateTime? lastTime =
        storedRecords.isNotEmpty ? storedRecords.last.timestamp : null;
    final List<String> order =
        _csvExportService.collectCharacteristicUuids(storedRecords);
    final Map<String, String> names = <String, String>{};
    for (final UuidConfig config in configs) {
      final String normalized = _normalizeUuid(config.characteristicUuid);
      if (normalized.isEmpty) continue;
      names[normalized] = config.name.trim().isNotEmpty
          ? config.name.trim()
          : config.characteristicUuid.trim();
    }

    if (!mounted) return;

    setState(() {
      _records
        ..clear()
        ..addAll(storedRecords);
      _isLoadingRecords = false;
      _displayUuidOrder = order;
      if (names.isNotEmpty) {
        _uuidNameByNormalized
          ..clear()
          ..addAll(names);
      }
      _lastRecordTime = lastTime;
    });
  }

  void _persistRecordsAsync() {
    final List<SensorRecord> snapshot = List<SensorRecord>.from(_records);
    Future.microtask(() => _recordingService.saveRecords(snapshot));
  }

  void _exportToCSV() async {
    final l10n = context.l10n;
    if (_records.isEmpty) {
      _showSnackBar(l10n.recordsSnackbarNoData, color: Colors.orange);
      return;
    }

    _showExportOptionsDialog();
  }

  void _showExportOptionsDialog() {
    final l10n = context.l10n;
    final List<String> exportUuids = _displayUuidOrder.isNotEmpty
        ? _displayUuidOrder
        : _csvExportService.collectCharacteristicUuids(_records);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.recordsExportDialogTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.recordsExportRecordCount(_records.length)),
            const SizedBox(height: 8),
            Text(l10n.recordsExportFeatureCount(exportUuids.length)),
            const SizedBox(height: 12),
            if (exportUuids.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: exportUuids
                    .map(
                      (uuid) => Chip(
                        label: Text(_uuidDisplayName(uuid)),
                        backgroundColor: Colors.blue.withValues(alpha: 0.1),
                      ),
                    )
                    .toList(),
              ),
            const SizedBox(height: 16),
            Text(l10n.recordsExportChooseFormat),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _exportToFile();
            },
            child: Text(l10n.recordsExportSaveFile),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showCSVPreview();
            },
            child: Text(l10n.recordsExportPreview),
          ),
        ],
      ),
    );
  }

  void _exportToFile() async {
    final l10n = context.l10n;
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 16),
              Text(l10n.recordsExporting),
            ],
          ),
        ),
      );

      final List<String> exportOrder = _displayUuidOrder.isNotEmpty
          ? _displayUuidOrder
          : _csvExportService.collectCharacteristicUuids(_records);
      final File file = await _csvExportService.exportSensorRecords(
        _records,
        orderedCharacteristicUuids: exportOrder,
      );
      final int fileSize = await _csvExportService.getFileSize(file);
      final String formattedSize =
          _csvExportService.formatFileSize(fileSize);

      if (mounted) Navigator.pop(context);

      if (mounted) _showExportSuccessDialog(file.path, formattedSize);
    } catch (e) {
      if (mounted) Navigator.pop(context);

      _showSnackBar(l10n.recordsExportFailed('$e'), color: Colors.red);
    }
  }

  void _showExportSuccessDialog(String filePath, String fileSize) {
    final l10n = context.l10n;
    final List<String> exportUuids = _displayUuidOrder.isNotEmpty
        ? _displayUuidOrder
        : _csvExportService.collectCharacteristicUuids(_records);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green),
            const SizedBox(width: 8),
            Text(l10n.recordsExportSuccessTitle),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.recordsExportSuccessPathLabel),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(4),
              ),
              child: SelectableText(
                filePath,
                style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
              ),
            ),
            const SizedBox(height: 8),
            Text('${l10n.recordsExportSuccessSizeLabel} $fileSize'),
            Text('${l10n.recordsExportSuccessRecordsLabel} ${_records.length}'),
            Text('${l10n.recordsExportSuccessFeaturesLabel} ${exportUuids.length}'),
            if (exportUuids.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: exportUuids
                    .map(
                      (uuid) => Chip(
                        label: Text(_uuidDisplayName(uuid)),
                        backgroundColor: Colors.blue.withValues(alpha: 0.1),
                      ),
                    )
                    .toList(),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.commonConfirm),
          ),
        ],
      ),
    );
  }

  void _showCSVPreview() {
    final l10n = context.l10n;
    final String csvContent = _generateCSVContent();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.recordsCsvPreviewTitle),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: SingleChildScrollView(
            child: SelectableText(
              csvContent,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.commonClose),
          ),
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: csvContent));
              Navigator.pop(context);
              _showSnackBar(l10n.recordsCsvCopied, color: Colors.green);
            },
            child: Text(l10n.commonCopy),
          ),
        ],
      ),
    );
  }

  String _generateCSVContent() {
    if (_records.isEmpty) {
      return context.l10n.recordsCsvHeader;
    }
    final List<String> exportOrder = _displayUuidOrder.isNotEmpty
        ? _displayUuidOrder
        : _csvExportService.collectCharacteristicUuids(_records);
    return _csvExportService.buildCsvContent(
      _records,
      orderedCharacteristicUuids: exportOrder,
    );
  }

  Future<bool> _ensureNotifications(
    BluetoothProvider bluetoothProvider,
    List<UuidConfig> configs,
    Set<String> targetUuids,
  ) async {
    final Map<String, bool> activeStatus =
        bluetoothProvider.notificationStatus;

    final Set<String> pendingUuids = targetUuids
        .where((uuid) => !(activeStatus[uuid] ?? false))
        .toSet();

    if (pendingUuids.isEmpty) {
      return true;
    }

    final Map<String, Map<String, String>> groupedByService = {};
    final Map<String, String> serviceOriginal = {};
    final Map<String, String> withoutService = {};

    for (final UuidConfig config in configs) {
      final String trimmedCharacteristic = config.characteristicUuid.trim();
      if (trimmedCharacteristic.isEmpty) continue;
      final String normalizedCharacteristic =
          _normalizeUuid(trimmedCharacteristic);
      if (!pendingUuids.contains(normalizedCharacteristic)) continue;

      final String serviceUuid = config.serviceUuid.trim();
      if (serviceUuid.isEmpty) {
        withoutService[normalizedCharacteristic] = trimmedCharacteristic;
      } else {
        final String normalizedService = _normalizeUuid(serviceUuid);
        serviceOriginal.putIfAbsent(normalizedService, () => serviceUuid);
        final Map<String, String> characteristicMap =
            groupedByService.putIfAbsent(
              normalizedService,
              () => <String, String>{},
            );
        characteristicMap[normalizedCharacteristic] = trimmedCharacteristic;
      }
    }

    bool anySuccess = false;
    for (final MapEntry<String, Map<String, String>> entry
        in groupedByService.entries) {
      final String? serviceUuid = serviceOriginal[entry.key];
      if (serviceUuid == null) continue;
      final List<String> characteristics = entry.value.values.toList();
      if (characteristics.isEmpty) continue;
      final bool success = await bluetoothProvider.setupDataNotification(
        serviceUuid: serviceUuid,
        characteristicUuids: characteristics,
      );
      anySuccess = anySuccess || success;
    }

    if (withoutService.isNotEmpty) {
      final bool success = await bluetoothProvider.setupDataNotification(
        characteristicUuids: withoutService.values.toList(),
      );
      anySuccess = anySuccess || success;
    }

    final Map<String, bool> refreshedStatus =
        bluetoothProvider.notificationStatus;
    final bool hasActive = targetUuids.any(
      (uuid) => refreshedStatus[uuid] == true,
    );

    return hasActive || anySuccess;
  }

  void _showSnackBar(String message, {Color color = Colors.blue}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  String _normalizeUuid(String uuid) => uuid.trim().toLowerCase();

  String _uuidDisplayName(String uuid) {
    final String normalized = _normalizeUuid(uuid);
    return _uuidNameByNormalized[normalized] ?? uuid.toUpperCase();
  }
}

