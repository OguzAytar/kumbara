import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ayarlar',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        children: [
          _buildSection('Genel', [
            _buildSettingsTile(
              icon: Icons.notifications,
              title: 'Bildirimler',
              subtitle: 'Hatırlatma bildirimleri',
              trailing: Switch(
                value: true, // TODO: Get from provider
                onChanged: (value) {
                  // TODO: Update notification settings
                },
              ),
            ),
            _buildSettingsTile(
              icon: Icons.palette,
              title: 'Tema',
              subtitle: 'Açık tema',
              onTap: () {
                // TODO: Show theme selector
              },
            ),
            _buildSettingsTile(
              icon: Icons.language,
              title: 'Dil',
              subtitle: 'Türkçe',
              onTap: () {
                // TODO: Show language selector
              },
            ),
          ]),
          _buildSection('Veriler', [
            _buildSettingsTile(
              icon: Icons.backup,
              title: 'Verileri Yedekle',
              subtitle: 'Birikimlerinizi yedekleyin',
              onTap: () {
                // TODO: Backup data
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Yedekleme özelliği yakında eklenecek!')));
              },
            ),
            _buildSettingsTile(
              icon: Icons.restore,
              title: 'Verileri Geri Yükle',
              subtitle: 'Yedekten geri yükleyin',
              onTap: () {
                // TODO: Restore data
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Geri yükleme özelliği yakında eklenecek!')));
              },
            ),
            _buildSettingsTile(
              icon: Icons.delete_forever,
              title: 'Tüm Verileri Sil',
              subtitle: 'Dikkat: Bu işlem geri alınamaz',
              textColor: Colors.red,
              onTap: () {
                _showDeleteConfirmationDialog(context);
              },
            ),
          ]),
          _buildSection('Hakkında', [
            _buildSettingsTile(icon: Icons.info, title: 'Sürüm', subtitle: '1.0.0'),
            _buildSettingsTile(
              icon: Icons.help,
              title: 'Yardım & Destek',
              subtitle: 'SSS ve iletişim',
              onTap: () {
                // TODO: Show help screen
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Yardım sayfası yakında eklenecek!')));
              },
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
        ),
        ...children,
      ],
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    Color? textColor,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: (textColor ?? Colors.blue).withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: textColor ?? Colors.blue, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: textColor ?? Colors.black87),
      ),
      subtitle: subtitle != null ? Text(subtitle, style: TextStyle(fontSize: 14, color: Colors.grey.shade600)) : null,
      trailing: trailing ?? (onTap != null ? Icon(Icons.chevron_right, color: Colors.grey.shade400) : null),
      onTap: onTap,
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tüm Verileri Sil'),
          content: const Text(
            'Bu işlem tüm birikimlerinizi ve ayarlarınızı silecektir. Bu işlem geri alınamaz. Devam etmek istediğinizden emin misiniz?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: Delete all data
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Veri silme özelliği yakında eklenecek!'), backgroundColor: Colors.red));
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Sil'),
            ),
          ],
        );
      },
    );
  }
}
