import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../domain/entities/market_price_entity.dart';
import '../../providers/market_provider.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<MarketProvider>();
      provider.loadMarketPrices();
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Consumer<MarketProvider>(
      builder: (context, provider, child) {
        return Column(
          children: [
            _buildFilters(context, provider, localizations),
            Expanded(
              child: _buildContent(context, provider, localizations),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFilters(
    BuildContext context,
    MarketProvider provider,
    AppLocalizations? loc,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              initialValue: provider.selectedCrop,
              decoration: InputDecoration(
                labelText: loc?.selectCrop ?? 'Select Crop',
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items: const [
                DropdownMenuItem<String>(
                  value: null,
                  child: Text('All Crops'),
                ),
              ],
              onChanged: (value) {
                provider.setSelectedCrop(value);
              },
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            onPressed: () => provider.loadMarketPrices(),
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    MarketProvider provider,
    AppLocalizations? loc,
  ) {
    if (provider.state == MarketLoadingState.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.state == MarketLoadingState.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: 16),
            Text(provider.errorMessage ?? 'Unable to load market prices'),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => provider.loadMarketPrices(),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (provider.prices.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.store_outlined, size: 64, color: AppColors.textSecondaryLight),
            SizedBox(height: 16),
            Text('No prices available for selected filters'),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => provider.loadMarketPrices(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: provider.prices.length,
        itemBuilder: (context, index) {
          return _MarketPriceCard(price: provider.prices[index]);
        },
      ),
    );
  }
}

class _MarketPriceCard extends StatelessWidget {
  final MarketPriceEntity price;

  const _MarketPriceCard({required this.price});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _getCropColor(price.cropName).withAlpha(25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.grass,
                    color: _getCropColor(price.cropName),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        price.cropName,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Row(
                        children: [
                          const Icon(Icons.store, size: 14, color: AppColors.textSecondaryLight),
                          const SizedBox(width: 4),
                          Text(
                            price.marketName,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₹${price.modalPrice.round()}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'per quintal',
                      style: TextStyle(fontSize: 10, color: AppColors.textSecondaryLight),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                const Spacer(),
                Text(
                  _formatDate(price.lastUpdated),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  Color _getCropColor(String cropName) {
    switch (cropName.toLowerCase()) {
      case 'wheat':
        return AppColors.cropWheat;
      case 'rice':
        return AppColors.cropRice;
      case 'cotton':
        return AppColors.primary;
      case 'tomato':
        return AppColors.cropTomato;
      case 'potato':
        return AppColors.cropPotato;
      default:
        return AppColors.primary;
    }
  }
}
