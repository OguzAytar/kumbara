import 'package:flutter/material.dart';
import 'package:kumbara/core/providers/settings_provider.dart';
import 'package:kumbara/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class PremiumDialog extends StatelessWidget {
  const PremiumDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Theme.of(context).primaryColor.withOpacity(0.1), Theme.of(context).primaryColor.withOpacity(0.05)],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Premium ikonu ve başlık
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [Colors.amber.shade400, Colors.orange.shade400]),
              ),
              child: const Icon(Icons.workspace_premium, size: 40, color: Colors.white),
            ),
            const SizedBox(height: 16),

            Text(
              AppLocalizations.of(context)!.premiumUpgrade,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
            ),
            const SizedBox(height: 8),

            Text(
              AppLocalizations.of(context)!.premiumDescription,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),

            // Özellikler listesi
            _buildFeatureItem(context, Icons.block, AppLocalizations.of(context)!.removeAds, AppLocalizations.of(context)!.removeAdsDesc),
            const SizedBox(height: 16),

            _buildFeatureItem(
              context,
              Icons.save_alt,
              AppLocalizations.of(context)!.unlimitedSavings,
              AppLocalizations.of(context)!.unlimitedSavingsDesc,
            ),
            const SizedBox(height: 16),

            _buildFeatureItem(
              context,
              Icons.analytics,
              AppLocalizations.of(context)!.advancedAnalytics,
              AppLocalizations.of(context)!.advancedAnalyticsDesc,
            ),
            const SizedBox(height: 16),

            _buildFeatureItem(context, Icons.backup, AppLocalizations.of(context)!.autoBackup, AppLocalizations.of(context)!.autoBackupDesc),
            const SizedBox(height: 32),

            // Fiyat ve buton
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.premiumPrice,
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
                      ),
                      Text(AppLocalizations.of(context)!.perMonth, style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppLocalizations.of(context)!.freeTrial,
                    style: TextStyle(fontSize: 12, color: Colors.green.shade600, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Butonlar
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
                    child: Text(AppLocalizations.of(context)!.later, style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Premium satın alma işlemi
                      Provider.of<SettingsProvider>(context, listen: false).setPremiumStatus(true);
                      Navigator.of(context).pop();
                      _showComingSoonSnackBar(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(AppLocalizations.of(context)!.upgradeToPremium, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(BuildContext context, IconData icon, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Theme.of(context).primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, size: 20, color: Theme.of(context).primaryColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text(description, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
            ],
          ),
        ),
      ],
    );
  }

  void _showComingSoonSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.premiumComingSoon),
        backgroundColor: Theme.of(context).primaryColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
