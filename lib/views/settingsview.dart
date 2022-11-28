import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simplenotes/main.dart';
import 'package:simplenotes/views/AuthenticationView.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);
  static final _storage = const FlutterSecureStorage();
  @override
  State<SettingsView> createState() => _SettingsViewState();

  static Future<String?> getAuthState() async {
    // Read value
    String? value = await _storage.read(key: "localAuth");
    return value;
  }

  Future<void> _readAll() async {
    final all = await _storage.readAll();
  }

  Future<void> _deleteAll() async {
    await _storage.deleteAll();
    _readAll();
  }

  Future<void> _addNewItem(String key, String value) async {
    await _storage.write(
      key: key,
      value: value,
    );
    _readAll();
  }

  static Future<void> writeAuthState(String value) async {
    // Write value
    return await _storage.write(key: "localAuth", value: value);
  }
}

class _SettingsViewState extends State<SettingsView> {
  static bool _toggled = HomePage.is_auth_enabled; // Sync with home page;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 163, 217, 237),
      appBar: AppBar(
        title: Text(
          'Settings',
          style: GoogleFonts.sacramento(
              textStyle: const TextStyle(color: Colors.white),
              fontSize: 30,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: SwitchListTile(
            title: const Text("Enable local authentication"),
            subtitle: const Text("Add additional protection to your data"),
            onChanged: (bool value) async {
              if (value == true && await AuthView.authenticateIsAvailable()) {
                await SettingsView.writeAuthState("true");
              } else {
                await SettingsView.writeAuthState("false");
              }
              if (value == true && !await AuthView.authenticateIsAvailable()) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Auth is not available on this device")));
              } else {
                setState(() {
                  _toggled = value;
                });
              }
            },
            value: _toggled,
          ),
        ),
      ),
    );
  }
}
