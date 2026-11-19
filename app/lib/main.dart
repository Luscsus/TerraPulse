import 'package:material_ui/material_ui.dart';

void main() {
  runApp(const TerraPulseApp());
}

class TerraPulseApp extends StatelessWidget {
  const TerraPulseApp({super.key});

  static const Color _botanicalGreen = Color(0xFF006037);
  static const Color _softCanvas = Color(0xFFF9F9FF);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TerraPulse',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: .fromSeed(
          seedColor: _botanicalGreen,
          surface: _softCanvas,
        ),
      ),
      home: const EmptyGardenPlaceholderPage(),
    );
  }
}

class EmptyGardenPlaceholderPage extends StatelessWidget {
  const EmptyGardenPlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('TerraPulse'),
        centerTitle: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: .center,
            children: [
              Icon(
                Icons.eco_outlined,
                size: 72,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Your garden is empty',
                style: theme.textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Connect your first SOILSENS-V5W sensor to bring your virtual garden to life.',
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: null,
                icon: const Icon(Icons.add),
                label: const Text('Add Your First Plant'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
