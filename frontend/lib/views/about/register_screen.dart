import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var myIcon = Icon(Icons.visibility);
  var visible = false;
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
            Container(
              width: 250,
              child: TextField(
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
                obscureText: true,
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
                    Navigator.pushNamed(context,"/main_screen");
                    //locator<NavigationService>().navigateTo(LoginScreenRoute);
                  },
                  child: Text("Register",),
            )
          ],
        ),
      ),
    );
  }
}