/// 
/// challenge_page.dart
/// Initializes ChallengePage and PastChallengesPage classes for eMision Application.
/// 
/// 
/// Created: Chris Warren


// import statements
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



/*
    Initializes ChallengePage Class and returns a container of the pages various Widgets
*/
class ChallengePage extends StatelessWidget {
  const ChallengePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(16.0),
        color: const Color.fromRGBO(255, 168, 48, 100),
        child:  const Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children:<Widget> [
            ToggleButton(isPastPage: false),
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
      );
  }
}



/*
    A custom ToggleButton Widget that returns a CupertinoSegmentedControl Button.
    This button gives the user the ability to toggle between the current and past challenges.
    The constructor initializes a boolean value (isPastPage) that determines whether or not the past 
    challenges page is being displayed. 
    
    If isPastPage is true, the past_challenges route is pushed from the Navigator and the Segmented Button color is changed.
*/
class ToggleButton extends StatelessWidget {
  final bool isPastPage;

  const ToggleButton({super.key, required this.isPastPage});

  @override
  Widget build(BuildContext context){
    return CupertinoSegmentedControl<String>(
      padding: const EdgeInsets.all(20.0),
      borderColor: Colors.black,
      children: {
        'Past': Container(
          color: isPastPage 
          ? Colors.orange[300]
          : Colors.grey,
          padding: const EdgeInsets.fromLTRB(9.5,5,9.5,5.8),
          child: const Text("Past Challenges"),
        ),
        'Current': Container(
          color: isPastPage
          ? Colors.grey
          : Colors.orange[300],
          padding: const EdgeInsets.fromLTRB(1,5,1.3,5.8),
          child: const Text("Current Challenges")
        ),
      },
      onValueChanged: (String value){
        if (value == 'Past'){
          Navigator.of(context).pop();
          Navigator.pushNamed(context, 'past_challenges');
        } else {
          Navigator.of(context).pop();
          Navigator.pushNamed(context, 'challenges');
        } 
      },
    );
  }
}

 

/* 
    The PastChallengesPage custom widget class returns a container with the widgets and assets necessary to display the user's 
    past/completed challenges, along with any badges the user has earned.
*/
class PastChallengesPage extends StatelessWidget {
  const PastChallengesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color:const Color.fromRGBO(124, 184, 22, 100),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children:<Widget> [
          Container(
            padding: const EdgeInsets.all(18.0),
            color: Colors.lightBlueAccent,
            child: const Text("Profile_Info"),
          ),
          const ToggleButton(isPastPage: true),
          // May need to create a '_tile' class to streamline the list tile processes 
          Column(
            children: [
              Table(
                border: const TableBorder(horizontalInside: BorderSide(width: 1, color: Color.fromRGBO(124, 184, 22, 100), style: BorderStyle.solid)),
                columnWidths: const <int, TableColumnWidth>{
                  0: FixedColumnWidth(50),
                  1: FlexColumnWidth(),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: const <TableRow>[
                  TableRow(
                    children: <Widget>[
                      TableCell(
                        child: Icon(
                          Icons.park_outlined,
                          color: Colors.lightBlue,
                        ),
                      ),
                      TableCell(
                        child: Text("Tree Hugger Badge"),
                      ),
                    ],
                  ),
                  TableRow(
                    children: <Widget>[
                      TableCell(
                        child: Icon(
                          Icons.star,
                          color: Colors.yellowAccent,
                        ),
                      ),
                      TableCell(
                        child: Text("Energy Saver Star"),
                      ),
                    ],
                  ),
                  TableRow(
                    children: <Widget>[
                      TableCell(
                        child: Icon(
                          Icons.emoji_events_outlined,
                          color: Colors.yellow,
                        ),
                      ),
                      TableCell(
                        child: Text("Recycle Medal"),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      )
    );
  }
}









/* 
    The Checkbox Example class creates and returns a Checkbox Widget that is rendered on the ChallengePage.
    This checkbox can be clicked by the user changing it's state and color accordingly.
 */
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


/* 
    The ChallengesTable Widget class returns a Table Widget to the application's Challenges Page. 
    This table has 5 columns and lists the current challenges that the user can attempt alongside the number of points
    the challenge is worth. 
*/
class ChallengesTable extends StatelessWidget {
  const ChallengesTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Table(
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