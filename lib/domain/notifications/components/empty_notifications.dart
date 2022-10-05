import 'package:flutter/material.dart';


class EmptyNotifications extends StatelessWidget {
  const EmptyNotifications({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 200,
              width: 150,
              color: Colors.amber,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'No Notifications',
              style: Theme.of(context)
                  .textTheme
                  .headline3!
                  .copyWith(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 10,
            ),
           
          ],
        ),
      ),
    );
  }
}
