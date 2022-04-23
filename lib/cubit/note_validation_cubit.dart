import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'note_validation_state.dart';

class NoteValidationCubit extends Cubit<NoteValidationState> {
  NoteValidationCubit() : super(const NoteValidating());

  // validar o formulário de edicao da nota
  void validForm(String title, String content) {
    String cubitTitleMessage = '';
    String cubitContentMessage = '';
    bool formInvalid = false;

    if (title == '') {
      formInvalid = true;
      cubitTitleMessage = 'Preencha o título';
    } else {
      cubitTitleMessage = '';
    }

    if (content == '') {
      formInvalid = true;
      cubitContentMessage = 'Preencha o conteúdo';
    } else {
      cubitContentMessage = '';
    }

    if (formInvalid) {
      emit(NoteValidating(
        titleMessage: cubitTitleMessage,
        contentMessage: cubitContentMessage,
      ));
    } else {
      emit(const NoteValidated());
    }
  }
}
