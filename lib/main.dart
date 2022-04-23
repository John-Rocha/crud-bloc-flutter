import 'package:crud_flutter_bloc/cubit/notes_cubit.dart';
import 'package:crud_flutter_bloc/views/note_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'db/database_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // o repositorio de dados eh instanciado antes do app apresentar a lista de
  // notas, essa instancia eh dependencia do NotesCubit que eh responsavel pelas
  // regras de negocio do aplicativo
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => DatabaseProvider.instance,
      child: BlocProvider(
        create: (context) =>
            NotesCubit(databaseProvider: DatabaseProvider.instance),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Bloc CRUD',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const NoteListPage(),
        ),
      ),
    );
  }
}
