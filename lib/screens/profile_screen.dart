import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/locale_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Ayarlar sayfasına git
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildProfileHeader(context),
          const SizedBox(height: 24),
          _buildMenuSection(),
          const SizedBox(height: 24),
          _buildSettingsSection(context, themeProvider, localeProvider),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
          child: Icon(
            Icons.person,
            size: 60,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Ayşe Yılmaz',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          'anne@email.com',
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 16),
        OutlinedButton(
          onPressed: () {
            // Profil düzenleme
          },
          child: const Text('Profili Düzenle'),
        ),
      ],
    );
  }

  Widget _buildMenuSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 16),
          child: Text(
            'Menü',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        _buildMenuItem(
          icon: Icons.favorite,
          title: 'Favoriler',
          onTap: () {},
        ),
        _buildMenuItem(
          icon: Icons.notifications,
          title: 'Bildirimler',
          onTap: () {},
        ),
        _buildMenuItem(
          icon: Icons.share,
          title: 'Paylaş',
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildSettingsSection(
    BuildContext context,
    ThemeProvider themeProvider,
    LocaleProvider localeProvider,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 16),
          child: Text(
            'Ayarlar',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        _buildThemeSelector(context, themeProvider),
        _buildLanguageSelector(context, localeProvider),
        _buildMenuItem(
          icon: Icons.privacy_tip,
          title: 'Gizlilik',
          onTap: () {},
        ),
        _buildMenuItem(
          icon: Icons.help,
          title: 'Yardım',
          onTap: () {},
        ),
        _buildMenuItem(
          icon: Icons.logout,
          title: 'Çıkış Yap',
          onTap: () {},
          color: Colors.red,
        ),
      ],
    );
  }

  Widget _buildThemeSelector(
      BuildContext context, ThemeProvider themeProvider) {
    return ExpansionTile(
      leading: const Icon(Icons.dark_mode),
      title: const Text('Tema'),
      children: [
        RadioListTile<ThemeMode>(
          title: const Text('Sistem'),
          value: ThemeMode.system,
          groupValue: themeProvider.themeMode,
          onChanged: (value) {
            if (value != null) themeProvider.setThemeMode(value);
          },
        ),
        RadioListTile<ThemeMode>(
          title: const Text('Açık'),
          value: ThemeMode.light,
          groupValue: themeProvider.themeMode,
          onChanged: (value) {
            if (value != null) themeProvider.setThemeMode(value);
          },
        ),
        RadioListTile<ThemeMode>(
          title: const Text('Koyu'),
          value: ThemeMode.dark,
          groupValue: themeProvider.themeMode,
          onChanged: (value) {
            if (value != null) themeProvider.setThemeMode(value);
          },
        ),
      ],
    );
  }

  Widget _buildLanguageSelector(
    BuildContext context,
    LocaleProvider localeProvider,
  ) {
    return ExpansionTile(
      leading: const Icon(Icons.language),
      title: const Text('Dil'),
      children: [
        for (final locale in LocaleProvider.supportedLocales.entries)
          RadioListTile<String>(
            title: Text(locale.value),
            value: locale.key,
            groupValue: localeProvider.locale.languageCode,
            onChanged: (value) {
              if (value != null) {
                localeProvider.setLocale(Locale(value));
              }
            },
          ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyle(color: color),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
