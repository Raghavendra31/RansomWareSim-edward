import 'package:flutter/material.dart';

class InternetDialog extends StatelessWidget {
  final VoidCallback onHttpLinkClick;
  const InternetDialog({required this.onHttpLinkClick, super.key});

  @override
  Widget build(BuildContext context) {
    final links = [
      'https://someRandomsite1.in',
      'https://someRandomsite2.in',
      'https://someRandomsit3.in',
      'http://someRandomsite4.in',
    ];

    return AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.zero,
      content: Container(
        width: MediaQuery.of(context).size.width * 0.6,
        height: MediaQuery.of(context).size.height * 0.4,
        decoration: BoxDecoration(
          color: const Color(0xFF2D2D2D),
          border: Border.all(color: const Color(0xFF00BFFF), width: 2),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              color: const Color(0xFF1E1E1E),
              child: Row(
                children: [
                  const Icon(Icons.public, size: 16),
                  const SizedBox(width: 8),
                  const Text('Internet'),
                  const Spacer(),
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.close, size: 16),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: links.length,
                itemBuilder: (context, index) {
                  final isHttpLink = links[index].startsWith('http://');
                  return InkWell(
                    onTap: isHttpLink ? onHttpLinkClick : null,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      child: Text(
                        links[index],
                        style: TextStyle(
                          color: isHttpLink ? Colors.yellow : Colors.white,
                          fontSize: 14
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}