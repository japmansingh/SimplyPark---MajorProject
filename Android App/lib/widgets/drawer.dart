import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minor_project/Pages/AuthenticationPage.dart';


class NavigationDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 15.0, top: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            InkWell(
              onTap: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.grey),
                    child: ClipOval(
                      child: Image.network(user.photoUrl),
                    ),
                  ),
                  Container(
                    child: Text(
                      "Basic",
                      style: TextStyle(color: Colors.grey),
                    ),
                    decoration:
                    BoxDecoration(border: Border.all(color: Colors.grey)),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {},
              child: Text(
                user.displayName.toUpperCase(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
            ),
            Text(
              "5 Cars added",
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: (){},
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.settings_input_component,
                    color: Colors.black,
                    size: 22,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    "Settings",
                    style: TextStyle(fontSize: 16),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            InkWell(
              onTap: (){},
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.bookmark,
                    color: Colors.black,
                    size: 22,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    "Saved Locations",
                    style: TextStyle(fontSize: 16),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              children: <Widget>[
                Icon(
                  Icons.money,
                  color: Colors.black,
                  size: 22,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Pending Payments",
                  style: TextStyle(fontSize: 16),
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            InkWell(
              onTap: (){},
              child: Row(
                children: <Widget>[
                  Container(
                      width: 20,
                      height: 20,
                      child: Icon(Icons.support_agent,color: Colors.black,)
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    "Support",
                    style: TextStyle(fontSize: 16),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            InkWell(
              onTap: (){},
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.add_to_home_screen,
                    color: Colors.black,
                    size: 22,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    "Logout",
                    style: TextStyle(fontSize: 16),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Divider(
              thickness: 2,
              color: Colors.grey[300],
            ),
            SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "MISCELLANEOUS",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Icon(Icons.arrow_right)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

