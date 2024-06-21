// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../../models/http_exception.dart';
// import '../shared/dialog_utils.dart';
//
// import 'auth_manager.dart';
//
// enum AuthMode { signup, login }
//
// class AuthCard extends StatefulWidget {
//   const AuthCard({
//     super.key,
//   });
//
//   @override
//   State<AuthCard> createState() => _AuthCardState();
// }
//
// class _AuthCardState extends State<AuthCard> {
//   final GlobalKey<FormState> _formKey = GlobalKey();
//   AuthMode _authMode = AuthMode.login;
//   final Map<String, String> _authData = {
//     'email': '',
//     'password': '',
//   };
//   final _isSubmitting = ValueNotifier<bool>(false);
//   final _passwordController = TextEditingController();
//
//   Future<void> _submit() async {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }
//     _formKey.currentState!.save();
//
//     _isSubmitting.value = true;
//
//     try {
//       if (_authMode == AuthMode.login) {
//         // Log user in
//         await context.read<AuthManager>().login(
//               _authData['email']!,
//               _authData['password']!,
//             );
//       } else {
//         // Sign user up
//         await context.read<AuthManager>().signup(
//               _authData['email']!,
//               _authData['password']!,
//             );
//       }
//     } catch (error) {
//       if (context.mounted) {
//         showErrorDialog(
//             context,
//             (error is HttpException)
//                 ? error.toString()
//                 : 'Xác Thực Không Thành Công');
//       }
//     }
//
//     _isSubmitting.value = false;
//   }
//
//   void _switchAuthMode() {
//     if (_authMode == AuthMode.login) {
//       setState(() {
//         _authMode = AuthMode.signup;
//       });
//     } else {
//       setState(() {
//         _authMode = AuthMode.login;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final deviceSize = MediaQuery.sizeOf(context);
//     return Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10.0),
//       ),
//       elevation: 8.0,
//       child: Container(
//         height: _authMode == AuthMode.signup ? 320 : 260,
//         constraints:
//             BoxConstraints(minHeight: _authMode == AuthMode.signup ? 320 : 260),
//         width: deviceSize.width * 0.75,
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: SingleChildScrollView(
//             child: Column(
//               children: <Widget>[
//                 _buildEmailField(),
//                 _buildPasswordField(),
//                 if (_authMode == AuthMode.signup) _buildPasswordConfirmField(),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 ValueListenableBuilder<bool>(
//                   valueListenable: _isSubmitting,
//                   builder: (context, isSubmitting, child) {
//                     if (isSubmitting) {
//                       return const CircularProgressIndicator();
//                     }
//                     return _buildSubmitButton();
//                   },
//                 ),
//                 _buildAuthModeSwitchButton(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildAuthModeSwitchButton() {
//     return TextButton(
//       onPressed: _switchAuthMode,
//       style: TextButton.styleFrom(
//         padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
//         tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//         textStyle: TextStyle(
//           color: Theme.of(context).colorScheme.primary,
//         ),
//       ),
//       child:
//           Text('${_authMode == AuthMode.login ? 'Đăng Ký' : 'Đăng Nhập'} Tại đây'),
//     );
//   }
//
//   Widget _buildSubmitButton() {
//     return ElevatedButton(
//       onPressed: _submit,
//       style: ElevatedButton.styleFrom(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(30),
//         ),
//         backgroundColor: Theme.of(context).colorScheme.primary,
//         foregroundColor: Theme.of(context).colorScheme.onPrimary,
//         padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
//       ),
//       child: Text(_authMode == AuthMode.login ? 'Đăng Nhập' : 'Đăng Ký'),
//     );
//   }
//
//   Widget _buildPasswordConfirmField() {
//     return TextFormField(
//       enabled: _authMode == AuthMode.signup,
//       decoration: const InputDecoration(labelText: 'Nhập Lại Mật Khẩu'),
//       obscureText: true,
//       validator: _authMode == AuthMode.signup
//           ? (value) {
//               if (value != _passwordController.text) {
//                 return 'Mật Khẩu Không Khớp!';
//               }
//               return null;
//             }
//           : null,
//     );
//   }
//
//   Widget _buildPasswordField() {
//     return TextFormField(
//       decoration: const InputDecoration(labelText: 'Mật Khẩu'),
//       obscureText: true,
//       controller: _passwordController,
//       validator: (value) {
//         if (value == null || value.length < 5) {
//           return 'Mật Khẩu Quá Ngắn!';
//         }
//         return null;
//       },
//       onSaved: (value) {
//         _authData['password'] = value!;
//       },
//     );
//   }
//
//   Widget _buildEmailField() {
//     return TextFormField(
//       decoration: const InputDecoration(labelText: 'Email'),
//       keyboardType: TextInputType.emailAddress,
//       validator: (value) {
//         if (value!.isEmpty || !value.contains('@')) {
//           return 'Email không hợp lệ!';
//         }
//         return null;
//       },
//       onSaved: (value) {
//         _authData['email'] = value!;
//       },
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '/models/http_exception.dart';
// import '../shared/dialog_utils.dart';
//
// import 'auth_manager.dart';
//
// enum AuthMode { signup, login }
//
// class AuthCard extends StatefulWidget {
//   const AuthCard({
//     super.key,
//   });
//
//   @override
//   State<AuthCard> createState() => _AuthCardState();
// }
//
// class _AuthCardState extends State<AuthCard> {
//   final GlobalKey<FormState> _formKey = GlobalKey();
//   AuthMode _authMode = AuthMode.login;
//   final Map<String, String> _authData = {
//     'email': '',
//     'password': '',
//     'name': '',
//     'phone': '',
//     'address': '',
//   };
//   final _isSubmitting = ValueNotifier<bool>(false);
//   final _passwordController = TextEditingController();
//
//   Future<void> _submit() async {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }
//     _formKey.currentState!.save();
//
//     _isSubmitting.value = true;
//
//     try {
//       if (_authMode == AuthMode.login) {
//         // Log user in
//         await context.read<AuthManager>().login(
//           _authData['email']!,
//           _authData['password']!,
//         );
//       } else {
//         // Sign user up
//         await context.read<AuthManager>().signup(
//           _authData['email']!,
//           _authData['password']!,
//           _authData['name']!,
//           _authData['phone']!,
//           _authData['address']!,
//         );
//       }
//     } catch (error) {
//       print(error);
//       if (context.mounted) {
//         showErrorDialog(
//             context,
//             (error is HttpException)
//                 ? error.toString() == 'INVALID_LOGIN_CREDENTIALS'
//                 ? 'Invalid email or password!'
//                 : error.toString()
//                 : 'Authentication failed');
//       }
//     }
//
//     _isSubmitting.value = false;
//   }
//
//   void _switchAuthMode() {
//     if (_authMode == AuthMode.login) {
//       setState(() {
//         _authMode = AuthMode.signup;
//       });
//     } else {
//       setState(() {
//         _authMode = AuthMode.login;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final deviceSize = MediaQuery.sizeOf(context);
//     return Card(
//       color: Colors.transparent,
//       shadowColor: Colors.white.withOpacity(0.4),
//       surfaceTintColor: Colors.grey,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10.0),
//       ),
//       elevation: 8.0,
//       child: Container(
//         height: deviceSize.height,
//         width: deviceSize.width,
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: SingleChildScrollView(
//             child: Column(
//               children: <Widget>[
//                 Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child:
//                   Text(_authMode == AuthMode.login ? 'Log In' : 'Sign Up',
//                       style: const TextStyle(
//                         fontSize: 32,
//                         fontWeight: FontWeight.bold,
//                       )),
//                 ),
//                 _buildEmailField(),
//                 if (_authMode == AuthMode.signup) _buildNameField(),
//                 if (_authMode == AuthMode.signup) _buildPhoneField(),
//                 if (_authMode == AuthMode.signup) _buildAddressField(),
//                 _buildPasswordField(),
//                 if (_authMode == AuthMode.signup) _buildPasswordConfirmField(),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 ValueListenableBuilder<bool>(
//                   valueListenable: _isSubmitting,
//                   builder: (context, isSubmitting, child) {
//                     if (isSubmitting) {
//                       return const CircularProgressIndicator();
//                     }
//                     return _buildSubmitButton();
//                   },
//                 ),
//                 _buildAuthModeSwitchButton(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildAuthModeSwitchButton() {
//     return TextButton(
//       onPressed: _switchAuthMode,
//       style: TextButton.styleFrom(
//         padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
//         tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//         textStyle: TextStyle(
//           color: Theme.of(context).colorScheme.primary,
//         ),
//       ),
//       child: Text(
//         '${_authMode == AuthMode.login ? 'SIGN UP' : 'LOG IN'} INSTEAD',
//         style: const TextStyle(
//           decoration: TextDecoration.underline,
//           decorationThickness: 0.5,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSubmitButton() {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 10),
//       child: ElevatedButton(
//         onPressed: _submit,
//         style: ElevatedButton.styleFrom(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(30),
//           ),
//           backgroundColor: Theme.of(context).colorScheme.primary,
//           foregroundColor: Theme.of(context).colorScheme.onPrimary,
//           padding:
//           const EdgeInsets.symmetric(horizontal: 100.0, vertical: 12.0),
//         ),
//         child: Text(_authMode == AuthMode.login ? 'LOG IN' : 'SIGN UP'),
//       ),
//     );
//   }
//
//   Widget _buildPasswordConfirmField() {
//     return TextFormField(
//       initialValue: '',
//       enabled: _authMode == AuthMode.signup,
//       decoration: const InputDecoration(labelText: 'Confirm Password'),
//       obscureText: true,
//       validator: _authMode == AuthMode.signup
//           ? (value) {
//         if (value != _passwordController.text) {
//           return 'Passwords do not match!';
//         }
//         return null;
//       }
//           : null,
//     );
//   }
//
//   Widget _buildPhoneField() {
//     return TextFormField(
//       initialValue: '',
//       enabled: _authMode == AuthMode.signup,
//       decoration: const InputDecoration(labelText: 'Phone Number'),
//       keyboardType: TextInputType.phone,
//       validator: _authMode == AuthMode.signup
//           ? (value) {
//         if (value == null) {
//           return 'Phone cannot be empty!';
//         }
//
//         final phonePattern = RegExp(r'^[0-9]{10}$');
//         if (!phonePattern.hasMatch(value)) {
//           return 'Phone is not valid!';
//         }
//         return null;
//       }
//           : null,
//       onChanged: (value) {
//         _authData['phone'] = value;
//       },
//     );
//   }
//
//   Widget _buildAddressField() {
//     return TextFormField(
//         initialValue: '',
//         enabled: _authMode == AuthMode.signup,
//         decoration: const InputDecoration(labelText: 'Your Address'),
//         validator: _authMode == AuthMode.signup
//             ? (value) {
//           if (value == null) {
//             return 'Address cannot be empty!';
//           }
//           return null;
//         }
//             : null,
//         onChanged: (value) {
//           _authData['address'] = value;
//         });
//   }
//
//   Widget _buildNameField() {
//     return TextFormField(
//         initialValue: '',
//         enabled: _authMode == AuthMode.signup,
//         decoration: const InputDecoration(labelText: 'Your Name'),
//         validator: _authMode == AuthMode.signup
//             ? (value) {
//           if (value == null) {
//             return 'Name cannot be empty!';
//           }
//           return null;
//         }
//             : null,
//         onChanged: (value) {
//           _authData['name'] = value;
//         });
//   }
//
//   Widget _buildPasswordField() {
//     return TextFormField(
//       decoration: const InputDecoration(labelText: 'Password'),
//       obscureText: true,
//       controller: _passwordController,
//       validator: (value) {
//         if (value == null || value.length < 5) {
//           return 'Password is too short!';
//         }
//         return null;
//       },
//       onSaved: (value) {
//         _authData['password'] = value!;
//       },
//     );
//   }
//
//   Widget _buildEmailField() {
//     return TextFormField(
//       initialValue: '',
//       decoration: const InputDecoration(labelText: 'E-Mail'),
//       keyboardType: TextInputType.emailAddress,
//       validator: (value) {
//         if (value!.isEmpty || !value.contains('@')) {
//           return 'Invalid email!';
//         }
//         return null;
//       },
//       onSaved: (value) {
//         _authData['email'] = value!;
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/models/http_exception.dart';
import '../shared/dialog_utils.dart';

import 'auth_manager.dart';

enum AuthMode { signup, login }

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key? key,
  }) : super(key: key);

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.login;
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
    'name': '',
    'phone': '',
    'address': '',
  };
  final _isSubmitting = ValueNotifier<bool>(false);
  final _passwordController = TextEditingController();

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    _isSubmitting.value = true;

    try {
      if (_authMode == AuthMode.login) {
        await context.read<AuthManager>().login(
          _authData['email']!,
          _authData['password']!,
        );
      } else {
        await context.read<AuthManager>().signup(
          _authData['email']!,
          _authData['password']!,
          _authData['name']!,
          _authData['phone']!,
          _authData['address']!,
        );
      }
    } catch (error) {
      print(error);
      if (context.mounted) {
        showErrorDialog(
          context,
          (error is HttpException)
              ? error.toString() == 'INVALID_LOGIN_CREDENTIALS'
              ? 'Invalid email or password!'
              : error.toString()
              : 'Authentication failed',
        );
      }
    }

    _isSubmitting.value = false;
  }

  void _switchAuthMode() {
    setState(() {
      _authMode =
      _authMode == AuthMode.login ? AuthMode.signup : AuthMode.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      color: Colors.green[100],
      elevation: 1.0,
      child: Container(
        width: deviceSize.width * 1.25,
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  _authMode == AuthMode.login ? 'Log In' : 'Sign Up',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,

                  ),
                ),
                SizedBox(height: 20),
                if (_authMode == AuthMode.signup) _buildNameField(),
                if (_authMode == AuthMode.signup) _buildPhoneField(),
                if (_authMode == AuthMode.signup) _buildAddressField(),
                _buildEmailField(),
                _buildPasswordField(),
                if (_authMode == AuthMode.signup)
                  _buildPasswordConfirmField(),
                SizedBox(height: 20),
                ValueListenableBuilder<bool>(
                  valueListenable: _isSubmitting,
                  builder: (context, isSubmitting, child) {
                    if (isSubmitting) {
                      return CircularProgressIndicator();
                    }
                    return _buildSubmitButton();
                  },
                ),
                SizedBox(height: 10),
                _buildAuthModeSwitchButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAuthModeSwitchButton() {
    return TextButton(
      onPressed: _switchAuthMode,
      child: Text(
        '${_authMode == AuthMode.login ? 'SIGN UP' : 'LOG IN'} INSTEAD',
        style: TextStyle(
          decoration: TextDecoration.underline,
          color: Colors.black,
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _submit,
      child: Text(_authMode == AuthMode.login ? 'LOG IN' : 'SIGN UP'),
    );
  }

  Widget _buildPasswordConfirmField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Confirm Password'),
      obscureText: true,
      validator: _authMode == AuthMode.signup
          ? (value) {
        if (value != _passwordController.text) {
          return 'Passwords do not match!';
        }
        return null;
      }
          : null,
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Phone Number'),
      keyboardType: TextInputType.phone,
      validator: _authMode == AuthMode.signup
          ? (value) {
        if (value!.isEmpty) {
          return 'Phone cannot be empty!';
        }

        final phonePattern = RegExp(r'^[0-9]{10}$');
        if (!phonePattern.hasMatch(value)) {
          return 'Phone is not valid!';
        }
        return null;
      }
          : null,
      onChanged: (value) {
        _authData['phone'] = value;
      },
    );
  }

  Widget _buildAddressField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Your Address'),
      validator: _authMode == AuthMode.signup
          ? (value) {
        if (value!.isEmpty) {
          return 'Address cannot be empty!';
        }
        return null;
      }
          : null,
      onChanged: (value) {
        _authData['address'] = value;
      },
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Your Name'),
      validator: _authMode == AuthMode.signup
          ? (value) {
        if (value!.isEmpty) {
          return 'Name cannot be empty!';
        }
        return null;
      }
          : null,
      onChanged: (value) {
        _authData['name'] = value;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Password'),
      obscureText: true,
      controller: _passwordController,
      validator: (value) {
        if (value == null || value.length < 5) {
          return 'Password is too short!';
        }
        return null;
      },
      onSaved: (value) {
        _authData['password'] = value!;
      },
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'E-Mail'),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty || !value.contains('@')) {
          return 'Invalid email!';
        }
        return null;
      },
      onSaved: (value) {
        _authData['email'] = value!;
      },
    );
  }
}
