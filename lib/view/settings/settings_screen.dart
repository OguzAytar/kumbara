import 'package:flutter/material.dart';
import 'package:kumbara/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../core/functions/firebase_analytics_helper.dart';
import 'settings_viewmodel.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();

    // Log screen view
    FirebaseAnalyticsHelper.logScreenView(screenName: 'Settings', screenClass: 'SettingsScreen');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SettingsViewModel>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.settings,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Consumer<SettingsViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: [
              _buildSection(AppLocalizations.of(context)!.general, [
                _buildSettingsTile(
                  icon: Icons.notifications,
                  title: AppLocalizations.of(context)!.notifications,
                  subtitle: AppLocalizations.of(context)!.notificationSubtitle,
                  trailing: Switch(value: viewModel.notificationsEnabled, onChanged: viewModel.toggleNotifications),
                ),
                _buildSettingsTile(
                  icon: Icons.palette,
                  title: AppLocalizations.of(context)!.theme,
                  subtitle: viewModel.themeText(context),
                  onTap: () => viewModel.showThemeSelector(context),
                ),
                _buildSettingsTile(
                  icon: Icons.language,
                  title: AppLocalizations.of(context)!.language,
                  subtitle: viewModel.selectedLanguageText,
                  onTap: () => viewModel.showLanguageSelector(context),
                ),
              ]),
              _buildSection(AppLocalizations.of(context)!.data, [
                _buildSettingsTile(
                  icon: Icons.backup,
                  title: AppLocalizations.of(context)!.backupData,
                  subtitle: AppLocalizations.of(context)!.backupSubtitle,
                  onTap: () => viewModel.backupData(context),
                ),
                _buildSettingsTile(
                  icon: Icons.restore,
                  title: AppLocalizations.of(context)!.restoreData,
                  subtitle: AppLocalizations.of(context)!.restoreSubtitle,
                  onTap: () => viewModel.restoreData(context),
                ),
                _buildSettingsTile(
                  icon: Icons.delete_forever,
                  title: AppLocalizations.of(context)!.deleteAllData,
                  subtitle: AppLocalizations.of(context)!.deleteDataSubtitle,
                  textColor: Colors.red,
                  onTap: () => viewModel.showDeleteConfirmationDialog(context),
                ),
              ]),
              _buildSection(AppLocalizations.of(context)!.about, [
                _buildSettingsTile(icon: Icons.info, title: AppLocalizations.of(context)!.version, subtitle: '1.0.0'),
                _buildSettingsTile(
                  icon: Icons.help,
                  title: AppLocalizations.of(context)!.helpSupport,
                  subtitle: AppLocalizations.of(context)!.helpSubtitle,
                  onTap: () => viewModel.showHelpScreen(context),
                ),
              ]),
            ],
          );
        },
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
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.titleMedium?.color),
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
    return Builder(
      builder: (context) => ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (textColor ?? Theme.of(context).primaryColor).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: textColor ?? Theme.of(context).primaryColor, size: 20),
        ),
        title: Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: textColor ?? Theme.of(context).textTheme.titleMedium?.color),
        ),
        subtitle: subtitle != null
            ? Text(subtitle, style: TextStyle(fontSize: 14, color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7)))
            : null,
        trailing: trailing ?? (onTap != null ? Icon(Icons.chevron_right, color: Theme.of(context).iconTheme.color?.withValues(alpha: 0.5)) : null),
        onTap: onTap,
      ),
    );
  }
}
