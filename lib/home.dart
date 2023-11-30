import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';



class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}
class _HomeState extends State<Home> {
  // 
  String? userInfo;


  @override
  void initState(){
    super.initState();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                
                Container(
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(202, 217, 150, 1),
                      border: Border.all(color: Colors.black, width: 2.0), // Set the border color and width
                    ),
                  height: MediaQuery.of(context).size.height / 4, // 1/4 of the screen height
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: <Widget>[
                        profilePic(),
                        const Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Column(
                              children: <Widget>[
                                Text("Your Rank: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
                                Text("Eco Friendly", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
                                Text("Tier X ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                              ]
                            )
                          )
                        )
                      ]
                    ),
                  )
                ),

                Expanded(
                  child: Container(
                    color: const Color.fromRGBO(124, 184, 22, 1),
                    child: Center(
                      child: progressBar(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  // 
  Widget profilePic() {
    return Container(
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey.shade200,
            child: const CircleAvatar(
              radius: 45,
              backgroundImage: AssetImage('assets/images/pexels-robert-so-18127674-2.jpg'),
            ),
          ),
          Container(
            child: userInfo == null ? const Text("Your Name", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),) : Text(userInfo!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24))
          ),
        ]
      ),
    );
  }
  //
  Widget progressBar() {
    return Container(
      child: const LinearProgressIndicator(
        value: 0.4,
      ),
    );
  }
  //
  void getUserInfo() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    userInfo = pref.getString("userName");
    setState(() {
      
    });
  }

}