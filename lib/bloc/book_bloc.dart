import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/book.dart';
import 'book_event.dart';
import 'book_state.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  List<Book> books = [];

  BookBloc() : super(BookStateInitial()) {
    on<AddBookEvent>(_addBookEvent);
    on<DeleteBookEvent>(_deleteBookEvent);
    on<UpdateBookEvent>(_updateBookEvent);
  }

  Future<void> _addBookEvent(
      AddBookEvent event, Emitter<BookState> emit) async {
    try {
      books.add(event.book);
      emit(BookStateLoaded(List.from(books)));
    } catch (ex) {
      emit(BookStateError(ex.toString()));
    }
  }

  Future<void> _deleteBookEvent(
      DeleteBookEvent event, Emitter<BookState> emit) async {
    try {
      //delete
      books.remove(event.book);
      emit(BookStateLoaded(List.from(books)));
    } catch (ex) {
      emit(BookStateError(ex.toString()));
    }
  }

  Future<void> _updateBookEvent(
      UpdateBookEvent event, Emitter<BookState> emit) async {
    try {
      //update
      final index =
          books.indexWhere((book) => book.bookId == event.book.bookId);
      if (index >= 0) {
        books[index] = event.book;
        emit(BookStateLoaded(List.from(books)));
      }
    } catch (ex) {
      emit(BookStateError(ex.toString()));
    }
  }
}
