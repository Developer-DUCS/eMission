import 'package:flutter/material.dart';

class Manual extends StatefulWidget {
  const Manual({Key? key});

  @override
  _ManualState createState() => _ManualState();
}

class _ManualState extends State<Manual> {
  List<String> items = ['Car 1', 'Truck 2', 'Van 3', 'Motorcycle 4'];
  String selectedItem = 'Car 1';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[

                Container(
                  color: Color.fromRGBO(124, 184, 22, 1),
                  padding: EdgeInsets.only(top: 200.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      //width: 100,
                      child: DropdownButton<String>(
                        value: selectedItem,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedItem = newValue ?? items[0];
                          });
                        },
                        items: items.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: Container(
                    color: Color.fromRGBO(124, 184, 22, 1),
                    child: Center(
                      child: textBox(),
                    ),
                  ),
                ),

                Expanded(
                  child: Container(
                    color: Color.fromRGBO(124, 184, 22, 1),
                    child: Center(
                      child: submitButton(),
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

  Widget textBox() {
    return Container(
      width: 200, // Set the desired width here
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter Your Total Milage',
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }

  Widget submitButton() {
    return Container(
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        height: 30,
        width: 250,
        child: TextButton(
          style: TextButton.styleFrom(
            foregroundColor:const Color.fromARGB(244, 0, 0, 0),
            backgroundColor: const Color.fromARGB(244, 244, 248, 6),
          ),
          onPressed: () { Navigator.pushNamed(context, 'manual'); },
        child: const Text('Submit')),
      ),
    ); 
  }

}
