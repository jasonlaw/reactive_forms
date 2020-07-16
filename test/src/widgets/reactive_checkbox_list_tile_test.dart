import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'reactive_checkbox_list_tile_testing_widget.dart';

void main() {
  group('ReactiveCheckboxListTile Tests', () {
    testWidgets(
      'FormControl with null default value then Checkbox not checked',
      (WidgetTester tester) async {
        // Given: a form with a boolean field in null
        final form = FormGroup({
          'isChecked': FormControl<bool>(),
        });

        // And: a checkbox is bind to boolean control
        await tester
            .pumpWidget(ReactiveCheckboxListTileTestingWidget(form: form));

        // Expect: the checkbox is not checked
        Checkbox checkbox =
            tester.firstWidget(find.byType(Checkbox)) as Checkbox;
        expect(checkbox.value, false);
      },
    );

    testWidgets(
      'if FormControl with defaults to True then Checkbox checked',
      (WidgetTester tester) async {
        // Given: a form with a boolean field in True
        final form = FormGroup({
          'isChecked': FormControl<bool>(defaultValue: true),
        });

        // And: a checkbox is bind to boolean control
        await tester
            .pumpWidget(ReactiveCheckboxListTileTestingWidget(form: form));

        // Expect: the checkbox is checked
        Checkbox checkbox =
            tester.firstWidget(find.byType(Checkbox)) as Checkbox;
        expect(checkbox.value, true);
      },
    );

    testWidgets(
      'if FormControl with defaults to False then Checkbox not checked',
      (WidgetTester tester) async {
        // Given: a form with a boolean field in False
        final form = FormGroup({
          'isChecked': FormControl<bool>(defaultValue: false),
        });

        // And: a checkbox is bind to boolean control
        await tester
            .pumpWidget(ReactiveCheckboxListTileTestingWidget(form: form));

        // Expect: the checkbox is not checked
        Checkbox checkbox =
            tester.firstWidget(find.byType(Checkbox)) as Checkbox;
        expect(checkbox.value, false);
      },
    );

    testWidgets(
      'Change FormControl value to True changes Checkbox value to True',
      (WidgetTester tester) async {
        // Given: a form with a boolean field
        final form = FormGroup({
          'isChecked': FormControl<bool>(),
        });

        // And: a checkbox is bind to boolean control
        await tester
            .pumpWidget(ReactiveCheckboxListTileTestingWidget(form: form));

        // Expect: the checkbox is not checked
        Checkbox checkbox =
            tester.firstWidget(find.byType(Checkbox)) as Checkbox;
        expect(checkbox.value, false);

        // When: set to True the form control
        form.control('isChecked').value = true;
        await tester.pump();

        // Then: the checkbox is checked
        checkbox = tester.firstWidget(find.byType(Checkbox)) as Checkbox;
        expect(checkbox.value, true);
      },
    );

    testWidgets(
      'Change FormControl value to False changes Checkbox value to False',
      (WidgetTester tester) async {
        // Given: a form with a boolean field in true
        final form = FormGroup({
          'isChecked': FormControl<bool>(defaultValue: true),
        });

        // And: a checkbox is bind to boolean control
        await tester
            .pumpWidget(ReactiveCheckboxListTileTestingWidget(form: form));

        // Expect: the checkbox is checked
        Checkbox checkbox =
            tester.firstWidget(find.byType(Checkbox)) as Checkbox;
        expect(checkbox.value, true);

        // When: set to False the form control
        form.control('isChecked').value = false;
        await tester.pump();

        // Then: the checkbox is checked
        checkbox = tester.firstWidget(find.byType(Checkbox)) as Checkbox;
        expect(checkbox.value, false);
      },
    );
  });
}
