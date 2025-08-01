import 'package:bible_wise_admin/provider/comentarios_provider.dart';
import 'package:bible_wise_admin/provider/devocional_provider.dart';
import 'package:bible_wise_admin/screens/comentarios/comentarios_screen.dart';
import 'package:bible_wise_admin/screens/posts/posts_screen.dart';
import 'package:bible_wise_admin/screens/posts/selected_devocional.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DevocionalProvider()),
        ChangeNotifierProvider(create: (context) => ComentariosProvider()),
      ],
      child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BibleWise Admin',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        useMaterial3: true,
        cardColor: const Color.fromRGBO(221, 206, 202, 1)
      ),
      routes: {
        "posts": (context) => const PostsScreen(),
        "comentarios": (context) => const ComentariosScreen()
      },
      onGenerateRoute: (settings) {
        if(settings.name == 'devocional_selected') {
          Map<String, dynamic>? routeArgs = settings.arguments as Map<String, dynamic>?;
          return MaterialPageRoute(builder: (context) => DevocionalSelected(devocional: routeArgs!["devocional"]));
        }
      },
      home: const MyHomePage(title: 'BibleWise Dashboard'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Widget _pushSection(String label, String route) => InkWell(
    onTap: () => Navigator.pushNamed(context, route),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleLarge),
        const Icon(Icons.arrow_forward_ios_rounded)
      ],
    ),
  );

  Widget _containerInfo(String text, IconData icon, int qtd) => Container(
    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.brown,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),),
            const SizedBox(width: 16),
            Icon(icon, color: Colors.white)
          ],
        ),
        const SizedBox(height: 16),
        Text(qtd.toString(), style: const TextStyle(color: Colors.white, fontSize: 20))
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _pushSection('Posts', 'posts'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _containerInfo('Aprovados', Icons.check_circle_outline_rounded, 0),
                _containerInfo('Rejeitados', Icons.close, 0),
              ],
            ),
            const SizedBox(height: 20),
            _containerInfo('Excluídos', Icons.delete, 0),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0, top: 32.0),
              child: _pushSection('Comentários', 'comentarios'),
            ),
            _containerInfo('Excluídos', Icons.chat_bubble, 0),
            const SizedBox(height: 20),
            _containerInfo('Denúncias removidas', Icons.delete, 0),
          ],
        ),
      ),
    );
  }
}
