import 'dart:async';
import 'dart:convert';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/constants/url_constants.dart' as constants;
import 'package:frontend/constants/user_constants.dart';
import 'package:frontend/widgets/user/user.dart';
import 'package:http/http.dart' as http;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:frontend/views/main/main_screen.dart';
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passFormKey = GlobalKey<FormState>();
  final _emailFormKey = GlobalKey<FormState>();
  var myEmailController = TextEditingController();
  var myPasswordController = TextEditingController();
  var myIcon = Icon(Icons.visibility);
  var visible = false;
  var email ;
  var password;
  final myNavigator = new Navigator();

  Future<User> userLogin(email,password) async {
    final http.Response response = await http.post(
      constants.baseUrl + '/login',
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to login');
    }
  }
  
  toogleVisibility(){
    if(!visible){
      visible = true;
      myIcon = Icon(Icons.visibility);
    }
    else{
      visible = false;
      myIcon = Icon(Icons.visibility_off);
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<User> _futureUser;
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ButtonBar(
              alignment: MainAxisAlignment.start,
              children: <Widget>[ 
                IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: (){
                  Navigator.pop(context);
                  //locator<NavigationService>().goBack();
                },
                ),
              ],
            ),
            Form(
              autovalidate: true,
              key: _formKey,
              child: Container(
                width: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: TextFormField(
                        validator: (value){
                          if(value.isEmpty){
                            return "You can't have an empty email!";
                          }else
                          return null;
                        },
                        key: _emailFormKey,
                        controller: myEmailController,
                        maxLength: 40,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          icon: Icon(Icons.mail),
                          hintText: 'john@doe.com',
                          helperText: '',
                          //counterText: '0 characters',
                          border: const OutlineInputBorder(),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    TextFormField(
                      key: _passFormKey,
                      autovalidate: true,
                      controller: myPasswordController,
                      obscureText: !visible,
                      autocorrect: false,
                      toolbarOptions: ToolbarOptions(paste: true,),
                      maxLength: 20,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        icon: Icon(Icons.lock),
                        hintText: 'Password',
                        suffixIcon: IconButton(
                          icon: myIcon, 
                          onPressed: (){
                            setState(() {
                              if(visible){
                              toogleVisibility();
                              }else{
                                toogleVisibility();
                              }
                            }); 
                          }
                        ),
                      border: const OutlineInputBorder(),
                      ),
                      textAlign: TextAlign.center,                
                    ),

                  ]
                ),
              ),
            ),
            
            RaisedButton(
              hoverElevation: 10.0,
              color: Colors.green,
              hoverColor: Colors.green[400],
              textColor: Colors.white,
              onPressed: (){
                password = myPasswordController.text;
                email = myEmailController.text;
                
                
                setState(() {
                  _futureUser = userLogin(email,password);
                  showDialog(
                    context: context,
                    builder: (_)=> AlertDialog(
                      title: Text("Waiting..."),
                      content: FutureBuilder<User>(
                        future:_futureUser,
                        builder: (context,snapshot){
                          if(snapshot.connectionState == ConnectionState.done){
                            if(snapshot.hasData){
                              return Container(
                                height: 200,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Welcome ${snapshot.data.name}'),
                                    RaisedButton(
                                      color: primaryColor,
                                      child: Text("Go to your projects"),
                                      onPressed: () {
                                        setState(() {
                                          constants.userTokenConstant = snapshot.data.accessToken;
                                          constants.sharedUserId = snapshot.data.id;
                                        });
                                        Navigator.push(
                                        context, 
                                        MaterialPageRoute(
                                          builder: (context) => MainScreen(myUser: snapshot.data),
                                          settings: RouteSettings(arguments: snapshot.data)
                                        ),
                                      );
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }else{
                              return Container(
                                height: 200,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Failed to Login'),
                                    RaisedButton(
                                      color: primaryColor,
                                      child: Text("OK"),
                                      onPressed: () {
                                        Navigator.of(context, rootNavigator: true).pop('dialog');
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }
                          }else {
                            return Container(height:200,child: Center(child: CircularProgressIndicator()));
                          }
                        }
                      ),
                    )
                  );
                });
                myPasswordController.clear();
                myEmailController.clear();
              },
              child: Text("Login",),
            )
          ],
        ),
      ),
    );
  }
}
