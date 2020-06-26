import 'dart:async';
import 'dart:convert';
import 'package:frontend/constants/url_constants.dart';
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
  Future<User> _futureUser;

  final myNavigator = new Navigator();

  Future<User> userLogin(email,password) async {
    final http.Response response = await http.post(
      baseUrl + '/login',
      body: jsonEncode(<String, String>{
        'email':email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to login');
    }
  }
  
  User buildUser(_futureUser){
    var currentUser;
    FutureBuilder<User>(
      future:_futureUser,
      builder: (context,snapshot){
        if(snapshot.hasData)
          currentUser = new User(
          accessToken: snapshot.data.accessToken,
          id: snapshot.data.id,
          name: snapshot.data.name,
          role: snapshot.data.role,
          email: snapshot.data.email,
          password: snapshot.data.password
        );
      }
    );
    return currentUser;
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
                _futureUser = userLogin(email,password);
                showDialog(
                  context: context,
                  builder: (_)=> AlertDialog(
                    title: Text("Waiting..."),
                    content: FutureBuilder<User>(
                      future:_futureUser,
                      builder: (context,snapshot){
                        print("TEST");
                        if(snapshot.connectionState == ConnectionState.done){
                          if(snapshot.hasData){
                            var userInfo = buildUser(_futureUser);
                            Navigator.push(
                              context, 
                              MaterialPageRoute(
                                builder: (context) => MainScreen(userInfo),
                                settings: RouteSettings(arguments: snapshot)
                              ),
                            );
                            return Text('Welcome ${snapshot.data.name}');
                          }else{
                            print("TEST2");
                            return null;
                            /*Container(
                              height: 200,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Failed to Login'),
                                  FlatButton(
                                    child: Text("OK"),
                                    onPressed: () {
                                      Navigator.of(context, rootNavigator: true).pop('dialog');
                                    },
                                  ),
                                ],
                              ),
                            );*/
                          }
                        }else {
                          print("TEST3");
                          return Container(height:200,child: Center(child: CircularProgressIndicator()));
                        }
                        
                      }
                    ),
                  )
                );

                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (context) => MainScreen(buildUser(_futureUser)),
                    settings: RouteSettings(arguments: _futureUser)
                  ),
                );
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
