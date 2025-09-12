import 'package:flutter/material.dart';

void main() {
  runApp(const SecuritySimApp());
}

class SecuritySimApp extends StatelessWidget {
  const SecuritySimApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Security Simulator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark, // Using the dark theme
        fontFamily: 'Inter',
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

// To manage the state of the selected defence and status text
enum DefenceOption { encryption, backup, fraudLink }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin { // Add mixin for animation
  String _status = 'Idle';
  Set<DefenceOption> _selectedDefences = {DefenceOption.encryption};
  bool _isAttacking = false;
  bool _attackSuccessful = false;
  bool _isFolderALocked = false;

  late AnimationController _controller;
  
  // State for the files in Folder A is now managed here
  late List<Map<String, dynamic>> _files;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Initialize the file data here
    _files = [
      {'name': 'xyz.docx', 'date': '9/12/2025 7:18 PM', 'type': 'Microsoft Word D...', 'size': '15 KB', 'isEncrypted': false},
      {'name': 'xyz.png', 'date': '9/12/2025 7:18 PM', 'type': 'PNG File', 'size': '102 KB', 'isEncrypted': false},
      {'name': 'xyz.pptx', 'date': '9/12/2025 7:18 PM', 'type': 'Microsoft PowerP...', 'size': '2 MB', 'isEncrypted': false},
      {'name': 'xyz.txt', 'date': '9/12/2025 7:18 PM', 'type': 'Text Document', 'size': '1 KB', 'isEncrypted': false},
      {'name': 'xyz.xlsx', 'date': '9/12/2025 7:18 PM', 'type': 'Microsoft Excel W...', 'size': '24 KB', 'isEncrypted': false},
    ];

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          // Attack outcome is based on encryption defence, but folder lock is separate
          if (_selectedDefences.contains(DefenceOption.encryption)) {
            _status = 'Ransomware attack blocked by file encryption!';
            _attackSuccessful = false;
          } else {
            _status = 'System Compromised! Files are locked.';
            _attackSuccessful = true;
          }
          _isAttacking = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleDefence(DefenceOption option, bool? isChecked) {
    setState(() {
      if (isChecked == true) {
        _selectedDefences.add(option);
      } else {
        _selectedDefences.remove(option);
      }
    });
  }

  void _runAttack() {
    if (_isAttacking) return;

    setState(() {
      _status = 'Attack in progress...';
      _isAttacking = true;
      _attackSuccessful = false;
      _isFolderALocked = true; // Lock Folder A when an attack starts
    });
    _controller.forward(from: 0.0);
  }

  void _resetSimulation() {
    setState(() {
      _status = 'Idle';
      _selectedDefences = {DefenceOption.encryption};
      _isAttacking = false;
      _attackSuccessful = false;
      _isFolderALocked = false; // Unlock Folder A
      _controller.reset();
      for (var file in _files) {
        file['isEncrypted'] = false;
      }
    });
  }
  
  void _toggleFileEncryption(int index) {
    setState(() {
      final isEncrypted = _files[index]['isEncrypted'] as bool;
      _files[index]['isEncrypted'] = !isEncrypted;
    });
  }

  void _showRansomwareDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D2D2D),
        title: const Text('Access Denied'),
        content: const Text("Hello, I'm ZYX. If you want access to your folder, you need to pay me \$XXXX."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showFraudLinkWarningDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D2D2D),
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.yellow),
            SizedBox(width: 10),
            Text('Warning'),
          ],
        ),
        content: const Text("The clicked link is not secure. Potential threat contained."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showFolderDialog() {
    if (_isFolderALocked) {
      _showRansomwareDialog();
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return _FolderDialog(
            files: _files,
            onToggleEncryption: _toggleFileEncryption,
          );
        },
      );
    }
  }

  void _showFolderBDialog() {
    // Folder B is the backup and is never locked
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _FolderDialog(
          files: _files, // It's an exact copy
          onToggleEncryption: _toggleFileEncryption,
        );
      },
    );
  }

  void _handleHttpLinkClick() {
    // Close the internet dialog first
    Navigator.of(context).pop();

    if (_selectedDefences.contains(DefenceOption.fraudLink)) {
        _showFraudLinkWarningDialog();
    } else {
        _runAttack();
    }
  }

  void _showInternetDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _InternetDialog(onHttpLinkClick: _handleHttpLinkClick);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const glowColor = Color(0xFF00BFFF);

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF2D2D2D),
                          border: Border.all(color: glowColor, width: 2.0),
                          boxShadow: [
                            BoxShadow(
                              color: glowColor.withAlpha(128),
                              blurRadius: 8,
                              spreadRadius: 2,
                            )
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned(
                              top: 10,
                              left: 10,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      _IconWithLabel(
                                        icon: Icons.folder_open,
                                        label: 'Folder A',
                                        isInternetIcon: false,
                                        onTap: _showFolderDialog,
                                      ),
                                      if (_selectedDefences.contains(DefenceOption.encryption))
                                        const Positioned(
                                          top: -5,
                                          right: -5,
                                          child: Icon(Icons.check_circle, color: Colors.green, size: 20),
                                        ),
                                      if (_isFolderALocked)
                                        const Positioned(
                                          top: -5,
                                          left: -5,
                                          child: Icon(Icons.cancel, color: Colors.red, size: 20),
                                        ),
                                    ],
                                  ),
                                  if (_selectedDefences.contains(DefenceOption.backup))
                                    Padding(
                                      padding: const EdgeInsets.only(top: 16.0),
                                      child: _IconWithLabel(
                                        icon: Icons.folder_copy,
                                        label: 'Folder B',
                                        isInternetIcon: false,
                                        onTap: _showFolderBDialog,
                                      ),
                                    ),
                                ],
                              )
                            ),
                            Positioned(
                              top: 10,
                              right: 10,
                              child: _IconWithLabel(
                                icon: Icons.public,
                                label: 'Internet',
                                isInternetIcon: true,
                                onTap: _showInternetDialog,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF2D2D2D),
                                  border: Border(
                                    top: BorderSide(color: glowColor, width: 2.0),
                                  ),
                                ),
                                child: Icon(
                                  _attackSuccessful
                                      ? Icons.sentiment_very_dissatisfied
                                      : Icons.sentiment_satisfied_alt,
                                  color: _attackSuccessful ? Colors.red : glowColor,
                                ),
                              ),
                            ),
                             if (_isAttacking)
                              const Center(
                                child: Icon(
                                  Icons.bug_report,
                                  color: Colors.red,
                                  size: 50,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2D2D2D),
                                border: Border.all(color: glowColor, width: 2.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: glowColor.withAlpha(128),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  )
                                ],
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Defences',
                                      style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  _DefenceCheckboxOption(
                                    title: 'Encryption',
                                    value: DefenceOption.encryption,
                                    isChecked: _selectedDefences.contains(DefenceOption.encryption),
                                    onChanged: (isChecked) => _toggleDefence(DefenceOption.encryption, isChecked),
                                  ),
                                  _DefenceCheckboxOption(
                                    title: 'Back-Up',
                                    value: DefenceOption.backup,
                                    isChecked: _selectedDefences.contains(DefenceOption.backup),
                                    onChanged: (isChecked) => _toggleDefence(DefenceOption.backup, isChecked),
                                  ),
                                  _DefenceCheckboxOption(
                                    title: 'Fraud Link Detection',
                                    value: DefenceOption.fraudLink,
                                    isChecked: _selectedDefences.contains(DefenceOption.fraudLink),
                                    onChanged: (isChecked) => _toggleDefence(DefenceOption.fraudLink, isChecked),
                                  ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _runAttack,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2D2D2D),
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              side: const BorderSide(color: Color(0xFFE57373), width: 2),
                            ).copyWith(
                              elevation: WidgetStateProperty.all(0),
                              shadowColor: WidgetStateProperty.all(const Color(0xFFE57373)),
                            ),
                            child: const Text('Attack'),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _resetSimulation,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2D2D2D),
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              side: const BorderSide(color: glowColor, width: 2),
                            ).copyWith(
                              elevation: WidgetStateProperty.all(0),
                              shadowColor: WidgetStateProperty.all(glowColor),
                            ),
                            child: const Text('Reset'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Status: $_status',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      
    );
  }
}

class _DefenceCheckboxOption extends StatelessWidget {
  const _DefenceCheckboxOption({
    required this.title,
    required this.value,
    required this.isChecked,
    required this.onChanged,
  });

  final String title;
  final DefenceOption value;
  final bool isChecked;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!isChecked),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: isChecked,
                onChanged: onChanged,
                activeColor: const Color(0xFF00BFFF),
                checkColor: const Color(0xFF1E1E1E),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconWithLabel extends StatelessWidget {
  const _IconWithLabel({
    required this.icon,
    required this.label,
    this.isInternetIcon = false,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isInternetIcon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    const glowColor = Color(0xFF00BFFF);
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
             decoration: BoxDecoration(
               border: Border.all(color: glowColor, width: 2),
               shape: isInternetIcon ? BoxShape.circle : BoxShape.rectangle,
               boxShadow: [
                BoxShadow(
                  color: glowColor.withAlpha(128),
                  blurRadius: 5,
                )
               ]
             ),
            child: Icon(icon, color: glowColor, size: 40)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: glowColor)),
        ],
      ),
    );
  }
}

class _FolderDialog extends StatefulWidget {
  final List<Map<String, dynamic>> files;
  final Function(int) onToggleEncryption;

  const _FolderDialog({
    required this.files,
    required this.onToggleEncryption,
  });

  @override
  State<_FolderDialog> createState() => _FolderDialogState();
}

class _FolderDialogState extends State<_FolderDialog> {

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

class _InternetDialog extends StatelessWidget {
  final VoidCallback onHttpLinkClick;
  const _InternetDialog({required this.onHttpLinkClick});

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

