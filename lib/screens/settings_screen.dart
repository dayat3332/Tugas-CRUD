import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/api_config.dart';
import '../providers/product_provider.dart';
import '../services/api_service.dart';

/// Halaman Pengaturan IP Address (Pendekatan PBO).
/// Mengizinkan pengubahan IP server secara dinamis tanpa mengubah baris kode,
/// serta langsung menguji koneksi ke backend.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final TextEditingController _hostController;
  late final TextEditingController _portController;
  bool _isTesting = false;
  String? _testResult;
  bool _testSuccess = false;

  @override
  void initState() {
    super.initState();
    _hostController = TextEditingController(text: ApiConfig.currentHost);
    _portController =
        TextEditingController(text: ApiConfig.currentPort.toString());
  }

  @override
  void dispose() {
    _hostController.dispose();
    _portController.dispose();
    super.dispose();
  }

  /// Menguji konektivitas ke server backend dengan Dio
  Future<void> _testConnection() async {
    setState(() {
      _isTesting = true;
      _testResult = null;
    });

    final host = _hostController.text.trim();
    final port = int.tryParse(_portController.text.trim()) ?? 80;
    final testUrl = port == 80
        ? 'http://$host/api_produk/read.php'
        : 'http://$host:$port/api_produk/read.php';

    try {
      final dio = ApiService().client;
      final response = await dio.get(
        testUrl,
        options: Options(
          sendTimeout: const Duration(seconds: 4),
          receiveTimeout: const Duration(seconds: 4),
        ),
      );

      setState(() {
        _isTesting = false;
        _testSuccess = response.statusCode == 200;
        _testResult = _testSuccess
            ? 'Koneksi berhasil! Backend merespons status 200 OK.'
            : 'Server merespons kode status: ${response.statusCode}';
      });
    } catch (e) {
      setState(() {
        _isTesting = false;
        _testSuccess = false;
        _testResult = 'Gagal terhubung ke $testUrl: $e';
      });
    }
  }

  /// Menyimpan pengaturan host/IP secara permanen
  Future<void> _saveSettings() async {
    final host = _hostController.text.trim();
    final port = int.tryParse(_portController.text.trim()) ?? 80;

    if (host.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Host / IP Address tidak boleh kosong!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    await ApiConfig.setHost(host, port: port);

    if (mounted) {
      // Refresh produk menggunakan IP baru
      context.read<ProductProvider>().fetchProducts();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Konfigurasi IP berhasil disimpan: ${ApiConfig.baseUrl}'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  /// Mengembalikan IP ke nilai default sistem
  Future<void> _resetToDefault() async {
    await ApiConfig.resetToDefault();
    _hostController.text = ApiConfig.currentHost;
    _portController.text = ApiConfig.currentPort.toString();

    if (mounted) {
      context.read<ProductProvider>().fetchProducts();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('IP dikembalikan ke default'),
          backgroundColor: Colors.blue,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan IP Backend (PBO)'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.hub_outlined, color: theme.colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(
                          'Pendekatan PBO untuk IP Server',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Dengan pendekatan OOP, konfigurasi IP server dipusatkan pada class ApiConfig. Anda dapat mengubah IP kapan saja tanpa mengedit file kode program satu per satu.',
                      style: TextStyle(color: Colors.black87, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _hostController,
              decoration: InputDecoration(
                labelText: 'Host / IP Address',
                hintText: 'Contoh: 10.0.2.2, 192.168.1.10, localhost',
                prefixIcon: const Icon(Icons.wifi),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                helperText: 'Emulator Android: 10.0.2.2 | HP Fisik: IP WiFi Anda',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _portController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Port Web Server',
                hintText: '80 atau 8080',
                prefixIcon: const Icon(Icons.numbers),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ActionChip(
                  avatar: const Icon(Icons.android, size: 16),
                  label: const Text('Emulator (10.0.2.2)'),
                  onPressed: () {
                    _hostController.text = '10.0.2.2';
                    _portController.text = '80';
                  },
                ),
                ActionChip(
                  avatar: const Icon(Icons.computer, size: 16),
                  label: const Text('Localhost (127.0.0.1)'),
                  onPressed: () {
                    _hostController.text = '127.0.0.1';
                    _portController.text = '80';
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Endpoint Aktif Saat Ini:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  const SizedBox(height: 6),
                  Text('• Read:   ${ApiConfig.readEndpoint}',
                      style: const TextStyle(fontSize: 11, fontFamily: 'monospace')),
                  Text('• Create: ${ApiConfig.createEndpoint}',
                      style: const TextStyle(fontSize: 11, fontFamily: 'monospace')),
                  Text('• Edit:   ${ApiConfig.editEndpoint}',
                      style: const TextStyle(fontSize: 11, fontFamily: 'monospace')),
                  Text('• Delete: ${ApiConfig.deleteEndpoint}',
                      style: const TextStyle(fontSize: 11, fontFamily: 'monospace')),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (_testResult != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _testSuccess
                      ? Colors.green.shade50
                      : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _testSuccess
                        ? Colors.green.shade300
                        : Colors.red.shade300,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      _testSuccess
                          ? Icons.check_circle
                          : Icons.error_outline,
                      color: _testSuccess
                          ? Colors.green.shade700
                          : Colors.red.shade700,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _testResult!,
                        style: TextStyle(
                          color: _testSuccess
                              ? Colors.green.shade900
                              : Colors.red.shade900,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            OutlinedButton.icon(
              onPressed: _isTesting ? null : _testConnection,
              icon: _isTesting
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.network_check),
              label: Text(_isTesting ? 'Menguji...' : 'Uji Koneksi Backend'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _saveSettings,
              icon: const Icon(Icons.save),
              label: const Text('Simpan Konfigurasi'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: _resetToDefault,
              icon: const Icon(Icons.refresh),
              label: const Text('Kembalikan ke Default'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
