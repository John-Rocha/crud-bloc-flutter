import 'package:crud_flutter_bloc/cubit/notes_cubit.dart';
import 'package:crud_flutter_bloc/models/note.dart';
import 'package:crud_flutter_bloc/views/note_edit_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NoteContent extends StatelessWidget {
  const NoteContent({Key? key}) : super(key: key);

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
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.grey,
                    ),
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
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
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
