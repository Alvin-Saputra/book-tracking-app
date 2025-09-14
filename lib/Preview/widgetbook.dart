// Widgetbook file: widgetbook.dart
import 'package:book_tracker_app/Model/Local/book.dart';
import 'package:book_tracker_app/View/Components/horizontal_card.dart';
import 'package:book_tracker_app/View/Components/vertical_card.dart';
import 'package:book_tracker_app/View/Screens/add_book_screen.dart';
import 'package:book_tracker_app/View/Screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

void main() {
  runApp(HotReload());
}

class HotReload extends StatelessWidget {
  HotReload({Key? key}) : super(key: key);

  final book = Book(
    id: 1,
    title: 'Tale of The Frog',
    author: 'F. Scott Fitzgerald',
    genre: 'Classic',
    totalPage: 180,
    readingStatus: 'Reading',
    addedAt: '2023-10-01',
    imageUrl: 'assets/images/book_1.jpg',
  );

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      addons: [],
      directories: [
        WidgetbookComponent(
          name: 'Card Item',
          useCases: [
            WidgetbookUseCase(
              name: 'Vertical Card',
              builder: (context) => Center(child: VerticalCard(book: book)),
            ),

            WidgetbookUseCase(
              name: 'Horizontal Card',
              builder: (context) => Center(child: HorizontalCard(book: book)),
            ),
          ],
        ),

         WidgetbookComponent(
          name: 'Screen',
          useCases: [
            WidgetbookUseCase(
              name: 'Add Book Screen',
              builder: (context) => Center(child: AddBookScreen()),
            ),

            WidgetbookUseCase(
              name: 'Registration Screen',
              builder: (context) => Center(child: RegistrationScreen()),
            ),
          ],
        ),
      ],
    );
  }
}
