import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_default/bar_prov.dart';
import 'package:riverpod_default/foo.dart';
import 'package:riverpod_default/foo_prov.dart';

Future<void> pressButtonWithKey(WidgetTester tester, Key k) async {
  final increaseBarKey = find.byKey(k);
  await tester.tap(increaseBarKey);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets(
    'huh',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Consumer(
              builder: (context, ref, _) {
                final bar = ref.watch(barProv);
                final fooBar = ref.watch(fooProv).bar;
                return Column(
                  children: [
                    Text(bar.toString()),
                    MaterialButton(
                      key: const Key('increase_foo_prov'),
                      onPressed: () {
                        ref.read(fooProv.notifier).state = Foo(
                          fooBar + 1,
                        );
                      },
                    ),
                    MaterialButton(
                      key: const Key('increase_bar_prov'),
                      onPressed: () {
                        ref.read(barProv.notifier).state = bar + 1;
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      // foo_prov -> 1
      // bar_prov -> 1
      //
      // the default value of foo_prov is 1, and as bar_prov has
      // not changed its own value, the value on screen should be 1
      expect(find.text('1'), findsOneWidget);
      expect(find.text('2'), findsNothing);

      // foo_prov -> 1
      // bar_prov -> 1
      //
      // increasing foo_prov, as bar_prov has not changed its own value,
      // bar_prov will obey foo_prov and increase its value by 1, to
      // become 2.
      await pressButtonWithKey(tester, const Key('increase_foo_prov'));
      // foo_prov -> 2
      // bar_prov -> 2
      //
      expect(find.text('2'), findsOneWidget);
      expect(find.text('1'), findsNothing);

      // foo_prov -> 2
      // bar_prov -> 2
      //
      // now here where we can start make observations, we're gonna
      // increase bar_prov, and not change foo_prov, so now bar_prov
      // has its own value, and foo_prov will not change its value.
      await pressButtonWithKey(tester, const Key('increase_bar_prov'));
      // foo_prov -> 2
      // bar_prov -> 3
      //
      expect(find.text('3'), findsOneWidget);
      expect(find.text('2'), findsNothing);

      // foo_prov -> 2
      // bar_prov -> 3
      //
      // this is the final observation. we've changed the value of
      // bar_prov, so the question is has bar_prov gone independent
      // and not watching foo_prov anymore? apparently not. after
      // increasing foo_prov, bar_prov will again follow foo_prov.
      await pressButtonWithKey(tester, const Key('increase_foo_prov'));
      // foo_prov -> 3
      // bar_prov -> 3
      //
      expect(find.text('3'), findsOneWidget);
      expect(find.text('2'), findsNothing);
    },
  );
}
