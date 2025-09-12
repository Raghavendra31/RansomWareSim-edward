import 'package:flutter/material.dart';
import 'defence_option.dart';
import 'defence_checkbox_option.dart';
import 'icon_with_label.dart';
import 'folder_dialog.dart';
import 'internet_dialog.dart';
import 'encryption_utils.dart'; 

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  String _status = 'Idle';
  Set<DefenceOption> _selectedDefences = {DefenceOption.encryption};
  bool _isAttacking = false;
  bool _attackSuccessful = false;
  bool _isFolderALocked = false;

  late AnimationController _controller;
  late List<Map<String, dynamic>> _files;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

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
      _isFolderALocked = true;
    });
    _controller.forward(from: 0.0);
  }

  void _resetSimulation() {
    setState(() {
      _status = 'Idle';
      _selectedDefences = {DefenceOption.encryption};
      _isAttacking = false;
      _attackSuccessful = false;
      _isFolderALocked = false;
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
          return FolderDialog(
            files: _files,
            onToggleEncryption: _toggleFileEncryption,
          );
        },
      );
    }
  }

  void _showFolderBDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FolderDialog(
          files: _files,
          onToggleEncryption: _toggleFileEncryption,
        );
      },
    );
  }

  void _handleHttpLinkClick() {
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
        return InternetDialog(onHttpLinkClick: _handleHttpLinkClick);
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
                                    IconWithLabel(
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
                                    child: IconWithLabel(
                                      icon: Icons.folder_copy,
                                      label: 'Folder B',
                                      isInternetIcon: false,
                                      onTap: _showFolderBDialog,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: IconWithLabel(
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
                                  DefenceCheckboxOption(
                                    title: 'Encryption',
                                    value: DefenceOption.encryption,
                                    isChecked: _selectedDefences.contains(DefenceOption.encryption),
                                    onChanged: (isChecked) => _toggleDefence(DefenceOption.encryption, isChecked),
                                  ),
                                  DefenceCheckboxOption(
                                    title: 'Back-Up',
                                    value: DefenceOption.backup,
                                    isChecked: _selectedDefences.contains(DefenceOption.backup),
                                    onChanged: (isChecked) => _toggleDefence(DefenceOption.backup, isChecked),
                                  ),
                                  DefenceCheckboxOption(
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