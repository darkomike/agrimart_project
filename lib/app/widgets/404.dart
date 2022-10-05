// ignore_for_file: file_names
import 'package:flutter/material.dart';
class Page404 extends StatelessWidget {
  const Page404({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            TextButton(
                onPressed: () {
                },
                
                child: Text(
                  "Go to Homepage",
                  style:
                      Theme.of(context).textTheme.headline1!.copyWith(fontSize: 18),
                )),
                 Padding(
                   padding: const EdgeInsets.all(30.0),
                   child: Center(
              
                child: Text(                    
                    "Oops, something went wrong!!!",
                    style:
                        Theme.of(context).textTheme.headline1!.copyWith(fontSize: 20), 
                )),
                 ),
          ],
        ),
      ),
    );
  }
}
