import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

void main() {
  runApp(ReactiveFormsApp());
}

class ReactiveFormsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // We don't recommend to declare a FormGroup within a Stateful Widget.
  // We highly recommend using the Provider plugin
  // or any other state management library.
  //
  // We have declared the FormGroup within a Stateful Widget only for
  // demonstration purposes and to simplify the explanation in this example.
  final form = FormGroup({
    'email': FormControl(
      validators: [
        Validators.required,
        Validators.email,
      ],
      asyncValidators: [_uniqueEmail],
    ),
    'password': FormControl(validators: [
      Validators.required,
      Validators.minLength(8),
    ]),
    'passwordConfirmation': FormControl(validators: [
      Validators.required,
    ]),
    'rememberMe': FormControl(defaultValue: false),
    'progress': FormControl<double>(defaultValue: 50.0),
    'dateTime': FormControl<DateTime>(defaultValue: DateTime.now()),
  }, validators: [
    Validators.mustMatch('password', 'passwordConfirmation')
  ]);

  FormControl get password => this.form.control('password');
  FormControl get passwordConfirmation =>
      this.form.control('passwordConfirmation');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reactive Forms'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: ReactiveForm(
            formGroup: this.form,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ReactiveTextField(
                  formControlName: 'email',
                  decoration: InputDecoration(
                    labelText: 'Email',
                    suffixIcon: ReactiveStatusListenableBuilder(
                      formControlName: 'email',
                      builder: (context, control, child) {
                        return control.pending
                            ? CircularProgressIndicator()
                            : Container(width: 0);
                      },
                    ),
                  ),
                  validationMessages: {
                    ValidationMessage.required: 'The email must not be empty',
                    ValidationMessage.email:
                        'The email value must be a valid email',
                    'unique': 'This email is already in use',
                  },
                  textInputAction: TextInputAction.next,
                  onSubmitted: () => this.password.focus(),
                ),
                ReactiveTextField(
                  formControlName: 'password',
                  decoration: InputDecoration(
                    labelText: 'Password',
                  ),
                  obscureText: true,
                  validationMessages: {
                    ValidationMessage.required:
                        'The password must not be empty',
                    ValidationMessage.minLength:
                        'The password must be at least 8 characters',
                  },
                  textInputAction: TextInputAction.next,
                  onSubmitted: () => this.passwordConfirmation.focus(),
                ),
                ReactiveTextField(
                  formControlName: 'passwordConfirmation',
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                  ),
                  obscureText: true,
                  validationMessages: {
                    ValidationMessage.required:
                        'The password confirmation must not be empty',
                    ValidationMessage.mustMatch: 'The passwords must match',
                  },
                ),
                ReactiveFormConsumer(
                  builder: (context, form, child) {
                    return RaisedButton(
                      child: Text('SignIn'),
                      onPressed: form.valid ? () => print(form.value) : null,
                    );
                  },
                ),
                ReactiveSwitch(formControlName: 'rememberMe'),
                ReactiveCheckbox(formControlName: 'rememberMe'),
                ReactiveDropdownField<bool>(
                  formControlName: 'rememberMe',
                  hint: Text('Want to stay logged in?'),
                  decoration: InputDecoration(labelText: 'Remember me'),
                  items: [
                    DropdownMenuItem(
                      value: true,
                      child: Text('Yes'),
                    ),
                    DropdownMenuItem(
                      value: false,
                      child: Text('No'),
                    ),
                  ],
                ),
                ListTile(
                  title: Text('Remember me'),
                  trailing: ReactiveRadio(
                    formControlName: 'rememberMe',
                    value: true,
                  ),
                ),
                ListTile(
                  title: Text('Don\'t Remember me'),
                  trailing: ReactiveRadio(
                    formControlName: 'rememberMe',
                    value: false,
                  ),
                ),
                ReactiveValueListenableBuilder<double>(
                  formControlName: 'progress',
                  builder: (context, control, child) {
                    return Text(
                        'Progress set to ${control.value?.toStringAsFixed(2)}%');
                  },
                ),
                ReactiveSlider(
                  formControlName: 'progress',
                  max: 100,
                  divisions: 100,
                  labelBuilder: (double value) =>
                      '${value.toStringAsFixed(2)}%',
                ),
                ReactiveValueListenableBuilder<DateTime>(
                  formControlName: 'dateTime',
                  builder: (context, control, child) {
                    return Text(
                        control.value != null ? control.value.toString() : '');
                  },
                ),
                ReactiveDatePicker(
                  formControlName: 'dateTime',
                  firstDate: DateTime(1985),
                  lastDate: DateTime(2030),
                  builder: (context, picker, child) {
                    return RaisedButton(
                      onPressed: picker.openPicker,
                      child: Text(
                          'Select DateTime (${picker.dateTime.year}-${picker.dateTime.month}-${picker.dateTime.day})'),
                    );
                  },
                ),
                SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Async validator in use emails example
const inUseEmails = ['johndoe@email.com', 'john@email.com'];

/// Async validator example that simulates a request to a server
/// to validate if the email of the user is unique.
Future<Map<String, dynamic>> _uniqueEmail(AbstractControl control) async {
  final error = {'unique': true};

  return Future.delayed(
    Duration(seconds: 5),
    () => inUseEmails.contains(control.value) ? error : null,
  );
}
