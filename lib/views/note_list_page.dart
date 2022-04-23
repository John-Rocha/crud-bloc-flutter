import 'package:crud_flutter_bloc/cubit/notes_cubit.dart';
import 'package:crud_flutter_bloc/models/note.dart';
import 'package:crud_flutter_bloc/views/submission_and_editing_form.dart';
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
      child: const DocumentsView(),
    );
  }
}

class DocumentsView extends StatelessWidget {
  const DocumentsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BLoC SQLite CRUD'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: () {
              // excluir todas as notas
              showDialog<String>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Excluir todas as notas'),
                  content: const Text('Confirmar a operação?'),
                  actions: [
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
                          ..showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Todas as notas excluidas com sucesso!'),
                            ),
                          );
                      },
                      child: const Text('Ok'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: const _Content(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // abrir tela de cadastro
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SubmissionAndEditingForm(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<NotesCubit>().state;
    // a descricao dos estados esta no arquivo notes_state
    // os estados nao tratados aqui sao utilizados na tela de edicao da nota
    // print('notelist ' + state.toString());
    if (state is NotesInitial) {
      return const SizedBox.shrink();
    } else if (state is NotesLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (state is NotesLoaded) {
      //a mensagem abaixo aparece se a lista de notas estiver vazia
      if (state.notes!.isEmpty) {
        return const Center(
          child: Text(
              'Nenhuma nota cadastrada. Clique no botão abaixo para cadastrar.'),
        );
      } else {
        return _NoteList(notes: state.notes);
      }
    } else {
      return const Center(
        child: Text('Erro ao carregar as notas.'),
      );
    }
  }
}

class _NoteList extends StatelessWidget {
  const _NoteList({Key? key, this.notes}) : super(key: key);
  final List<Note>? notes;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes!.length,
      itemBuilder: (context, index) {
        final note = notes![index];
        return Dismissible(
          key: Key('note-${note.id}'),
          onDismissed: (direction) {
            context.read<NotesCubit>().deleteNote(note.id!);
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text('Nota excluida com sucesso!'),
                ),
              );
          },
          child: ListTile(
            title: Text(note.title),
            subtitle: Text(note.content),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // abrir tela de edicao
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SubmissionAndEditingForm(),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
