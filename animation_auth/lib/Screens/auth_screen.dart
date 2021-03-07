import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  @override
  _AuthFormState createState() => _AuthFormState();
}

enum AuthMode { SignUp, Login }

class _AuthFormState extends State<AuthForm> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  bool _isLogin = true;
  String _email = "";
  String _password = "";
  String _username = "";

  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };


  AnimationController animationController;
  Animation<double> animation;

  final _passwordController = TextEditingController();

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.SignUp;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  void _submit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if(isValid){
      _formKey.currentState.save();

    }

    // if (!_formKey.currentState.validate()) {
    //   // Invalid!
    //   return;
    // }
    // _formKey.currentState.save();
    // if (_authMode == AuthMode.Login) {
    //   // Log user in
    // } else {
    //   // Sign user up
    // }
  }


  @override
  void initState() {
    animationController = AnimationController(vsync: this,duration: Duration(milliseconds: 300));
    animation = Tween<double>(begin: 1.0,end: 0.0).animate(CurvedAnimation(parent: animationController,curve: Curves.easeIn));
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Card(
          margin: EdgeInsets.all(20),
          elevation: 8,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            height: !_isLogin? 340:280,
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      key: ValueKey("email"),

                      decoration: InputDecoration(labelText: "E-Mail"),
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) {
                        if (val.isEmpty || !val.contains('@')) {
                          return "Invalid email!";
                        }
                        return null;
                      },
                      onSaved: (val) {
                        _email =val;
                      },
                    ),
                    if(!_isLogin)
                      TextFormField(
                        key: ValueKey("username"),
                        decoration: InputDecoration(labelText: "Username"),
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) {
                          if (val.isEmpty || val.length<3) {
                            return "Please enter at least 4 characters!";
                          }
                          return null;
                        },
                        onSaved: (val) {
                          _username =val;
                        },
                      ),
                    TextFormField(
                      key: ValueKey('password'),
                      decoration: InputDecoration(labelText: "Password"),
                      controller: _passwordController,
                      obscureText: true,
                      validator: (val) {
                        if (val.isEmpty || val.length <= 5) {
                          return "Password is too short!";
                        }
                        return null;
                      },
                      onSaved: (val) {
                        _password = val;
                      },
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      constraints: BoxConstraints(
                        minHeight: _authMode == AuthMode.SignUp?60:0,
                        maxHeight: _authMode == AuthMode.SignUp ?160:0,
                      ),
                      child: FadeTransition(
                        opacity: animation,
                        child: TextFormField(
                          enabled: _authMode == AuthMode.SignUp,
                          decoration:
                          InputDecoration(labelText: 'Confirm Password'),
                          obscureText: true,
                          validator: _authMode == AuthMode.SignUp
                              ? (value) {
                            if (value != _passwordController.text) {
                              return 'Passwords do not match!';
                            }
                            return null;
                          }
                              : null,
                        ),
                      ),
                    ),
                    SizedBox(
                        height: 20
                    ),
                    RaisedButton(
                      child:
                      Text(_isLogin? 'login' : 'sign up'),
                      onPressed: _submit,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:
                      EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                      color: Theme.of(context).primaryColor,
                      textColor: Theme.of(context).primaryTextTheme.button.color,
                    ),
                    FlatButton(
                      child: Text(_isLogin ? "Create new account" :" I already have an account"),
                      onPressed: (){
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      padding:
                      EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      textColor: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}
