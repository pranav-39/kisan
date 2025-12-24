import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/utils/date_formatter.dart';
import '../../providers/weather_provider.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<WeatherProvider>();
      if (!provider.hasData) {
        provider.loadWeather();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Consumer<WeatherProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.hasError || !provider.hasData) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.cloud_off, size: 64, color: AppColors.error),
                const SizedBox(height: 16),
                Text(provider.errorMessage ?? 'Unable to load weather'),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => provider.loadWeather(forceRefresh: true),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final weather = provider.weather!;

        return RefreshIndicator(
          onRefresh: () => provider.loadWeather(forceRefresh: true),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCurrentWeatherCard(context, weather, localizations),
                const SizedBox(height: 16),
                _buildForecastSection(context, weather, localizations),
                const SizedBox(height: 16),
                _buildFarmingAdviceCard(context, weather, localizations),
                if (weather.advice.alerts.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _buildAlertsSection(context, weather, localizations),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCurrentWeatherCard(
    BuildContext context,
    dynamic weather,
    AppLocalizations? loc,
  ) {
    return Card(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.secondary,
              AppColors.secondaryDark,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.white, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          weather.locationName,
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${weather.current.temperature.round()}°C',
                      style: const TextStyle(
                        fontSize: 56,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      weather.current.condition,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Icon(
                  _getWeatherIcon(weather.current.condition),
                  size: 80,
                  color: Colors.white,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildWeatherMetric(
                  Icons.water_drop,
                  '${weather.current.humidity}%',
                  loc?.humidity ?? 'Humidity',
                ),
                _buildWeatherMetric(
                  Icons.air,
                  '${weather.current.windSpeed.round()} km/h',
                  loc?.wind ?? 'Wind',
                ),
                _buildWeatherMetric(
                  Icons.wb_sunny,
                  '${weather.current.uvIndex}',
                  loc?.uvIndex ?? 'UV Index',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherMetric(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildForecastSection(
    BuildContext context,
    dynamic weather,
    AppLocalizations? loc,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc?.forecast ?? '7-Day Forecast',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: weather.forecast.length,
            itemBuilder: (context, index) {
              final day = weather.forecast[index];
              return _buildForecastDay(context, day, index == 0);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildForecastDay(BuildContext context, dynamic day, bool isToday) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isToday
            ? AppColors.primary.withAlpha(25)
            : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: isToday
            ? Border.all(color: AppColors.primary, width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isToday ? 'Today' : DateFormatter.getShortDayName(day.date),
            style: TextStyle(
              fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
              color: isToday ? AppColors.primary : null,
            ),
          ),
          const SizedBox(height: 8),
          Icon(
            _getWeatherIcon(day.condition),
            size: 28,
            color: isToday ? AppColors.primary : AppColors.secondary,
          ),
          const SizedBox(height: 8),
          Text(
            '${day.tempMax.round()}°',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            '${day.tempMin.round()}°',
            style: TextStyle(
              color: Theme.of(context).textTheme.bodySmall?.color,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFarmingAdviceCard(
    BuildContext context,
    dynamic weather,
    AppLocalizations? loc,
  ) {
    final advice = weather.advice;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.agriculture, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  loc?.farmingAdvice ?? 'Farming Advice',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildAdviceItem(
              context,
              Icons.water,
              loc?.irrigationAdvice ?? 'Irrigation',
              advice.irrigation.recommendation,
              advice.irrigation.shouldIrrigate
                  ? AppColors.success
                  : AppColors.warning,
              'Best time: ${advice.irrigation.bestTime}',
            ),
            const Divider(height: 24),
            _buildAdviceItem(
              context,
              Icons.pest_control,
              loc?.sprayAdvice ?? 'Spray Timing',
              advice.spray.recommendation,
              advice.spray.isSuitable
                  ? AppColors.success
                  : AppColors.warning,
              'Best window: ${advice.spray.bestWindow}',
            ),
            if (advice.generalTips.isNotEmpty) ...[
              const Divider(height: 24),
              Text(
                'General Tips',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              ...advice.generalTips.map((tip) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.lightbulb_outline, 
                        size: 16, color: AppColors.warning),
                    const SizedBox(width: 8),
                    Expanded(child: Text(tip)),
                  ],
                ),
              )),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAdviceItem(
    BuildContext context,
    IconData icon,
    String title,
    String description,
    Color statusColor,
    String subtitle,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: statusColor),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: statusColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(description),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildAlertsSection(
    BuildContext context,
    dynamic weather,
    AppLocalizations? loc,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Weather Alerts',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        ...weather.advice.alerts.map((alert) => Card(
          color: AppColors.error.withAlpha(25),
          child: ListTile(
            leading: const Icon(Icons.warning, color: AppColors.error),
            title: Text(alert.type.toUpperCase()),
            subtitle: Text(alert.message),
          ),
        )),
      ],
    );
  }

  IconData _getWeatherIcon(String condition) {
    final lower = condition.toLowerCase();
    if (lower.contains('sunny') || lower.contains('clear')) {
      return Icons.wb_sunny;
    } else if (lower.contains('partly')) {
      return Icons.wb_cloudy;
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
