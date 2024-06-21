import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/book.dart';
import '../shared/dialog_utils.dart';
import 'books_manager.dart';

class EditBookScreen extends StatefulWidget {
  static const routeName = '/edit-book';

  EditBookScreen(
    Book? book, {
    super.key,
  }) {
    if (book == null) {
      this.book = Book(
        id: null,
        title: '',
        price: 0,
        quantity: 0,
        author: '',
        description: '',
        category: '',
        imageUrl: '',
      );
    } else {
      this.book = book;
    }
  }
  late final Book book;
  @override
  State<EditBookScreen> createState() => _EditBookScreenState();
}

class _EditBookScreenState extends State<EditBookScreen> {
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _editForm = GlobalKey<FormState>();
  late Book _editedBook;
  var _isLoading = false;
  bool _isValidImageUrl(String value) {
    return (value.startsWith('http') || value.startsWith('https')) &&
        (value.endsWith('.png') ||
            value.endsWith('.jpg') ||
            value.endsWith('.jpeg'));
  }

//khởi tạo biến
  @override
  void initState() {
    _imageUrlFocusNode.addListener(() {
      if (!_imageUrlFocusNode.hasFocus) {
        if (!_isValidImageUrl(_imageUrlController.text)) {
          return;
        }
        setState(() {});
      }
    });
    _editedBook = widget.book;
    _imageUrlController.text = _editedBook.imageUrl;
    super.initState();
  }

  // giải phóng biến
  @override
  void dispose() {
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _editForm.currentState!.validate();
    if (!isValid) {
      return;
    }
    _editForm.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    try {
      final booksManager = context.read<BooksManager>();
      if (_editedBook.id != null) {
        await booksManager.updateBook(_editedBook);
      } else {
        await booksManager.addBook(_editedBook);
      }
    } catch (error) {
      if (mounted) {
        await showErrorDialog(context, 'Something went wrong.');
      }
    }

    setState(() {
      _isLoading = false;
    });
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
        _editedBook.id == null ? 'Thêm Sách' : 'Chỉnh Sửa Sách',
          textAlign: TextAlign.center,

        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _editForm,
                child: ListView(
                  children: <Widget>[
                    _buildTitleField(),
                    _buildPriceField(),
                    _buildQuantityField(),
                    _buildDescriptionField(),
                    _buildAuthorField(),
                    _buildCategoryField(),
                    _buildBookPreview(),
                  ],
                ),
              ),
            ),
    );
  }

  TextFormField _buildTitleField() {
    return TextFormField(
      initialValue: _editedBook.title,
      decoration: const InputDecoration(labelText: 'Tên Truyện'),
      textInputAction: TextInputAction.next,
      autofocus: true,

      validator: (value) {
        if (value!.isEmpty) {
          return 'Nhập Tên Truyện';
        }
        return null;
      },
      onSaved: (value) {
        _editedBook = _editedBook.copyWith(title: value);
      },
    );
  }

  TextFormField _buildAuthorField() {
    return TextFormField(
      initialValue: _editedBook.author,
      decoration: const InputDecoration(labelText: 'Tác Giả'),
      textInputAction: TextInputAction.next,
      autofocus: true,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Nhập Tác Giả';
        }
        return null;
      },
      onSaved: (value) {
        _editedBook = _editedBook.copyWith(author: value);
      },
    );
  }

  TextFormField _buildQuantityField() {
    return TextFormField(
      initialValue: _editedBook.quantity.toString(),
      decoration: const InputDecoration(labelText: 'Số lượng'),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isEmpty) {
          return 'nhập số lượng';
        }
        if (double.tryParse(value) == null) {
          return 'nhập giá trị là số';
        }
        // if (double.parse(value) <= 0) {
        //   return 'phải lớn hơn 0';
        // }
        return null;
      },
      onSaved: (value) {
        _editedBook = _editedBook.copyWith(quantity: int.parse(value!));
      },
    );
  }

  TextFormField _buildPriceField() {
    return TextFormField(
      initialValue: _editedBook.price.toString(),
      decoration: const InputDecoration(labelText: 'Giá'),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isEmpty) {
          return 'nhập giá';
        }
        if (double.tryParse(value) == null) {
          return 'nhập giá trị là số';
        }
        if (double.parse(value) <= 0) {
          return 'Giá phải lớn hơn 0';
        }
        return null;
      },
      onSaved: (value) {
        _editedBook = _editedBook.copyWith(price: int.parse(value!));
      },
    );
  }

  TextFormField _buildDescriptionField() {
    return TextFormField(
      initialValue: _editedBook.description,
      decoration: const InputDecoration(labelText: 'mô tả'),
      maxLines: 3,
      keyboardType: TextInputType.multiline,
      validator: (value) {
        if (value!.isEmpty) {
          return 'nhập mô tả';
        }
        if (value.length < 8) {
          return 'nhập nhiều hơn 8 ký tự';
        }
        return null;
      },
      onSaved: (value) {
        _editedBook = _editedBook.copyWith(description: value);
      },
    );
  }

  TextFormField _buildCategoryField() {
    return TextFormField(
      initialValue: _editedBook.category,
      decoration: const InputDecoration(labelText: 'Thể Loại'),
      textInputAction: TextInputAction.next,
      autofocus: true,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Nhập thể loại';
        }
        return null;
      },
      onSaved: (value) {
        _editedBook = _editedBook.copyWith(category: value);
      },
    );
  }

  Widget _buildBookPreview() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Container(
          width: 100,
          height: 100,
          margin: const EdgeInsets.only(top: 8, right: 8),
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: _imageUrlController.text.isEmpty
              ? const Text('Hình ảnh')
              : FittedBox(
                  child: Image.network(
                    _imageUrlController.text,
                    fit: BoxFit.cover,
                  ),
                ),
        ),
        Expanded(
          child: _buildImageURLField(),
        )
      ],
    );
  }

  TextFormField _buildImageURLField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Nhập đường dẫn hình ảnh'),
      keyboardType: TextInputType.url,
      textInputAction: TextInputAction.done,
      controller: _imageUrlController,
      focusNode: _imageUrlFocusNode,
      onFieldSubmitted: (value) => _saveForm(),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Nhập đường dẫn hình ảnh';
        }
        if (!_isValidImageUrl(value)) {
          return 'Sai đường dẫn';
        }
        return null;
      },
      onSaved: (value) {
        _editedBook = _editedBook.copyWith(imageUrl: value);
      },
    );
  }


}




