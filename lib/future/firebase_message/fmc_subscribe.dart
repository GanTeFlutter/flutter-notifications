import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class TopicSubscriptionScreen extends StatefulWidget {
  const TopicSubscriptionScreen({super.key});

  @override
  State<TopicSubscriptionScreen> createState() =>
      _TopicSubscriptionScreenState();
}

class _TopicSubscriptionScreenState extends State<TopicSubscriptionScreen> {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  //yani tum kullanicilara bildirim gondermek istiyoruz diyelim onu default olarak abone yapiyoruz
  // Konular listesi (GENEL sabit olarak aktif)
  final Map<String, bool> _topics = {
    'genel': true, // varsayılan olarak aktif
    'haberler': false,
    'spor': false,
    'teknoloji': false,
    'eğitim': false,
  };

  @override
  void initState() {
    super.initState();
    _initializeSubscriptions();
  }

  Future<void> _initializeSubscriptions() async {
    // GENEL konusuna her zaman abone ol
    await _messaging.subscribeToTopic('genel');
  }

  Future<void> _toggleSubscription(String topic, bool value) async {
    // GENEL konusuna dokunulamaz
    if (topic == 'genel') return;

 
    // mapi guncelliyoruz
    setState(() => _topics[topic] = value);

    try {
      if (value) {
        await _messaging.subscribeToTopic(topic);
        _showSnackBar('$topic konusuna abone olundu.');
      } else {
        await _messaging.unsubscribeFromTopic(topic);
        _showSnackBar('$topic aboneliği iptal edildi.');
      }
    } on Exception catch (e) {
      _showSnackBar('Bir hata oluştu: $e', isError: true);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: isError ? Colors.red : Colors.green,
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bildirim Konuları'),
      ),
      body: ListView(
        children: _topics.keys.map((topic) {
          final isGenel = topic == 'genel';
          return SwitchListTile(
            title: Text(
              topic.toUpperCase(),
              style: TextStyle(
                fontWeight: isGenel ? FontWeight.bold : FontWeight.normal,
                color: isGenel ? Colors.blue : null,
              ),
            ),
            subtitle: Text(
              isGenel
                  ? 'Tüm kullanıcılara gönderilen bildirimleri içerir (zorunlu).'
                  : '$topic ile ilgili bildirimler',
            ),
            value: _topics[topic]!,
            onChanged: isGenel
                ? null // 'genel' için switch devre dışı
                : (value) => _toggleSubscription(topic, value),
          );
        }).toList(),
      ),
    );
  }
}
