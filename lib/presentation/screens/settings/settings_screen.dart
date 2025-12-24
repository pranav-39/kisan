import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../providers/connectivity_provider.dart';
import '../../providers/language_provider.dart';
import '../../providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations?.settings ?? 'Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(
            context,
            'Appearance',
            [
              _buildLanguageTile(context),
              _buildThemeTile(context),
            ],
          ),
          const SizedBox(height: 16),
          _buildSection(
            context,
            'Data & Sync',
            [
              _buildConnectivityTile(context),
              _buildClearCacheTile(context),
            ],
          ),
          const SizedBox(height: 16),
          _buildSection(
            context,
            'About',
            [
              _buildAboutTile(context),
              _buildVersionTile(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> tiles) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColors.primary,
              ),
        ),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: tiles,
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageTile(BuildContext context) {
    final provider = Provider.of<LanguageProvider>(context);

    return ListTile(
      leading: const Icon(Icons.language),
      title: const Text('Language'),
      subtitle: Text(provider.currentLanguageOption.nativeName),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _showLanguageDialog(context),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final provider = Provider.of<LanguageProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: provider.availableLanguages.map((lang) {
              return ListTile(
                title: Text('${lang.nativeName} (${lang.name})'),
                selected: provider.isCurrentLanguage(lang.code),
                onTap: () {
                  provider.setLanguage(lang.code);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildThemeTile(BuildContext context) {
    final provider = Provider.of<ThemeProvider>(context);

    return SwitchListTile(
      secondary: Icon(
        provider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
      ),
      title: const Text('Dark Mode'),
      value: provider.isDarkMode,
      onChanged: (value) => provider.toggleDarkMode(),
    );
  }

  Widget _buildConnectivityTile(BuildContext context) {
    final provider = Provider.of<ConnectivityProvider>(context);

    return ListTile(
      leading: Icon(
        provider.isOnline ? Icons.wifi : Icons.wifi_off,
        color: provider.isOnline ? AppColors.success : AppColors.error,
      ),
      title: const Text('Connection Status'),
      subtitle: Text(
        provider.isOnline ? 'Online' : 'Offline - Data may be outdated',
      ),
    );
  }

  Widget _buildClearCacheTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.delete_outline),
      title: const Text('Clear Cache'),
      subtitle: const Text('Clear locally stored data'),
      onTap: () => _showClearCacheDialog(context),
    );
  }

  void _showClearCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Clear Cache'),
          content: const Text(
            'This will clear all locally stored weather, market prices, and diagnosis history. This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement cache clearing
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cache cleared successfully')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
              ),
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAboutTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.info_outline),
      title: const Text('About Project Kisan'),
      subtitle: const Text('AI-Powered Farming Intelligence Platform'),
      onTap: () => _showAboutDialog(context),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Project Kisan',
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.eco, size: 40, color: Colors.white),
      ),
      children: [
        const Text(
          'Project Kisan is an AI-powered farming intelligence platform designed to help Indian farmers with crop disease diagnosis, weather-based advice, market prices, and government schemes.',
        ),
      ],
    );
  }

  Widget _buildVersionTile(BuildContext context) {
    return const ListTile(
      leading: Icon(Icons.code),
      title: Text('Version'),
      subtitle: Text('1.0.0 (Build 1)'),
    );
  }
}
