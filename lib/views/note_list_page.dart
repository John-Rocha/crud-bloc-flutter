import 'package:crud_flutter_bloc/cubit/notes_cubit.dart';
import 'package:crud_flutter_bloc/models/note.dart';
import 'package:crud_flutter_bloc/views/note_edit_page.dart';
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
        title: const Text('Bloc SQLite Crud - Lista de Notas'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: () {
              // excluir todas as notas
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
            },
          ),
        ],
      ),
      body: const _Content(),
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
      return const SizedBox();
    } else if (state is NotesLoading) {
      return const Center(
        child: CircularProgressIndicator.adaptive(),
      );
    } else if (state is NotesLoaded) {
      //a mensagem abaixo aparece se a lista de notas estiver vazia
      if (state.notes!.isEmpty) {
        return const Center(
          child: Text('Não há notas. Clique no botão abaixo para cadastrar.'),
        );
      } else {
        return _NotesList(state.notes);
      }
    } else {
      return const Center(
        child: Text('Erro ao recuperar notas.'),
      );
    }
  }
}

class _NotesList extends StatelessWidget {
  const _NotesList(this.notes, {Key? key}) : super(key: key);
  final List<Note>? notes;
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        for (final note in notes!) ...[
          Padding(
            padding: const EdgeInsets.all(2.5),
            child: ListTile(
              tileColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              title: Text(note.title),
              subtitle: Text(
                note.content,
              ),
              trailing: Wrap(
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          // a nota existente eh enviada como parametro para a
                          // tela de edicao preencher os campos automaticamente
                          builder: (context) => NoteEditPage(note: note),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      // excluir nota atraves do id
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Excluir Nota'),
                          content: const Text('Confirmar operação?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () {
                                context.read<NotesCubit>().deleteNote(note.id!);
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(const SnackBar(
                                    content: Text('Nota excluída com sucesso'),
                                  ));
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
