import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/book.dart';

// Events
abstract class BookEvent {}

class AddBookEvent extends BookEvent {
  final Book book;

  AddBookEvent(this.book);
}

class DeleteBookEvent extends BookEvent {
  final Book book;

  DeleteBookEvent(this.book);
}

class UpdateBookEvent extends BookEvent {
  final Book book;

  UpdateBookEvent(this.book);
}
