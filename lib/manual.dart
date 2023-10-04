import 'package:flutter/material.dart';

class Manual extends StatelessWidget {
  const Manual({super.key});

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

  Widget progressBar() {
    return Container(
      child: LinearProgressIndicator(
        value: 0.4,
      ),
    );
  }

  Widget textBox() {
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Enter a search term',
      ),
      keyboardType: TextInputType.number
    );
  }

}