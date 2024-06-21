import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/book.dart'; // Import model book
import '../../ui/books/books_manager.dart'; // Import BooksManager
import '../shared/app_drawer.dart';
import 'book_detail_screen.dart';
import 'searchresult_screen.dart';

class FindBookScreen extends StatelessWidget {
  static const routeName = '/search';

  const FindBookScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _searchBooks(String searchText, BuildContext context) async {
      try {
        final booksManager = Provider.of<BooksManager>(context, listen: false);
        final List<Book> searchResult =
            await booksManager.searchBooksByName(searchText);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                SearchResultScreen(searchResult: searchResult),
          ),
        );
      } catch (e) {
        print(e);
      }
    }

    TextEditingController _searchController = TextEditingController();

    void _onSearchButtonPressed() {
      String searchText = _searchController.text;
      _searchBooks(searchText, context);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Tìm Kiếm Sách'),
      ),
      drawer: const AppDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Tìm kiếm',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Tìm kiếm tên sách',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                // IconButton(
                //   icon: Icon(Icons.search),
                //   onPressed: _onSearchButtonPressed,
                // ),
                ElevatedButton(
                  onPressed: _onSearchButtonPressed,
                  child: Text('Tìm kiếm'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class SearchResultScreen extends StatelessWidget {
  final List<Book> searchResult;

  const SearchResultScreen({Key? key, required this.searchResult})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kết quả tìm kiếm'),
      ),
      body: (searchResult.isEmpty)
          ? Center(
        child: Text(
          'Không Tìm Thấy Sách',
          style: TextStyle(fontSize: 28),
        ),
      )
          : ListView.builder(
        itemCount: searchResult.length,
        itemBuilder: (context, index) {
          final book = searchResult[index];
          return _buildBookListItem(context, book);
        },
      ),
    );
  }

  Widget _buildBookListItem(BuildContext context, Book book) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 4,
        child: ListTile(
          contentPadding: EdgeInsets.all(12),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              book.imageUrl,
              width: 80,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(
            book.title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            'Tác giả: ${book.author}',
            style: TextStyle(fontSize: 16),
          ),
          onTap: () {
            Navigator.of(context).pushNamed(
              BookDetailScreen.routeName,
              arguments: book.id,
            );
          },

        ),
      ),
    );
  }
}
