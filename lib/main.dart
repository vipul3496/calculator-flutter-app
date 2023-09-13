import 'package:flutter/material.dart';
import 'package:flutter_project/colours.dart';

void main(){
  runApp(const MaterialApp(
    home: CalculatorApp(),
    debugShowCheckedModeBanner: false,
  ));
}
class CalculatorApp extends StatefulWidget{
  const CalculatorApp({Key? key}) : super(key: key);

  @override
  State<CalculatorApp> createState() => _CalculatorAppState();
}
class _CalculatorAppState extends State<CalculatorApp>{
  //variable
  double firstNum=0.0;
  double secondNum=0.0;
  var input = '';
  var output = '';
  var operation = '';
  var hideInput = false;
  var outputSize = 34.0;
  var outputColor = Colors.white.withOpacity(0.7);

  onButtonClick(value)
  {

    //expression handling
    List<String> tokenize(String expression) {
      List<String> tokens = [];
      String currentToken = '';

      for (int i = 0; i < expression.length; i++) {
        String char = expression[i];

        if (char == '+' || char == '-' || char == 'x' || char == '/' || char == '%') {
          if (currentToken.isNotEmpty) {
            tokens.add(currentToken);
            currentToken = '';
          }
          tokens.add(char);
        } else {
          currentToken += char;
        }
      }

      if (currentToken.isNotEmpty)
      {
        tokens.add(currentToken);
      }

      return tokens;
    }

    double evaluate(List<String> tokens)
    {
      double result = double.parse(tokens[0]);

      for (int i = 1; i < tokens.length; i += 2)
      {
        String operator = tokens[i];
        double operand = double.parse(tokens[i + 1]);

        if (operator == '+') {
          result += operand;
        } else if (operator == '-') {
          result -= operand;
        } else if (operator == 'x') {
          result *= operand;
        } else if (operator == '/') {
          result /= operand;
        } else if (operator == '%') {
          result = result * operand/100;
        }
      }

      return result;
    }

    String evaluateExpression(String expression)
    {
      List<String> tokens = tokenize(expression);
      double result = evaluate(tokens);
      String s = result.toString();
      if(s.endsWith(".0")){
        s =s.substring(0,s.length-2);
      }
      input = s;
      output = '';
      hideInput = true;
      outputSize = 52;
      outputColor = Colors.white;

      return s;
    }

    //if value is AC
    if(value== "AC")
      {
        input = '';
        output = '';
      }
    else if(value == "C")
      {
        if(input.isNotEmpty)
        {
          input = input.substring(0, input.length - 1);
        }
      }
    else if(value == "=")
      {
        if(input.isNotEmpty)
        {
          output = evaluateExpression(input);
          input = output;
        }

      }
    else if(value == "."){
      if (!input.endsWith('.')) {
        input += value;
      }
    }
    else {
      // Check if the input is empty and the pressed button is an operator.
      if (input.isEmpty && isOperator(value)) {
        return;
      }

      // Check if the pressed button is an operator and the last character in the input is also an operator.
      if (isOperator(value) && isOperator(input.characters.last)) {
        // Replace the last character in the input with the new operator.
        input = input.substring(0, input.length - 1) + value;
      } else {
        input = input + value;
      }

      hideInput = false;
      outputSize = 34;
      outputColor = Colors.white.withOpacity(0.7);
    }
    setState(() {

    });



  }
  bool isOperator(String value) {
    return ['+', '-', 'x', '/', '%'].contains(value);
  }




  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 20),
              child: const Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 16.0), // Add padding to the top
                  child: Text(
                    "Calculator",
                    style: TextStyle(
                      fontSize: 55,
                      color: Colors.amber,
                    ),
                  ),
                )

              ],),
            ),
          ),

          //input output area
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment:MainAxisAlignment.end,
                crossAxisAlignment:CrossAxisAlignment.end ,
                children: [
                  Text(
                   hideInput ? '' : input,
                    style: const TextStyle(
                    fontSize: 48,
                    color: Colors.white,
                  ),
                  ),
                   const SizedBox(
                    height: 20,
                  ),
                  Text(
                    output,
                    style: TextStyle(
                      fontSize: outputSize,
                      color: outputColor,
                    ),
                  ),
                   const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            )
          ),


          //buttons area
          Row(
            children: [
              button(text: "AC", buttonBgColor: operatorColor, tColor: redColor),
              button(text: "C",buttonBgColor: operatorColor, tColor: redColor),
              button(text: "%",buttonBgColor: operatorColor, tColor: redColor),
              button(text: "/",buttonBgColor: operatorColor, tColor: redColor)],
          ),
          Row(
            children: [
              button(text: "7"),
              button(text: "8"),
              button(text: "9"),
              button(text: "x",buttonBgColor: operatorColor,tColor: redColor)],
          ),
          Row(
            children: [
              button(text: "4"),
              button(text: "5"),
              button(text: "6"),
              button(text: "-",buttonBgColor: operatorColor, tColor: redColor)],
          ),
          Row(
            children: [
              button(text: "1"),
              button(text: "2"),
              button(text: "3"),
              button(text: "+",buttonBgColor: operatorColor, tColor: redColor)],
          ),
          Row(
            children: [
              button(text: "00"),
              button(text: "0"),
              button(text: "."),
              button(text: "=",tColor: Colors.white,buttonBgColor: redColor)],
          )
        ],
      ),
    );
  }

  Widget button(
  {
    text ,tColor = Colors.white,
    buttonBgColor = numbuttonColor
}
      ){
    return Expanded(
          child: Container(
            margin: EdgeInsets.all(8),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(22),
                  backgroundColor: buttonBgColor,
                ),
                onPressed: ()=> onButtonClick(text),
                child: Text(text,style: TextStyle(
                  fontSize: 18,
                  color: tColor,
                  fontWeight: FontWeight.bold,
                ),)),
          )
      );
  }

}
