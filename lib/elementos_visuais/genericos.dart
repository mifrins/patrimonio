import 'package:flutter/material.dart';

class AppBarPadrao extends StatelessWidget implements PreferredSizeWidget {
  final String texto;
  const AppBarPadrao({required this.texto});
  
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Novo processo',
      style: TextStyle(color:Colors.black),),
      backgroundColor: Theme.of(context).colorScheme.primary,
    );
  }

  // Usar tamanho padrão de appbar
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class Rolagem extends StatelessWidget{
  final Widget child;
  const Rolagem({required this.child});
  @override
  Widget build(BuildContext context) {
    return Expanded(child: ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: SingleChildScrollView(
        child:child
      )
    ));
  }
}