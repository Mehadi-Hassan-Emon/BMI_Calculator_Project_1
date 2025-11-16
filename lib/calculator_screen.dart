import 'package:bmi_project_1/widget/app_input_field.dart';
import 'package:flutter/material.dart';

enum HeightType{cm,feetInch}//ei widget use hoi bcz bmi calculator e inc naki feet te amra result pacci ta dekhte

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}
class _CalculatorScreenState extends State<CalculatorScreen> {
  HeightType? heightType = HeightType.cm;//heighttype ta cm e dekhabe

  final TextEditingController _weightController = TextEditingController();//
  final TextEditingController _cmHeightController = TextEditingController();
  final TextEditingController _feetHeightController = TextEditingController();
  final TextEditingController _inchHeightController = TextEditingController();

  String _bmiResult = "";//bmi result er jonno ekta string nise

  String? category;//bmi ta kon category ta jar jonno

  //BMI = weight (kg) / height (meter)²

  //bmi cm dile m e covert korse
  double? cmToM(){//cm to  meter
    final cm = double.tryParse(_cmHeightController.text.trim());//cm ta text e nibe
    if(cm==null || cm<0) return null;
    return cm/100.0;//cm to meter e nite 100 diye vhag
  }
  //tai feetinch dile m e covert korse
double? feetInchToM() {
  final feet = double.tryParse(_feetHeightController.text.trim());
  final inch = double.tryParse(_inchHeightController.text.trim());
  if (feet == null || feet < 0 || inch == null || inch < 0) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid Data'))); //eitar dileo hobe
    return null; //eita dileo hobe

  };
  //feet direct meter e convert korar kono formula nai tai ageh inch e conver hoi then inch er sathe m covert hoy erpor bmi
  final totalInch = (feet * 12) + inch;
  if(totalInch <=0){
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid Data')));
    return null;
  }
  return totalInch*0.0254;//inch theke meter e convert bcaz 1 inch =0.0254
}
//calculation
void _calculate(){
    final weight= double.tryParse(_weightController.text.trim());
    if(weight == null || weight <0){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid Data')));
      return;
    }
    //jodi ta cmtom naki feettom ageh dibe ta check
    final m = heightType == HeightType.cm? cmToM() :feetInchToM();
    if(m == null){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid Data')));
      return;
    }
    final bmi = weight/(m*m);
    final cat = categoryResult(bmi);//categoryresult er dekhbe and bmi ta bolbe
  setState(() {
    _bmiResult = bmi.toStringAsFixed(2);//. por 2 ta ghor nivbo pojjonto nibo
    category = cat;
  });
}
//je weight ta dibe ta overweight kina chceck korbo
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
              segments:[//heighttype ta list akare dibe
                ButtonSegment<HeightType>(//button ektai cm
                  label: Text('CM'),
                    value:HeightType.cm
                ),
                ButtonSegment<HeightType>(//button arektai kg dekhabe
                    label: Text('Feet Inch'),
                    value:HeightType.feetInch
                )
              ] ,
              selected: {heightType!},//by default height ta cm e thakbe
            onSelectionChanged: (value){//onclick e value change
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

