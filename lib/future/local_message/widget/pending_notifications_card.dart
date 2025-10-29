
part of '../home_view.dart';

class _NotificationFormFields extends StatelessWidget {
  const _NotificationFormFields({
    required this.titleController,
    required this.bodyController,
    required this.delayController,
  });
  final TextEditingController titleController;
  final TextEditingController bodyController;
  final TextEditingController delayController;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bildirim Detayları',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Başlık',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value == null || value.isEmpty ? 'Başlık gerekli' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: bodyController,
              decoration: const InputDecoration(
                labelText: 'İçerik',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              validator: (value) =>
                  value == null || value.isEmpty ? 'İçerik gerekli' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: delayController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Gecikme Süresi (Saniye)',
                helperText: 'Zamanlanmış bildirim için gerekli',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Süre gerekli';
                if (int.tryParse(value) == null || int.parse(value) <= 0) {
                  return 'Pozitif bir tam sayı girin';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
