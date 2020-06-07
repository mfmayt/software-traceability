import 'package:flutter/material.dart';
import 'package:frontend/locator.dart';
import 'package:frontend/services/navigation_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
            Text(
              "Email",
              style: TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.normal, 
              ),
            ),
            Container(
              width: 250,
              child: TextField(
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
            Text(
              "Password",
              style: TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.normal, 
              ),
            ),
            Container(
              width: 250,
              child: TextField(
                obscureText: true,
                autocorrect: false,
                obscuringCharacter: '*',
                toolbarOptions: ToolbarOptions(paste: true,),
                maxLength: 20,
                decoration: InputDecoration(
                  labelText: 'Password',
                  icon: Icon(Icons.lock),
                  hintText: '********',
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
                    Navigator.pushNamed(context,"/login_screen");
                    //locator<NavigationService>().navigateTo(LoginScreenRoute);
                  },
                  child: Text("Login",),
            )
            
          ],
        ),
      ),
    );
  }
}