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
  Set<DefenceOption> _selectedDefences = {DefenceOption.encryption}; // Changed to a Set for multiple selections
  bool _isAttacking = false;
  bool _attackSuccessful = false;

  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = Tween<Offset>(
      begin: const Offset(1.0, -0.7), // Start near Internet icon
      end: const Offset(-1.0, -0.7), // End near Folder icon
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          // Determine attack outcome based on whether Encryption is selected
          if (_selectedDefences.contains(DefenceOption.encryption)) {
            _status = 'Attack Blocked by Encryption!';
            _attackSuccessful = false;
          } else {
            _status = 'System Compromised!';
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
    if (_isAttacking) return; // Prevent multiple attacks at once

    setState(() {
      _status = 'Attack in progress...';
      _isAttacking = true;
      _attackSuccessful = false; // Reset previous result
    });
    _controller.forward(from: 0.0);
  }

  void _resetSimulation() {
    setState(() {
      _status = 'Idle';
      _selectedDefences = {DefenceOption.encryption}; // Reset to default selection
      _isAttacking = false;
      _attackSuccessful = false;
      _controller.reset();
    });
  }


  @override
  Widget build(BuildContext context) {
    // Define the glowing color for reuse
    const glowColor = Color(0xFF00BFFF);

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E), // Dark background
      body: Padding( // Use Padding directly, removing the centered white card
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              Expanded(
                child: Row(
                  children: [
                    // Main simulation panel
                    Expanded(
                      flex: 3,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF2D2D2D), // Dark panel
                          border: Border.all(color: glowColor, width: 2.0),
                          boxShadow: [
                            BoxShadow(
                              color: glowColor.withAlpha(128), // Updated for deprecation
                              blurRadius: 8,
                              spreadRadius: 2,
                            )
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const Positioned(
                              top: 10,
                              left: 10,
                              child: _IconWithLabel(
                                icon: Icons.folder_open,
                                label: 'Folder',
                                isInternetIcon: false,
                              ),
                            ),
                            const Positioned(
                              top: 10,
                              right: 10,
                              child: _IconWithLabel(
                                icon: Icons.public,
                                label: 'Internet',
                                isInternetIcon: true,
                              ),
                            ),
                             if (_isAttacking)
                              SlideTransition(
                                position: _animation,
                                child: const Icon(
                                  Icons.bug_report,
                                  color: Colors.red,
                                  size: 30,
                                ),
                              ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF2D2D2D), // Corrected to dark panel color
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
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Right sidebar for controls
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2D2D2D), // Dark panel
                                border: Border.all(color: glowColor, width: 2.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: glowColor.withAlpha(128), // Updated for deprecation
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
                          // Action Buttons
                          ElevatedButton(
                            onPressed: _runAttack,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2D2D2D), // Dark button
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              side: const BorderSide(color: Color(0xFFE57373), width: 2), // Red border
                            ).copyWith(
                              elevation: WidgetStateProperty.all(0), // Updated for deprecation
                              shadowColor: WidgetStateProperty.all(const Color(0xFFE57373)), // Glow color
                            ),
                            child: const Text('Attack'),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _resetSimulation,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2D2D2D), // Dark button
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              side: const BorderSide(color: glowColor, width: 2), // Blue border
                            ).copyWith(
                              elevation: WidgetStateProperty.all(0), // Updated for deprecation
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
              // Status Bar
              Text(
                'Status: $_status',
                style: const TextStyle(
                  color: Colors.white, // Changed to white for dark theme
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

// A custom widget for the checkboxes to match the style
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
      onTap: () => onChanged(!isChecked), // Toggles the state
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
                activeColor: const Color(0xFF00BFFF), // Glow color
                checkColor: const Color(0xFF1E1E1E), // Dark color for the checkmark
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

// A helper widget for icons with labels
class _IconWithLabel extends StatelessWidget {
  const _IconWithLabel({required this.icon, required this.label, this.isInternetIcon = false});

  final IconData icon;
  final String label;
  final bool isInternetIcon;

  @override
  Widget build(BuildContext context) {
    const glowColor = Color(0xFF00BFFF);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
           decoration: BoxDecoration(
             border: Border.all(color: glowColor, width: 2),
             // Make internet icon circular, folder icon square
             shape: isInternetIcon ? BoxShape.circle : BoxShape.rectangle,
             boxShadow: [
              BoxShadow(
                color: glowColor.withAlpha(128), // Updated for deprecation
                blurRadius: 5,
              )
             ]
           ),
          child: Icon(icon, color: glowColor, size: 40)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: glowColor)),
      ],
    );
  }
}

