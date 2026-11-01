
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:marvel/main.dart';

void main() {
      TestWidgetsFlutterBinding.ensureInitialized();

      setUp(() {
            SharedPreferences.setMockInitialValues({});
      });

      testWidgets('Tic Tac Toe navigation works',
              (WidgetTester tester) async {
                await tester.pumpWidget(const TicTacToeApp());
                await tester.pumpAndSettle();

                expect(find.text('Home'), findsOneWidget);
                expect(find.text('Play'), findsOneWidget);
                expect(find.text('Records'), findsOneWidget);
                expect(find.text('Profile'), findsOneWidget);

                await tester.tap(find.text('Play'));
                await tester.pumpAndSettle();

                expect(find.text("Let's play"), findsOneWidget);
                expect(find.text('Two players'), findsOneWidget);
                expect(find.text('Play against AI'), findsOneWidget);
          });
}
