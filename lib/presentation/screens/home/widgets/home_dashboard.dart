import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../providers/market_provider.dart';
import '../../../providers/weather_provider.dart';
import '../../diagnosis/diagnosis_screen.dart';
import '../../market/market_screen.dart';
import '../../weather/weather_screen.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  void _loadData() {
    context.read<WeatherProvider>().loadWeather();
    context.read<MarketProvider>().loadMarketPrices();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return RefreshIndicator(
      onRefresh: () async {
        await Future.wait([
          context.read<WeatherProvider>().loadWeather(forceRefresh: true),
          context.read<MarketProvider>().loadMarketPrices(forceRefresh: true),
        ]);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildQuickActions(context, localizations),
            const SizedBox(height: 24),
            _buildWeatherCard(context, localizations),
            const SizedBox(height: 16),
            _buildMarketCard(context, localizations),
            const SizedBox(height: 16),
            _buildTipsCard(context, localizations),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, AppLocalizations? loc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.camera_alt,
                label: loc?.scanCrop ?? 'Scan Crop',
                color: AppColors.primary,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const DiagnosisScreen()),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.cloud,
                label: loc?.weather ?? 'Weather',
                color: AppColors.secondary,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const WeatherScreen()),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.trending_up,
                label: loc?.market ?? 'Market',
                color: AppColors.warning,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const MarketScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWeatherCard(BuildContext context, AppLocalizations? loc) {
    return Consumer<WeatherProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return _buildLoadingCard('Loading weather...');
        }

        if (provider.hasError || !provider.hasData) {
          return _buildErrorCard(
            'Unable to load weather',
            onRetry: () => provider.loadWeather(forceRefresh: true),
          );
        }

        final weather = provider.weather!;
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      loc?.currentWeather ?? 'Current Weather',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      weather.locationName,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(
                      _getWeatherIcon(weather.current.condition),
                      size: 48,
                      color: AppColors.secondary,
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${weather.current.temperature.round()}°C',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Text(
                          weather.current.condition,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('${loc?.humidity ?? 'Humidity'}: ${weather.current.humidity}%'),
                        Text('${loc?.wind ?? 'Wind'}: ${weather.current.windSpeed.round()} km/h'),
                      ],
                    ),
                  ],
                ),
                const Divider(height: 24),
                Text(
                  loc?.farmingAdvice ?? 'Farming Advice',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  weather.advice.irrigation.recommendation,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMarketCard(BuildContext context, AppLocalizations? loc) {
    return Consumer<MarketProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return _buildLoadingCard('Loading market prices...');
        }

        if (provider.hasError || !provider.hasData) {
          return _buildErrorCard(
            'Unable to load market prices',
            onRetry: () => provider.loadMarketPrices(forceRefresh: true),
          );
        }

        final prices = provider.allPrices.take(3).toList();
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      loc?.marketPrices ?? 'Market Prices',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const MarketScreen()),
                        );
                      },
                      child: const Text('View All'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ...prices.map((price) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              price.cropName,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            Text(
                              price.mandiName,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '₹${price.pricePerQuintal.round()}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                price.trend.name == 'up'
                                    ? Icons.arrow_upward
                                    : price.trend.name == 'down'
                                        ? Icons.arrow_downward
                                        : Icons.remove,
                                size: 14,
                                color: price.trend.name == 'up'
                                    ? AppColors.trendUp
                                    : price.trend.name == 'down'
                                        ? AppColors.trendDown
                                        : AppColors.trendNeutral,
                              ),
                              Text(
                                '${price.percentChange.abs().toStringAsFixed(1)}%',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: price.trend.name == 'up'
                                      ? AppColors.trendUp
                                      : price.trend.name == 'down'
                                          ? AppColors.trendDown
                                          : AppColors.trendNeutral,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTipsCard(BuildContext context, AppLocalizations? loc) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.lightbulb_outline, color: AppColors.warning),
                const SizedBox(width: 8),
                Text(
                  'Today\'s Tip',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Based on current weather conditions, avoid pesticide spraying if rain is expected within 4-6 hours. Morning hours (6-10 AM) are ideal for most spray applications.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingCard(String message) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Column(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(message),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorCard(String message, {VoidCallback? onRetry}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.error),
              const SizedBox(height: 16),
              Text(message),
              if (onRetry != null) ...[
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  IconData _getWeatherIcon(String condition) {
    final lower = condition.toLowerCase();
    if (lower.contains('sunny') || lower.contains('clear')) {
      return Icons.wb_sunny;
    } else if (lower.contains('cloud')) {
      return Icons.cloud;
    } else if (lower.contains('rain')) {
      return Icons.water_drop;
    } else if (lower.contains('storm') || lower.contains('thunder')) {
      return Icons.thunderstorm;
    } else {
      return Icons.wb_cloudy;
    }
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withAlpha(25),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withAlpha(77)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
