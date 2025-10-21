# SmartBLESensor

SmartBLESensor is a Flutter application for monitoring Bluetooth Low Energy (BLE) sensors. It supports real-time data streaming, visual dashboards, history logging, and CSV exports, making it suitable for lab experiments, industrial monitoring, and personal projects.

## Features

### Smart BLE Connectivity
- Automatic device discovery with RSSI-based sorting
- One-tap connection and automatic navigation back to the dashboard
- Unified feedback for connection state, RSSI, and errors

### Real-Time Monitoring
- Works with any float-based sensor payload
- Multi-series line chart with tooltips and pinch zoom
- Scrollable monitoring layout prevents bottom overflow on small screens
- Live KPI cards showing the latest readings for each characteristic

### Data Management
- History logging with per-second snapshots and multi-characteristic aggregation
- CSV export with multi-column output, clipboard preview, and file save modes
- UUID configuration management with add, edit, and delete operations
- One-click cleanup for history data or per-characteristic caches

## Project Structure

```
lib/
|-- main.dart
|-- models/
|   |-- sensor_data.dart
|   |-- device_info.dart
|   |-- bluetooth_state.dart
|   |-- uuid_config.dart
|   `-- sensor_record.dart
|-- providers/
|   |-- bluetooth_provider.dart
|   |-- sensor_data_provider.dart
|   `-- sensor_recording_provider.dart
|-- services/
|   |-- bluetooth_service.dart
|   |-- uuid_config_service.dart
|   |-- csv_export_service.dart
|   `-- sensor_recording_service.dart
`-- screens/
    |-- home_screen.dart      (Devices / Monitor / Records tabs)
    `-- device_scan_screen.dart
```

The `docs/` directory contains optional static-site assets (for example, GitHub Pages). Keep or publish them when required.

## Tech Stack

- Flutter 3.x / Dart 3.x
- State management: Provider
- BLE library: `flutter_blue_plus`
- Charting: `fl_chart`
- Local storage: `shared_preferences`
- Permissions: `permission_handler`

## Getting Started

```bash
# Check the local Flutter installation
flutter doctor

# Install dependencies
flutter pub get

# Run on a connected device or emulator
flutter run

# Build a release APK (optional)
flutter build apk --release
```

## Usage Guide

### Device Management
1. Open the **Devices** tab and start scanning.
2. Select the target device from the RSSI-sorted list and tap **Connect**.
3. After a successful connection the app returns to the **Monitor** tab automatically.

### Real-Time Monitoring
1. On the **Monitor** tab, tap the gear icon to open the characteristic selector.
2. Choose one or more saved UUID configurations and apply the selection.
3. Tap **Start Listening** to stream notifications and populate charts, KPI cards, and history logs.
4. The layout scrolls vertically so charts and controls remain accessible on compact screens.

### UUID Configuration Management
- **Add**: Use the **New Configuration** button inside the selector dialog, then provide a name, optional service UUID, required characteristic UUID, and notes.
- **Edit**: Tap the edit icon, adjust the fields, and save; changes are applied instantly.
- **Delete**: Tap the delete icon, confirm the action, and the configuration is removed along with any active selection.
- All updates are persisted with `SharedPreferences`, and the selector stays in sync with the monitoring view.

### Data Records and Exports
1. Switch to the **Records** tab to review captured samples grouped by characteristic.
2. Use the play/pause action to start or stop recording. The status card tracks record counts, characteristic coverage, and the latest timestamp.
3. Tap **Export CSV** to preview multi-column data or save it to disk. The dialog summarises record count, characteristic names, destination path, and file size.
4. Use the floating delete button to clear the persisted history when required—the data service resets both storage and UI counters.

## Testing

```bash
flutter test
```
This command runs the unit tests, including coverage for the multi-channel CSV exporter.

## Troubleshooting

| Issue | Resolution |
| ----- | ---------- |
| No devices found | Ensure Bluetooth and location permissions are granted; toggle the system Bluetooth radio and rescan. |
| Frequent disconnects | Confirm the device supports BLE notify and is not already connected to another client. |
| Chart remains empty | Verify that at least one characteristic is selected and listening is active; double-check UUID values. |
| CSV export fails | Check storage permissions and free space, then retry. |

## Release Highlights

- **v1.3.0 (2025-01-17)**  
  - Added CSV copy/save options with file metadata feedback  
  - Made the monitoring page scrollable to eliminate bottom overflow issues  
  - Enabled editing and deleting UUID configurations directly from the selector  

- **v1.2.0 (2024-12-26)**  
  - RSSI-based device sorting and improved connection feedback  
  - Initial CSV export and UUID management features  

- **v1.1.0 (2024-12-25)**  
  - Core BLE connection flow and real-time charts  
  - History logging and Material Design 3 themed UI  

- **v1.0.0 (2024-12-24)**  
  - Project bootstrap  

## Contributing

1. Fork the repository and create a feature branch (`git checkout -b feature/your-change`).  
2. Implement the change, run formatting, and execute any relevant tests.  
3. Commit and push (`git commit -am "feat: add awesome feature"`), then open a pull request.  
4. Provide screenshots or screen recordings for UI-facing updates.  

## License

SmartBLESensor is distributed under the [MIT License](LICENSE). Use, modify, and share it freely.
