import 'package:flutter/material.dart';

class LoginWidget extends StatefulWidget {
  LoginWidget({Key? key, required this.submitFn, required this.isLoading})
      : super(key: key);

  final bool isLoading;
  final void Function(String email, String username, String password,
      bool isLogin, BuildContext context) submitFn;

  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final _formKey = GlobalKey<FormState>();

  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';
  bool _isLogin = true;

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();

    FocusScope.of(context).unfocus();

    if (isValid != null) {
      _formKey.currentState!.save();
      widget.submitFn(_userEmail.trim(), _userName.trim(), _userPassword.trim(),
          _isLogin, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Hello',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Lato',
                          fontSize: 80),
                    ),
                    Stack(
                      children: [
                        Text(
                          _isLogin ? 'Again' : 'There',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Lato',
                              fontSize: 80),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(240.0, 0, 0, 0),
                          child: Text(
                            '!',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Lato',
                                fontSize: 80,
                                color: Theme.of(context).colorScheme.primary),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!_isLogin)
                        TextFormField(
                          key: const ValueKey('username'),
                          validator: (value) {
                            if (value!.isEmpty || value.length < 4) {
                              return 'Username should not be less than 8 character';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _userName = value!;
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Username',
                            labelStyle: TextStyle(
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            suffixIcon: Icon(Icons.account_box),
                          ),
                        ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        key: const ValueKey('email'),
                        validator: (value) {
                          if (value!.isEmpty || !value.contains('@')) {
                            return 'Invalid email address';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _userEmail = value!;
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          suffixIcon: Icon(Icons.contact_mail),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        key: const ValueKey('password'),
                        validator: (value) {
                          if (value!.isEmpty || value.length < 8) {
                            return 'Password must be more than 8 characters';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _userPassword = value!;
                        },
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          suffixIcon: Icon(
                            Icons.password,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      if (widget.isLoading) const CircularProgressIndicator(),
                      if (!widget.isLoading)
                        ElevatedButton(
                          onPressed: _trySubmit,
                          child: Text(_isLogin ? 'Login' : 'Singup'),
                        ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (!widget.isLoading)
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isLogin = !_isLogin;
                            });
                          },
                          child: Text(_isLogin
                              ? 'Create  new account'
                              : 'I already have account'),
                        ),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
