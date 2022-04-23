import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:crud_flutter_bloc/db/database_provider.dart';
import 'package:crud_flutter_bloc/models/note.dart';

part 'notes_state.dart';

class NotesCubit extends Cubit<NotesState> {
  NotesCubit({
    required DatabaseProvider databaseProvider,
  })  : _databaseProvider = databaseProvider,
        super(const NotesInitial());

  // instancia do banco de dados sqlite
  final DatabaseProvider _databaseProvider;

  // busca todas as notas
  Future<void> getNotes() async {
    emit(const NotesLoading());
    try {
      final notes = await _databaseProvider.getNotes();
      emit(NotesLoaded(notes: notes));
    } on Exception {
      emit(const NotesFailure());
    }
  }

  // excluir uma nota através do id
  Future<void> deleteNote(int id) async {
    emit(const NotesLoading());
    await Future.delayed(const Duration(seconds: 2));
    try {
      await _databaseProvider.deleteNote(id);
      getNotes();
    } on Exception {
      emit(const NotesFailure());
    }
  }

  // excluir todas as notas
  Future<void> deleteAllNotes() async {
    emit(const NotesLoading());
    await Future.delayed(const Duration(seconds: 2));
    try {
      await _databaseProvider.deleteAllNotes();
      getNotes();
    } on Exception {
      emit(const NotesFailure());
    }
  }

  // salvar nota
  Future<void> saveNote(int? id, String title, String content) async {
    Note editMode = Note(id: id, title: title, content: content);
    emit(const NotesLoading());
    await Future.delayed(const Duration(seconds: 2));
    try {
      //se o metodo nao recebeu um id a nota sera incluida, caso contrario
      //a nota existente sera atualizada pelo id
      if (id == null) {
        editMode = await _databaseProvider.saveNote(editMode);
      } else {
        editMode = await _databaseProvider.updateNote(editMode);
      }
      emit(const NotesSuccess());
      // getNotes();
    } on Exception {
      emit(const NotesFailure());
    }
  }
}
