import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/models/ranking_item.dart';
import '../widgets/custom_app_bar.dart';
import 'search_modal.dart';

class RankingDetailScreen extends StatelessWidget {
  final RankingItem item;

  const RankingDetailScreen({super.key, required this.item});

  void _openSearchModal(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const SearchModalScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  // 🚀 FUNCIÓN MÁGICA MAPAS: Abre Apple Maps en iOS y Google Maps en Android
  void _openMap(BuildContext context) async {
    if (item.coordinates == null) return;

    final lat = item.coordinates!.latitude;
    final lng = item.coordinates!.longitude;
    final label = Uri.encodeComponent(item.title);

    Uri mapUrl;

    if (Platform.isIOS) {
      mapUrl = Uri.parse('maps://?ll=$lat,$lng&q=$label');
    } else {
      mapUrl = Uri.parse('geo:$lat,$lng?q=$lat,$lng($label)');
    }

    if (await canLaunchUrl(mapUrl)) {
      await launchUrl(mapUrl, mode: LaunchMode.externalApplication);
    } else {
      final fallbackUrl = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
      );
      if (await canLaunchUrl(fallbackUrl)) {
        await launchUrl(fallbackUrl, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not open map applications.')),
          );
        }
      }
    }
  }

  // 🌐 FUNCIÓN MÁGICA WEB: Abre el navegador nativo del sistema
  void _openWebsite(BuildContext context, String urlString) async {
    final url = Uri.parse(
      urlString.startsWith('http') ? urlString : 'https://$urlString',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch website: $urlString')),
        );
      }
    }
  }

  // 📞 FUNCIÓN MÁGICA TELÉFONO: Abre el marcador telefónico nativo
  void _makeCall(BuildContext context, String phone) async {
    final cleanPhone = phone.replaceAll(RegExp(r'\s+'), '');
    final url = Uri.parse('tel:$cleanPhone');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not dial number: $phone')),
        );
      }
    }
  }

  // 🛠️ FUNCIÓN AUXILIAR: Separa palabras pegadas (CamelCase) y las pone bonitas
  String _formatStatKey(String key) {
    if (key.isEmpty) return '';

    // 1. Añade un espacio antes de cualquier letra mayúscula que esté precedida por una minúscula
    String result = key.replaceAllMapped(
      RegExp(r'(?<=[a-z])(?=[A-Z])'),
      (Match m) => ' ',
    );

    // 2. Reemplaza guiones bajos o guiones por espacios por si la IA los usó
    result = result.replaceAll(RegExp(r'[_.-]'), ' ');

    // 3. Convierte a formato "Title Case" (Primera letra de cada palabra en mayúscula)
    return result
        .split(' ')
        .map((word) {
          if (word.isEmpty) return '';
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasCoordinates = item.coordinates != null;
    final hasLocation =
        item.location != null && item.location!.trim().isNotEmpty;
    final hasWebsite = item.websiteUrl != null && item.websiteUrl!.isNotEmpty;
    final hasPhone = item.phoneNumber != null && item.phoneNumber!.isNotEmpty;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'RankAI',
        onSearchPressed: () => _openSearchModal(context),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Subtítulo (Autor/Marca) & Rating
              Row(
                children: [
                  if (item.subtitle.isNotEmpty)
                    Expanded(
                      child: Text(
                        item.subtitle.toUpperCase(),
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  const SizedBox(width: 12),
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    item.rating.toStringAsFixed(1),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // 2. Título Principal
              Text(
                item.title,
                style: theme.textTheme.headlineLarge?.copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 12),

              // 3. Tags / Etiquetas dinámicas
              if (item.tags.isNotEmpty) ...[
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: item.tags.map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest
                            .withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: theme.colorScheme.outlineVariant.withOpacity(
                            0.4,
                          ),
                        ),
                      ),
                      child: Text(
                        tag,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 12,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
              ],

              // 4. Descripción
              Text(
                item.description,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.4,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 20),

              // 5. Bloques de Destacados (Número de Posición)
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'RANKED ',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '#${item.position}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Fila exclusiva para la ubicación envuelta en condicional estricto
              if (hasLocation) ...[
                const SizedBox(height: 16),
                InkWell(
                  onTap: hasCoordinates ? () => _openMap(context) : null,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'LOCATION',
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.8,
                              ),
                            ),
                            if (hasCoordinates) ...[
                              const SizedBox(width: 4),
                              Icon(
                                Icons.near_me_outlined,
                                size: 12,
                                color: theme.colorScheme.primary,
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.location!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.w500,
                            decoration: hasCoordinates
                                ? TextDecoration.underline
                                : TextDecoration.none,
                            decorationColor: theme.colorScheme.primary
                                .withOpacity(0.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 24),

              // SECCIÓN BOTONES: Acceso directo para Web y Teléfono
              if (hasWebsite || hasPhone) ...[
                Row(
                  children: [
                    if (hasWebsite)
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () =>
                              _openWebsite(context, item.websiteUrl!),
                          icon: const Icon(Icons.language, size: 18),
                          label: const Text(
                            'Visit Website',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    if (hasWebsite && hasPhone) const SizedBox(width: 12),
                    if (hasPhone)
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () =>
                              _makeCall(context, item.phoneNumber!),
                          icon: const Icon(Icons.phone, size: 18),
                          label: const Text(
                            'Call Now',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 24),
              ],

              // 6. Sección de Especificaciones Dinámicas (KeyStats)
              if (item.keyStats.isNotEmpty) ...[
                Text(
                  'Key Statistics',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  elevation: 0,
                  color: theme.colorScheme.surfaceContainerLow,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: item.keyStats.entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _formatStatKey(
                                  entry.key,
                                ), // 🚀 APLICADA LA FUNCIÓN MÁGICA AQUÍ
                                style: TextStyle(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              Text(
                                entry.value,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // 8. Tarjeta de "Ranking Analysis"
              if (item.rankingCriteria.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.auto_awesome,
                            color: Colors.white,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Ranking Analysis',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ...item.rankingCriteria.map((criterion) {
                        final isLast = item.rankingCriteria.last == criterion;
                        return Padding(
                          padding: EdgeInsets.only(bottom: isLast ? 0.0 : 16.0),
                          child: _buildAnalysisRow(
                            criterion.name,
                            criterion.reason,
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnalysisRow(String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 2.0),
          child: Icon(Icons.verified_outlined, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontSize: 13,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
