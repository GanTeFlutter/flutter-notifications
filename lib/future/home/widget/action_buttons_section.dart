
part of '../home_view.dart';

final class _ActionButtonsSection extends StatelessWidget {
  const _ActionButtonsSection({
    required this.isLoading,
    required this.onInstantSend,
    required this.onSchedule,
    required this.onPeriodic,
    required this.onRefresh,
    required this.onCancelAll,
  });
  final bool isLoading;
  final VoidCallback onInstantSend;
  final VoidCallback onSchedule;
  final VoidCallback onPeriodic;
  final VoidCallback onRefresh;
  final VoidCallback onCancelAll;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Row for Send/Schedule/Periodic
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: isLoading ? null : onInstantSend,
                  icon: const Icon(Icons.send),
                  label: const Text('Anında Gönder'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: isLoading ? null : onSchedule,
                  icon: const Icon(Icons.alarm),
                  label: const Text('Zamanla'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: isLoading ? null : onPeriodic,
            icon: const Icon(Icons.repeat),
            label: const Text('Periyodik Gönder (Her Dakika)'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              backgroundColor: Theme.of(context).colorScheme.secondary,
              foregroundColor: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
          const Divider(height: 32),
          // Row for Refresh/Cancel All
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: isLoading ? null : onRefresh,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Yenile'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: isLoading ? null : onCancelAll,
                  icon: const Icon(Icons.cancel),
                  label: const Text('Tümünü İptal Et'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    foregroundColor: Theme.of(context).colorScheme.error,
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
