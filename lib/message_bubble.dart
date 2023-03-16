import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'message.dart';

class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadiusDirectional.only(
          bottomEnd: Radius.circular(20.0),
          topEnd: Radius.circular(20.0),
          topStart: Radius.circular(20.0),
        ),
      ),
      child: DefaultTextStyle(
        style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  message.author,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 16.0),
                Text(DateFormat(DateFormat.HOUR24_MINUTE)
                    .format(message.createdAt)),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(message.message),
          ],
        ),
      ),
    );
  }
}
