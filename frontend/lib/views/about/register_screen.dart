import 'dart:async';
import 'dart:convert';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/widgets/user/user.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:frontend/views/main/main_screen.dart';

import 'package:frontend/constants/url_constants.dart' as constants;
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

  final myNavigator = new Navigator();

  Future<User> userRegister(name,email,password) async {
    final http.Response response = await http.post(
      constants.baseUrl + '/users',
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
        'name': name,
      }),
    );
    if (response.statusCode == 200) {
      print("200");
      print(response.body);
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to register');
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
                
                setState(() {
                  _futureUser = userRegister(name,email,password);
                  showDialog(
                    context: context,
                    builder: (_)=> AlertDialog(
                      title: Text("Waiting..."),
                      content: FutureBuilder<User>(
                        future:_futureUser,
                        builder: (context,snapshot){
                          if(snapshot.connectionState == ConnectionState.done){
                            print(snapshot.hasData);
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
                                    Text('Failed to Register'),
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
                myNameController.clear();
              },
              child: Text("Register",),
            )
          ],
        ),
      ),
    );
  }
}