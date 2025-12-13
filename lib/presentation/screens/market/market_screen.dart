import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../domain/entities/market_entity.dart';
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
      if (!provider.hasData) {
        provider.loadMarketPrices();
      }
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
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              value: provider.selectedCrop,
              decoration: InputDecoration(
                labelText: loc?.selectCrop ?? 'Select Crop',
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: Text('All Crops'),
                ),
                ...provider.availableCrops.map((crop) {
                  return DropdownMenuItem<String>(
                    value: crop,
                    child: Text(crop),
                  );
                }),
              ],
              onChanged: (value) {
                provider.setSelectedCrop(value);
              },
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            onPressed: () => provider.clearFilters(),
            icon: const Icon(Icons.clear_all),
            tooltip: 'Clear filters',
          ),
          IconButton(
            onPressed: () => provider.loadMarketPrices(forceRefresh: true),
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
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: 16),
            Text(provider.errorMessage ?? 'Unable to load market prices'),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => provider.loadMarketPrices(forceRefresh: true),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (provider.prices.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.store_outlined, size: 64, color: AppColors.textSecondaryLight),
            const SizedBox(height: 16),
            const Text('No prices available for selected filters'),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => provider.clearFilters(),
              child: const Text('Clear Filters'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => provider.loadMarketPrices(forceRefresh: true),
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
                    color: _getCropColor(price.cropName).withOpacity(0.1),
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
                            '${price.mandiName}, ${price.state}',
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
                      '₹${price.pricePerQuintal.round()}',
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
                _buildPriceChange(context),
                const SizedBox(width: 16),
                _buildRecommendation(context),
                const Spacer(),
                Text(
                  _formatDate(price.updatedAt),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            if (price.aiInsight.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.auto_awesome,
                      size: 16,
                      color: AppColors.secondary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        price.aiInsight,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPriceChange(BuildContext context) {
    final isUp = price.trend == PriceTrend.up;
    final isDown = price.trend == PriceTrend.down;
    final color = isUp
        ? AppColors.trendUp
        : isDown
            ? AppColors.trendDown
            : AppColors.trendNeutral;
    final icon = isUp
        ? Icons.trending_up
        : isDown
            ? Icons.trending_down
            : Icons.trending_flat;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            '${price.percentChange >= 0 ? '+' : ''}${price.percentChange.toStringAsFixed(1)}%',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendation(BuildContext context) {
    Color color;
    String label;
    IconData icon;

    switch (price.recommendation) {
      case MarketRecommendation.buy:
        color = AppColors.trendUp;
        label = 'BUY';
        icon = Icons.arrow_circle_down;
        break;
      case MarketRecommendation.sell:
        color = AppColors.trendDown;
        label = 'SELL';
        icon = Icons.arrow_circle_up;
        break;
      case MarketRecommendation.hold:
        color = AppColors.warning;
        label = 'HOLD';
        icon = Icons.pause_circle;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
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
