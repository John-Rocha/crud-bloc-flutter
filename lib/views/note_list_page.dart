import 'package:crud_flutter_bloc/cubit/notes_cubit.dart';
import 'package:crud_flutter_bloc/views/note_edit_page.dart';
import 'package:crud_flutter_bloc/views/widgets/note_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NoteListPage extends StatelessWidget {
  const NoteListPage({Key? key}) : super(key: key);

  // o NotesCubit que foi criado e providenciado para o MaterialApp eh recuperado
  // via construtor .value e executa a funcao de buscar as notas,
  // ou seja, novas instancias nao usam o .value, instancias existentes sim
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<NotesCubit>(context)..getNotes(),
      child: const DocumentosView(),
    );
  }
}

class DocumentosView extends StatelessWidget {
  const DocumentosView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes List'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: () {
              // excluir todas as notas
              deleteAllNotes(context);
            },
          ),
        ],
      ),
      body: const NoteContent(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          // como o FAB cria uma nota nova, a nota nao eh parametro recebido
          // na tela de edicao
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NoteEditPage(note: null),
            ),
          );
        },
      ),
    );
  }

  void deleteAllNotes(BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Excluir Todas as Notas'),
        content: const Text('Confirmar operação?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              context.read<NotesCubit>().deleteAllNotes();
              Navigator.pop(context);
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(const SnackBar(
                  content: Text('Notas excluídas com sucesso'),
                ));
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
