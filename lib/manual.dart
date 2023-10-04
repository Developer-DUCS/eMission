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

                Expanded(
                  child: Container(
                    color: Color.fromRGBO(124, 184, 22, 1),
                    //padding: EdgeInsets.all(16.0),
                    child: DropdownButton<String>(
                      value: selectedItem,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedItem = newValue ?? items[0]; // Provide a default value if newValue is null
                        });
                      },
                      menuMaxHeight: 100,
                      items: items.map((String item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
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

              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget textBox() {
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Enter a search term',
      ),
      keyboardType: TextInputType.number,
    );
  }
}
