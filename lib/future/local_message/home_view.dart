import 'package:flutter/material.dart';
import 'package:flutter_notifications/future/local_message/mixin/home_view_mixin.dart';

part 'widget/action_buttons_section.dart';
part 'widget/notification_form_fields.dart';
part 'widget/pending_notifications_card.dart';
part 'widget/custom_appbar.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with HomeViewMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _CustomAppBar(
        title: 'Bildirim Yönetimi',
        tooltip: 'Yenile',
        onPressed: isLoading ? null : updatePendingNotifications,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _PendingNotificationsCard(info: pendingNotificationsInfo),
            const SizedBox(height: 24),
            _NotificationFormFields(
              titleController: titleController,
              bodyController: bodyController,
              delayController: delayController,
            ),
            const SizedBox(height: 24),
            _ActionButtonsSection(
              isLoading: isLoading,
              onInstantSend: sendInstantNotification,
              onSchedule: scheduleNotification,
              onPeriodic: sendPeriodicNotification,
              onRefresh: updatePendingNotifications,
              onCancelAll: cancelAllNotifications,
            ),
          ],
        ),
      ),
    );
  }
}
