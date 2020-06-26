import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/constants/url_constants.dart';
import 'package:frontend/views/main/main_screen.dart';
import 'package:frontend/widgets/user/user.dart';
import 'package:http/http.dart' as http;
class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var myEmailController = TextEditingController();
  var myPasswordController = TextEditingController();
  var myNameController = TextEditingController();
  var myIcon = Icon(Icons.visibility);
  var visible = false;
  var email ;
  var password;
  var name;
  Future<User> _futureUser;

  final myNavigator = new Navigator();
  
  Future<User> userRegister(name,email,password) async {
    final http.Response response = await http.post(
      baseUrl + '/users',
      body: jsonEncode(<String, String>{
        'email':email,
        'password': password,
        'name': name,
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
            Container(
              width: 250,
              child: TextField(
                controller: myNameController,
                maxLength: 40,
                decoration: InputDecoration(
                  labelText: 'Name',
                  
                  icon: Icon(Icons.person),
                  hintText: 'John Doe',
                  //helperText: 'Helper Text',
                  //counterText: '0 characters',
                  border: const OutlineInputBorder(),
                ),
                textAlign: TextAlign.center,
              ),
            ),

            Container(
              width: 250,
              child: TextField(
                controller: myEmailController,
                maxLength: 40,
                decoration: InputDecoration(
                  labelText: 'Email',
                  
                  icon: Icon(Icons.mail),
                  hintText: 'john@doe.com',
                  //helperText: 'Helper Text',
                  //counterText: '0 characters',
                  border: const OutlineInputBorder(),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            Container(
              width: 250,
              child: TextField(
                controller: myPasswordController,
                obscureText: !visible,
                autocorrect: false,
                obscuringCharacter: '*',
                toolbarOptions: ToolbarOptions(paste: true,),
                maxLength: 20,
                decoration: InputDecoration(
                  labelText: 'Password',
                  icon: Icon(Icons.lock),
                  hintText: '********',
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
            ),
            RaisedButton(
              hoverElevation: 10.0,
                  color: Colors.green,
                  hoverColor: Colors.green[400],
                  textColor: Colors.white,
                  onPressed: (){
                   
                    password = myPasswordController.text;
                    email = myEmailController.text;
                    name = myNameController.text;
                    //print(email);
                    //print (password);
                    
                    _futureUser = userRegister(name,email,password);
                    showDialog(
                      context: context,
                      builder: (_)=> AlertDialog(
                        title: Text("Waiting..."),
                        content: FutureBuilder<User>(
                          future:_futureUser,
                          builder: (context,snapshot){
                            if(snapshot.connectionState == ConnectionState.done)
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
                              }else
                                return Container(
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
                                );
                            else {
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
                      ),);
                  },
                  child: Text("Register",),
            )
          ],
        ),
      ),
    );
  }
}