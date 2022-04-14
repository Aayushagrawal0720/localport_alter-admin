import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localport_alter_admin/DataClasses/UserClass.dart';
import 'package:localport_alter_admin/resources/MyColors.dart';
import 'package:localport_alter_admin/services/LocalportApiService/localport_alluser_service.dart';
import 'package:localport_alter_admin/services/LocalportApiService/localport_specialuser_service.dart';
import 'package:provider/provider.dart';

class UserCard extends StatefulWidget {
  UserClass user;
  int index;

  UserCard(this.user, this.index);

  @override
  _UserCardState createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  UserClass _user;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(3),
          boxShadow: [
            BoxShadow(
                color: MyColors.bg_lightgrey.withOpacity(0.6),
                blurRadius: 12,
                offset: Offset(0, 0))
          ]),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  _user.isvendor ? _user.vname.toString() : _user.name,
                  maxLines: 3,
                  overflow: TextOverflow.visible,
                  style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(child: Container()),
                _user.isvendor
                    ? RichText(
                        text: TextSpan(children: [
                        TextSpan(
                            text: "Owner ",
                            style: GoogleFonts.roboto(color: Colors.grey)),
                        TextSpan(
                            text: _user.name,
                            style: GoogleFonts.roboto(color: Colors.black)),
                      ]))
                    : Container()
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text(
                  "Wallet amount:",
                  style: GoogleFonts.aBeeZee(color: Colors.grey),
                ),
                Expanded(
                  child: Text(
                    _user.wallet.toString(),
                    style: GoogleFonts.aBeeZee(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text('Special user'),
                Consumer<LocalportSpecialUserService>(
                    builder: (context, snapshot, child) {

                  return Switch(
                      value: _user.isSpecialUser,
                      onChanged: (value) {
                        snapshot.setSpecialUser(_user, value);
                        if (snapshot.getFinalResponse() != 'success' &&
                            snapshot.getFinalResponse() != '') {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(snapshot.getFinalResponse())));
                        }else{
                          Provider.of<LocalportAllUserService>(context, listen: false).updateSpecialUser(
                              widget.index, value);
                        }
                      });
                })
              ],
            )
          ],
        ),
      ),
    );
  }
}
