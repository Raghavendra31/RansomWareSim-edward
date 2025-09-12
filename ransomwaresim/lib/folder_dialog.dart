import 'package:flutter/material.dart';
import 'encryption_utils.dart'; // <-- Add this import

class FolderDialog extends StatefulWidget {
  final List<Map<String, dynamic>> files;
  final Function(int) onToggleEncryption;

  const FolderDialog({
    required this.files,
    required this.onToggleEncryption,
    super.key,
  });

  @override
  State<FolderDialog> createState() => _FolderDialogState();
}

class _FolderDialogState extends State<FolderDialog> {
  // Dummy file contents for simulation
  final Map<String, String> _dummyContents = {
    'xyz.docx': 'This is a Word document.',
    'xyz.png': 'PNG image binary data.',
    'xyz.pptx': 'PowerPoint presentation slides.',
    'xyz.txt': 'This is a plain text file.',
    'xyz.xlsx': 'Excel spreadsheet data.',
  };

  void _showContextMenu(BuildContext context, LongPressStartDetails details, int index) {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject()! as RenderBox;
    final bool isEncrypted = widget.files[index]['isEncrypted'] as bool;

    showMenu(
      context: context,
      position: RelativeRect.fromRect(
        details.globalPosition & const Size(40, 40),
        Offset.zero & overlay.size,
      ),
      items: <PopupMenuEntry>[
        const PopupMenuItem(
          enabled: false,
          child: Text('Copy'),
        ),
        const PopupMenuItem(
          enabled: false,
          child: Text('Paste'),
        ),
        const PopupMenuItem(
          enabled: false,
          child: Text('Cut'),
        ),
        const PopupMenuItem(
          enabled: false,
          child: Text('Move'),
        ),
        PopupMenuItem(
          onTap: () {
            widget.onToggleEncryption(index);
            setState(() {});
          },
          child: Text(isEncrypted ? 'Decrypt' : 'Encrypt'),
        ),
      ],
      color: const Color(0xFF2D2D2D),
    );
  }

  void _showFileContentDialog(BuildContext context, int index) {
    final file = widget.files[index];
    final fileName = file['name'] as String;
    final isEncrypted = file['isEncrypted'] as bool;
    final originalContent = _dummyContents[fileName] ?? 'No content available.';

    // Show encrypted or decrypted content
    final displayContent = isEncrypted
        ? EncryptionUtils.encrypt(originalContent)
        : originalContent;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D2D2D),
        title: Text(fileName),
        content: SingleChildScrollView(
          child: Text(
            displayContent,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.zero,
      content: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        height: MediaQuery.of(context).size.height * 0.6,
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
                  const Icon(Icons.folder, size: 16),
                  const SizedBox(width: 8),
                  const Text('New Folder'),
                  const Spacer(),
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.close, size: 16),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.5))),
              ),
              child: const Row(
                children: [
                  Expanded(flex: 4, child: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(flex: 3, child: Text('Date modified', style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(flex: 3, child: Text('Type', style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(flex: 2, child: Text('Size', style: TextStyle(fontWeight: FontWeight.bold))),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.files.length,
                itemBuilder: (context, index) {
                  final file = widget.files[index];
                  return GestureDetector(
                    onLongPressStart: (details) => _showContextMenu(context, details, index),
                    onTap: () => _showFileContentDialog(context, index), // <-- Add this line
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.3))),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Row(
                              children: [
                                if (file['isEncrypted'] as bool)
                                  const Icon(Icons.check_circle, color: Colors.green, size: 16),
                                if (file['isEncrypted'] as bool) const SizedBox(width: 8),
                                Flexible(child: Text(file['name']! as String, overflow: TextOverflow.ellipsis)),
                              ],
                            ),
                          ),
                          Expanded(flex: 3, child: Text(file['date']! as String, overflow: TextOverflow.ellipsis)),
                          Expanded(flex: 3, child: Text(file['type']! as String, overflow: TextOverflow.ellipsis)),
                          Expanded(flex: 2, child: Text(file['size']! as String, overflow: TextOverflow.ellipsis)),
                        ],
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