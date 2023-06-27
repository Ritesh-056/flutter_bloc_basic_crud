
import '../model/book.dart';

// States
abstract class BookState {}

class BookStateInitial extends BookState {}

class BookStateLoading extends BookState {}

class BookStateLoaded extends BookState {
  final List<Book> books;

  BookStateLoaded(this.books);
}

class BookStateError extends BookState {
  final String errorMessage;

  BookStateError(this.errorMessage);
}
