import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key key}) : super(key: key);
  
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  var myColor = Colors.red;
  changeColor(newColor){
    setState(() {
      myColor = newColor;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: myColor,
      child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
              children :[
                Container(
                  child: Text(
                    "Let's Start",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize:50,
                      fontWeight: FontWeight.bold
                    )
                  ),
                ), 
                RaisedButton(
                  hoverElevation: 10.0,
                  color: Colors.green,
                  hoverColor: Colors.green[400],
                  textColor: Colors.white,
                  onPressed: (){
                    changeColor(Colors.blue);
                    Navigator.pushNamed(context,"/login_screen");
                    //locator<NavigationService>().navigateTo(LoginScreenRoute);
                  },
                  child: Text("Login",),
                  onLongPress: (){
                    changeColor(Colors.purple);
                  },
                ),
                Container(
                  child: Text(
                    "New Here?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize:50,
                      fontWeight: FontWeight.bold
                    )
                  ),
                ),
                RaisedButton(
                  color: Colors.green,
                  textColor: Colors.white,
                  onPressed: (){
                    changeColor(Colors.yellow);
                    Navigator.pushNamed(context,"/register_screen");
                  },
                  child: Text("Register",),
                  onLongPress: (){
                    changeColor(Colors.pink);
                  }
                ),
              ],
          ),
      )  
    );
  }
}