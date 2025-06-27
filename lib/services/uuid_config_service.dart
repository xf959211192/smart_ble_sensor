import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/uuid_config.dart';

/// UUID配置管理服务
class UuidConfigService {
  static const String _configsKey = 'uuid_configs';
  static const String _selectedConfigKey = 'selected_uuid_config';

  /// 获取所有保存的UUID配置
  Future<List<UuidConfig>> getAllConfigs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final configsJson = prefs.getStringList(_configsKey) ?? [];
      
      return configsJson.map((jsonStr) {
        final json = jsonDecode(jsonStr) as Map<String, dynamic>;
        return UuidConfig.fromJson(json);
      }).toList();
    } catch (e) {
      return [];
    }
  }

  /// 保存UUID配置
  Future<bool> saveConfig(UuidConfig config) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final configs = await getAllConfigs();
      
      // 检查是否已存在相同ID的配置
      final existingIndex = configs.indexWhere((c) => c.id == config.id);
      if (existingIndex >= 0) {
        configs[existingIndex] = config;
      } else {
        configs.add(config);
      }
      
      // 按最后使用时间排序，最近使用的在前
      configs.sort((a, b) {
        if (a.lastUsed == null && b.lastUsed == null) {
          return b.createdAt.compareTo(a.createdAt);
        }
        if (a.lastUsed == null) return 1;
        if (b.lastUsed == null) return -1;
        return b.lastUsed!.compareTo(a.lastUsed!);
      });
      
      final configsJson = configs.map((config) => jsonEncode(config.toJson())).toList();
      return await prefs.setStringList(_configsKey, configsJson);
    } catch (e) {
      return false;
    }
  }

  /// 删除UUID配置
  Future<bool> deleteConfig(String configId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final configs = await getAllConfigs();
      
      configs.removeWhere((config) => config.id == configId);
      
      final configsJson = configs.map((config) => jsonEncode(config.toJson())).toList();
      return await prefs.setStringList(_configsKey, configsJson);
    } catch (e) {
      return false;
    }
  }

  /// 更新配置的最后使用时间
  Future<bool> updateLastUsed(String configId) async {
    try {
      final configs = await getAllConfigs();
      final configIndex = configs.indexWhere((c) => c.id == configId);
      
      if (configIndex >= 0) {
        configs[configIndex] = configs[configIndex].copyWithLastUsed(DateTime.now());
        return await saveConfig(configs[configIndex]);
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// 获取当前选中的UUID配置
  Future<UuidConfig?> getSelectedConfig() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final configId = prefs.getString(_selectedConfigKey);
      
      if (configId != null) {
        final configs = await getAllConfigs();
        return configs.firstWhere(
          (config) => config.id == configId,
          orElse: () => throw Exception('Config not found'),
        );
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// 设置当前选中的UUID配置
  Future<bool> setSelectedConfig(String configId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await updateLastUsed(configId);
      return await prefs.setString(_selectedConfigKey, configId);
    } catch (e) {
      return false;
    }
  }

  /// 清除选中的配置
  Future<bool> clearSelectedConfig() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_selectedConfigKey);
    } catch (e) {
      return false;
    }
  }

  /// 验证UUID格式
  static bool isValidUuid(String uuid) {
    final uuidRegex = RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$'
    );
    return uuidRegex.hasMatch(uuid);
  }

  /// 生成唯一ID
  static String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
