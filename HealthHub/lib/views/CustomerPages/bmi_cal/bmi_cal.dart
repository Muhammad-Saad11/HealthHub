import 'package:flutter/material.dart';

class BMICalculatorScreen extends StatefulWidget {
  @override
  _BMICalculatorScreenState createState() => _BMICalculatorScreenState();
}

class _BMICalculatorScreenState extends State<BMICalculatorScreen> {
  double _height = 160; // in centimeters
  double _weight = 60; // in kilograms

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BMI Calculator'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Image.asset("assets/bmi.png"),
            Text(
              'Enter your height (cm):',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Slider(
              activeColor: Colors.black,
              value: _height,
              min: 100,
              max: 250,
              divisions: 150,
              label: _height.round().toString(),
              onChanged: (value) {
                setState(() {
                  _height = value;
                });
              },
            ),
            Text(
              'Enter your weight (kg):',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Slider(
              activeColor: Colors.black,
              value: _weight,
              min: 20,
              max: 200,
              divisions: 180,
              label: _weight.round().toString(),
              onChanged: (value) {
                setState(() {
                  _weight = value;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                double bmi = _weight / ((_height / 100) * (_height / 100));
                String result = bmi.toStringAsFixed(1);
                String interpretation;
                if (bmi < 18.5) {
                  interpretation = 'Underweight';
                } else if (bmi < 24.9) {
                  interpretation = 'Normal weight';
                } else if (bmi < 29.9) {
                  interpretation = 'Overweight';
                } else {
                  interpretation = 'Obese';
                }
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('BMI Result'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Your BMI: $result'),
                        Text('Interpretation: $interpretation'),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Close',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                );
              },
              child: Text(
                'Calculate BMI',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
