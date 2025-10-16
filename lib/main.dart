import 'package:flutter/material.dart';
import 'package:patrimonio/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'patrimonio.dart';
import 'paginas principais/pagina_1.dart';
import 'paginas principais/pagina_2.dart';
import 'paginas principais/pagina_3.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF018B7B)),
      ),
      home: const PaginaInicial(),
    );
  }
}

class PaginaInicial extends StatelessWidget {
  const PaginaInicial({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(

        appBar: AppBar(
            title: const Text('Patrimônio Coltec', style: TextStyle(color:Colors.black),),
            backgroundColor: const Color(0xFF018B7B),
        ),

        body: TabBarView(
          children: [
            Pagina1(),
            Pagina2(),
            Pagina3(),
          ],
        ),

        bottomNavigationBar: BottomAppBar(
          child: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.qr_code_2_sharp,)),
              Tab(icon: Icon(Icons.qr_code_scanner_sharp ,)),
              Tab(icon: Icon(Icons.list)),
            ]
          )
        ),
      ),
    );
  }
}
