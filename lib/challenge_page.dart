//
//
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



/* */
class ChallengePage extends StatelessWidget {
  const ChallengePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Challenge Page'),
        backgroundColor: Colors.green[300],
      ),
      endDrawer: Drawer(
        backgroundColor: Colors.black,
        child: ListView(
          padding: EdgeInsets.zero,
          children: const [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: Text('Item 1'),
              textColor: Colors.yellow,
            ),
          ]
        )
      ),
      floatingActionButton: const FloatingActionButton(
        shape: CircleBorder(),
        splashColor: Colors.white,
        backgroundColor: Colors.orangeAccent,
        foregroundColor: Colors.white,
        onPressed: null,
        child: Icon(Icons.directions_car),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Container(
        padding: const EdgeInsets.all(16.0),
        color: const Color.fromRGBO(255, 168, 48, 100),
        child:  const Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children:<Widget> [
            ChallengePageState(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                'Duration',
                style:TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  fontFamily: 'Nunito',
                  ),
                ),
                Text(
                  'Pts',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                    fontFamily: 'Nunito',
                  ),
                ),
                Text(
                  'Challenge',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                    fontFamily: 'Nunito',
                  ),
                )
              ], 
            ),
            ChallengesTable(),   
          ],
        )
      ),
    );
  }
}



/* Challenge Page Segmented Button and State Change*/
class ChallengePageState extends StatefulWidget{
  const ChallengePageState({super.key});

  @override
  State<ChallengePageState> createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePageState> {
  late int groupValue;

  @override
  Widget build(BuildContext context){
    return CupertinoSegmentedControl<String>(
      padding: const EdgeInsets.all(20.0),
      //groupValue: groupValue,
      selectedColor: Colors.green[300],
      unselectedColor: Colors.grey[100],
      borderColor: Colors.black38,
      pressedColor: Colors.green[300],
      children: const {
        'Past': Text("Past Challenges"),
        'Current': Text("Current Challenges"),
      },
      onValueChanged: (String value){
        setState(() {
          if (value == 'Past'){
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PastChallengesPage()));
          } else if(value == 'Current') {
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ChallengePage()));
          } 
        });
      },
    );
  }
}

 


class PastChallengesPage extends StatelessWidget {
  const PastChallengesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Past Challenges Page'),
        backgroundColor: Colors.green[300],
      ),
      endDrawer: Drawer(
        backgroundColor: Colors.black,
        child: ListView(
          padding: EdgeInsets.zero,
          children: const [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: Text('Item 1'),
              textColor: Colors.yellow,
            ),
          ]
        )
      ),
      floatingActionButton: const FloatingActionButton(
        shape: CircleBorder(),
        splashColor: Colors.white,
        backgroundColor: Colors.orangeAccent,
        foregroundColor: Colors.white,
        onPressed: null,
        child: Icon(Icons.directions_car),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Container(
        padding: const EdgeInsets.all(16.0),
        color:const Color.fromRGBO(124, 184, 22, 100),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children:<Widget> [
            ChallengePageState(),
            // May need to create a '_tile' class to streamline the list tile processes 
            Column(
              children: [
                ListTile(
                  title: Text("something"),
                  tileColor: Colors.black,
                ),
                ListTile(
                  title: Text("something else"),
                  tileColor: Colors.black,
                ),
              ],
            ),
          ],
        )
      ),
    );
  }
}





/* Challenge Page Checkboxes */
class CheckboxExample extends StatefulWidget {
  const CheckboxExample({super.key});

  @override
  State<CheckboxExample> createState() => _CheckboxExampleState();
}

class _CheckboxExampleState extends State<CheckboxExample> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.white;
    }

    return Checkbox(
      checkColor: Colors.lightGreen,
      fillColor: MaterialStateProperty.resolveWith(getColor),
      value: isChecked,
      onChanged: (bool? value) {
        setState(() {
          isChecked = value!;
        });
      },
    );
  }
}


/* Challenge Page Table */
class ChallengesTable extends StatelessWidget {
  const ChallengesTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Table(
      //border: TableBorder.all(),
      border: const TableBorder(horizontalInside: BorderSide(width: 1, color: Colors.blue, style: BorderStyle.solid)),
      columnWidths: const <int, TableColumnWidth>{
        0: FixedColumnWidth(45),
        1: FixedColumnWidth(95),
        2: FixedColumnWidth(95),
        3: FixedColumnWidth(95),
        4: FixedColumnWidth(90),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: const <TableRow>[
        TableRow(
          children: <Widget>[
            TableCell(
              child: CheckboxExample(),
            ),
            TableCell(
              child: Center(
                child: Text('1 day')),
            ),
            TableCell(
              child: Center(
                child: Text('30')),
            ),
            TableCell(
              child: Center(
                child: Text('Make an eco-brick')),
            ),
            TableCell(
              child: IconButton(
                        icon:  Icon(Icons.info),
                        color: Colors.grey,
                        onPressed: null,
              )
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            TableCell(
              child: CheckboxExample(),
            ),
            TableCell(
              child: Center(
                child: Text('1 day')),
            ),
            TableCell(
              child: Center(
                child: Text('30')),
            ),
            TableCell(
              child: Center(
                child: Text('Make an eco-brick')),
            ),
            TableCell(
              child: IconButton(
                        icon:  Icon(Icons.info),
                        color: Colors.grey,
                        onPressed: null,
              )
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            TableCell(
              child: CheckboxExample(),
            ),
            TableCell(
              child: Center(
                child: Text('1 day')),
            ),
            TableCell(
              child: Center(
                child: Text('30')),
            ),
            TableCell(
              child: Center(
                child: Text('Make an eco-brick')),
            ),
            TableCell(
              child: IconButton(
                        icon:  Icon(Icons.info),
                        color: Colors.grey,
                        onPressed: null,
              )
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            TableCell(
              child: CheckboxExample(),
            ),
            TableCell(
              child: Center(
                child: Text('1 day')),
            ),
            TableCell(
              child: Center(
                child: Text('30')),
            ),
            TableCell(
              child: Center(
                child: Text('Make an eco-brick')),
            ),
            TableCell(
              child: IconButton(
                        icon:  Icon(Icons.info),
                        color: Colors.grey,
                        onPressed: null,
              )
            ),
          ],
        ),
      ]
    );
  }
}