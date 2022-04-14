import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localport_alter_admin/DataClasses/UserClass.dart';
import 'package:localport_alter_admin/resources/MyColors.dart';
import 'package:localport_alter_admin/services/LocalportApiService/localport_alluser_service.dart';
import 'package:localport_alter_admin/services/allusers_page_service.dart';
import 'package:localport_alter_admin/widgets/UserCard.dart';
import 'package:provider/provider.dart';

class AllUsers extends StatefulWidget {
  const AllUsers({Key key}) : super(key: key);

  @override
  _AllUsersState createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  List<UserClass> _users = [];

  fetchUsers() async {
    try {
      String business = Provider.of<AlluserPageService>(context, listen: false)
          .getOrderHistorySearchType();
      String status = Provider.of<AlluserPageService>(context, listen: false)
          .getOrderHistorySearchStatus();

      Provider.of<LocalportAllUserService>(context, listen: false)
          .fetchUsers(business, status);
    } catch (err) {
      print(err);
      showFailMessage("Please try again after sometime");
    }
  }

  showFailMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Widget userType() {
    return Consumer<AlluserPageService>(builder: (context, snapshot, child) {
      return Container(
        child: Column(
          children: [
            Row(
              children: [
                Row(
                  children: [
                    Radio(
                        value: 'Individual',
                        activeColor: MyColors.color1,
                        groupValue: snapshot.getOrderHistorySearchType(),
                        onChanged: (val) {
                          snapshot.setOrderHistorySearchType(val);
                          fetchUsers();
                        }),
                    Text(
                      "Individual",
                      style: GoogleFonts.roboto(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: snapshot.getOrderHistorySearchType() ==
                                  "Individual"
                              ? MyColors.color1
                              : Colors.black),
                    )
                  ],
                ),
                Row(
                  children: [
                    Radio(
                        value: 'Business',
                        activeColor: MyColors.color1,
                        groupValue: snapshot.getOrderHistorySearchType(),
                        onChanged: (val) {
                          snapshot.setOrderHistorySearchType(val);
                          fetchUsers();
                        }),
                    Text(
                      "Business",
                      style: GoogleFonts.aBeeZee(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color:
                              snapshot.getOrderHistorySearchType() == "Business"
                                  ? MyColors.color1
                                  : Colors.black),
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  userList() {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async {
          fetchUsers();
          return;
        },
        child: SingleChildScrollView(
          physics:
              AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          child: Consumer<LocalportAllUserService>(
              builder: (context, snapshot, child) {
            _users = snapshot.getUsers();
            return snapshot.isLoading()
                ? CircularProgressIndicator()
                : ListView.builder(
                    itemCount: _users.length,
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: UserCard(_users[index],index),
                      );
                    });
          }),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      "All users",
                      style: TextStyle(
                          letterSpacing: 3,
                          fontWeight: FontWeight.bold,
                          fontSize: 22),
                    ),
                  ),
                ),
              ),
              userType(),
              userList(),
            ],
          ),
        ),
      ),
    );
  }
}
