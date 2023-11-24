import 'package:bloc_crud/bloc/book_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/book_bloc.dart';
import 'bloc/book_event.dart';
import 'model/book.dart';

class BlocPage extends StatefulWidget {
  const BlocPage({Key? key}) : super(key: key);

  @override
  State<BlocPage> createState() => _BlocPageState();
}

class _BlocPageState extends State<BlocPage> {
  int counter = 0;
  final bloc = BookBloc();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: BlocProvider(
        create: (context) => bloc,
        child: BlocBuilder<BookBloc, BookState>(
          builder: (context, state) {
            if (state is BookStateInitial) {
              return const Center(
                child: Text('Empty Books!'),
              );
            }
            if (state is BookStateLoading) {
              return const  Center(
                child: Text('Empty Books!'),
              );
            }

            if (state is BookStateLoaded) {
              return state.books.isNotEmpty
                  ? _buildItem(state.books, size)
                  : const Center(
                      child: Text('Empty Books!'),
                    );
            }
            if (state is BookStateError) {
              return Center(
                  child: Text(
                state.errorMessage,
              ));
            }
            return SizedBox();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (_) => getItemForm(context),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildItem(List<Book> books, Size size) {
    return SizedBox(
      height: size.height,
      width: size.width,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return ListTile(
            leading: Text(book.bookId.toString()),
            title: Text(book.name!),
            subtitle: Text(book.authorName!),
            trailing: Wrap(
              children: [
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (_) =>
                          getItemForm(context, book: book, isEditing: true),
                    );
                  },
                  icon: const Icon(
                    Icons.edit,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    bloc.add(DeleteBookEvent(book));
                  },
                  icon: const Icon(
                    Icons.delete,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget getItemForm(BuildContext context,
      {bool isEditing = false, Book? book}) {
    final TextEditingController bookName =
        TextEditingController(text: isEditing ? book!.name : '');
    final TextEditingController bookAuthor =
        TextEditingController(text: isEditing ? book!.authorName : '');

    return SingleChildScrollView(
      child: SizedBox(
        height: 600,
        child: Column(
          children: [
            SizedBox(
              height: 70,
              child: TextFormField(
                controller: bookName,
              ),
            ),
            SizedBox(
              height: 70,
              child: TextFormField(
                controller: bookAuthor,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Book _book;
                if (!isEditing) {
                  setState(() {
                    counter++;
                  });
                  _book = Book(
                    bookId: counter,
                    name: bookName.text,
                    authorName: bookAuthor.text,
                  );
                  bloc.add(AddBookEvent(_book));
                } else {
                  _book = Book(
                      bookId: book!.bookId,
                      name: bookName.text,
                      authorName: bookAuthor.text);
                  bloc.add(UpdateBookEvent(_book));
                }
                Navigator.of(context).pop();
              },
              child: Text(isEditing ? 'Update' : 'Add'),
            ),
          ],
        ),
      ),
    );
  }
}
