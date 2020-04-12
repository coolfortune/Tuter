import 'package:flutter/material.dart';

class Review extends StatelessWidget {

  TextEditingController controller = TextEditingController();

  createAlertDialog(BuildContext context) 
  {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("How was your experience?"),
          content: TextField(
            controller: controller,
          ),
          actions: <Widget>[

              IconButton(
              onPressed: () {
                print('you clicked up');
              },
              icon: Icon(Icons.thumb_up),
              color: Colors.amber[300]),
              
              IconButton(
              onPressed: () {
                print('you clicked down');
              },
              icon: Icon(Icons.thumb_down),
              color: Colors.amber[300]
       
              )

          ],

          
        );
      }
    );

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: FlatButton(
        onPressed: () {
          createAlertDialog(context).then(
            Scaffold.of(context).showSnackBar(
              SnackBar(content:  Text("Thank you for your help"))
            )
          );
        }, 
        child: Text('Rate your Tutor',
        style: TextStyle(fontSize: 15.0),),
      ),)
    );
  }



}