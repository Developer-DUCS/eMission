import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

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
                      color: Color.fromRGBO(202, 217, 150, 1),
                      border: Border.all(color: Colors.black, width: 2.0), // Set the border color and width
                    ),
                  height: MediaQuery.of(context).size.height / 4, // 1/4 of the screen height
                  child: Padding(
                    padding: EdgeInsets.all(25.5),
                    child: Row(
                      children: <Widget>[
                        profilePic(),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Column(
                              children: <Widget>[
                                const Text("Your Rank: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
                                const Text("Eco Friendly", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
                                const Text("Tier X ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
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
                    color: Color.fromRGBO(124, 184, 22, 1),
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

  Widget profilePic() {
    return Container(
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey.shade200,
            child: CircleAvatar(
              radius: 45,
              backgroundImage: AssetImage('assets/images/pexels-robert-so-18127674-2.jpg'),
            ),
          ),
          const Text("Your Name", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
        ]
      ),
    );
  }

  Widget progressBar() {
    return Container(
      child: LinearProgressIndicator(
        value: 0.4,
      ),
    );
  }

}