import 'package:bmi_project_1/widget/app_input_field.dart';
import 'package:flutter/material.dart';

enum HeightType{cm,feetInch}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}
class _CalculatorScreenState extends State<CalculatorScreen> {
  HeightType? heightType = HeightType.cm;

  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _cmHeightController = TextEditingController();
  final TextEditingController _feetHeightController = TextEditingController();
  final TextEditingController _inchHeightController = TextEditingController();

  String _bmiResult = "";

  String? category;
  //BMI = weight (kg) / height (meter)²

  double? cmToM(){
    final cm = double.tryParse(_cmHeightController.text.trim());
    if(cm==null || cm<0) return null;
    return cm/100.0;
  }
  
double? feetInchToM() {
  final feet = double.tryParse(_feetHeightController.text.trim());
  final inch = double.tryParse(_inchHeightController.text.trim());
  if (feet == null || feet < 0 || inch == null || inch < 0) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid Data')));
    return null;
  };
 
  final totalInch = (feet * 12) + inch;
  if(totalInch <=0){
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid Data')));
    return null;
  }
  return totalInch*0.0254;
}
//calculation
void _calculate(){
    final weight= double.tryParse(_weightController.text.trim());
    if(weight == null || weight <0){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid Data')));
      return;
    }
  
    final m = heightType == HeightType.cm? cmToM() :feetInchToM();
    if(m == null){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid Data')));
      return;
    }
    final bmi = weight/(m*m);
    final cat = categoryResult(bmi);
  setState(() {
    _bmiResult = bmi.toStringAsFixed(2);
    category = cat;
  });
}
String categoryResult (double bmi){
    if(bmi<18.5)return "underweight";
    if(bmi<25)return "Normal";
    if(bmi<30)return "overweight";
    return "obease";
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BMI Calculator'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        children: [
          Text('Weight Unit'),
          AppInputField(
            labelText:  'Enter weight in kg',
            textInputType: TextInputType.number,
            controller: _weightController,
          ),
          const SizedBox(height: 8,),
          Text('Height Unit'),
          SegmentedButton<HeightType>(
              segments:[
                ButtonSegment<HeightType>(
                  label: Text('CM'),
                    value:HeightType.cm
                ),
                ButtonSegment<HeightType>(
                    label: Text('Feet Inch'),
                    value:HeightType.feetInch
                )
              ] ,
              selected: {heightType!},
            onSelectionChanged: (value){
                setState(() {
                  heightType = value.first;
                });
            },
          ),
          SizedBox(height: 16,),
          Text('Height Type'),
          if (heightType == HeightType.cm)...[
            AppInputField(
              labelText:  'Enter Height in cm',
              textInputType: TextInputType.number,
              controller: _cmHeightController,
            ),
          ]else...[
            Row(
              children: [
                Expanded(
                  child:AppInputField(
                  labelText:  'Enter Height (Feet) ',
                  textInputType: TextInputType.number,
                  controller: _feetHeightController,
                ),
                ),
                SizedBox(width: 16,),
                Expanded(
                  child:AppInputField(
                    labelText:  'Enter Height (Inch) ',
                    textInputType: TextInputType.number,
                    controller:_inchHeightController,
                  ),
                ),
              ],
            )
          ],
          const SizedBox(height: 16,),
          ElevatedButton(onPressed:_calculate,
              child: Text('Calculator BMI'),
          ),
          const SizedBox(height: 16,),
          Text('BMI Result $_bmiResult',style: TextStyle(fontWeight: FontWeight.normal,fontSize: 20,color: Colors.teal),),
          const SizedBox(height: 16,),
          if(category != null)
          Text('BMI Result l$category',style: TextStyle(fontSize: 20,fontWeight: FontWeight.normal,color: Colors.teal),),
        ],
      ),
    );
  }
}

