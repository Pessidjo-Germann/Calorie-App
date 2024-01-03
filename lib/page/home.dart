import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';

import 'package:flutter/services.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
   bool value=false;
   int? age;
   int? item;
   double taille=135;
   late double calorieBase;
   late double calorieAvecCalorie;
   late double chang;
   List<Widget>radio(){
     List<Widget> L=[];
       Row row= Row(
         children: [
             radiod('faible', 0),
           radiod('moyen', 1),
           radiod('fort', 2),
         ],
       );
     L.add(row);
     return L;
   }
  @override
  Widget build(BuildContext context) {
    Size size= MediaQuery.of(context).size;
    Widget body(){
      return  SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 35.2,horizontal: 13),
          child: Container(
            color: Colors.white38,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 18.0),
                  child: textA('Remplissez toutes les etapes pour obtenir votre besoin journalier en calorie', Colors.black, TextAlign.center,18),
                ),
                Card(
                  elevation: 10,
                  child: Container(
                    color: Colors.white,
                    width: size.width,
                    height: (size.height-(0.38*size.height)),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 14.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              textA("femme", Colors.pink, TextAlign.start, 16),
                              Switch(value: value,
                                  onChanged:(bool l){
                                    setState(() {
                                      value=l;
                                    });
                                  }),
                              textA("homme", Colors.blue, TextAlign.start, 16)
                            ],
                          ),
                        ),
                        Container(
                          color: value?Colors.blue:Colors.pink,
                          width: size.width*0.6,
                          height: 35,
                          child: TextButton(onPressed: montreDate,
                              child: textA((age==null)?"Appuyer pour entrer votre age":"Votre age est de: $age",
                                  Colors.white, TextAlign.center, 16)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0,bottom: 16.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 15.0),
                                child: textA("Votre taille est de ${taille.toInt()} cm", value?Colors.blue:Colors.pink, TextAlign.center, 16),
                              ),
                              Slider(value: taille,
                                  max: 1000,
                                  inactiveColor: Colors.black54,
                                  activeColor: value?Colors.blue:Colors.pink,
                                  onChanged: (double b){
                                    setState(() {
                                      taille=b;
                                    });
                                  })
                            ],
                          ),
                        ),
                        TextField(
                          keyboardType: TextInputType.number,
                          onSubmitted: (String s){
                            setState(() {
                              chang=double.tryParse(s)!;
                            });
                          },
                          decoration: const InputDecoration(
                              labelText: "Entrer votre poids ici"
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 18.0),
                          child: textA("Quel est votre activite sportive?", value?Colors.blue:Colors.pink, TextAlign.center, 14),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              radiod('Faible', 0),
                              radiod('Moyen', 1),
                              radiod('Fort', 2),
                            ],
                          ),
                        )
                      ],
                    ),),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:4.0),
                  child: Container(
                    color: value?Colors.blue:Colors.pink,
                    width: size.width*0.2,
                    height: 35,
                    child: TextButton(onPressed: calculer,
                        child: textA("Calculer",
                            Colors.white, TextAlign.center, 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    if(Platform.isIOS){
      print("Nous sommes sur ios");
    }else{
      print("Nous ne sommes pas sur ios");
    }
    return GestureDetector(
      onTap: (()=>FocusScope.of(context).requestFocus(FocusNode())),
      child: (Platform.isIOS)
          ?CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            backgroundColor: value?Colors.blue:Colors.pink,
            middle: textA("application", Colors.red, TextAlign.center, 12),
          ),
        child: body(),)
          :Scaffold(
        appBar: AppBar(
          title: Text("Calories"),
          centerTitle: true,
          backgroundColor: value?Colors.blue:Colors.pink,
        ),
        body: body()

      ),
    );
  }

  void change(){value=false;}
   void calculer(){
     if(age!=null && taille!=null && item!=null)
     {

       if(value){
         calorieBase=(66.4730+(13.7516*chang)+(5.0083*taille)-(6.7558*age!)).toInt() as double;
       }else{
         calorieBase=(655.0955+(9.5634*chang)+(1.8496*taille)-(4.6756*age!)).toInt() as double;
       }
       switch(item){
         case 0:
           calorieAvecCalorie=(calorieBase* 1.2).toInt() as double;
           break;
         case 1:
           calorieAvecCalorie=(calorieBase* 1.5).toInt() as double;
           break;
         case 2:
           calorieAvecCalorie=(calorieBase* 1.8).toInt() as double;
           break;
         default:
           calorieAvecCalorie=calorieBase;
           break;
       }
       setState(() {
         dialogue();
       });

     }else{
       alerte();

     }
   }
   Future<Null> dialogue()async{
     return showDialog(context: context,
         barrierDismissible: false,
         builder: (BuildContext context){
         return SimpleDialog(
           title: textA("Votre besoin en calories", value?Colors.blue:Colors.pink, TextAlign.center, 16),
           contentPadding: const EdgeInsets.all(15.0),
           children: [
             textA("Votre besoin de base est de: $calorieBase", Colors.black87, TextAlign.center, 15),
             textA("Votre besoin avec activite sportive est de: $calorieAvecCalorie", Colors.black87, TextAlign.center, 15),
             TextButton(onPressed: (){
               Navigator.pop(context);
             },
                 child:textA("OK", value?Colors.blue:Colors.pink, TextAlign.center, 15),

             )
           ],
         );
         }
     );
   }
   Future<Null> alerte()async{
     return showDialog(context: context,
         barrierDismissible: false,
         builder: (BuildContext cont){
          return AlertDialog(
            title: textA("Erreur", value?Colors.blue:Colors.pink, TextAlign.center, 15),
            content: textA("Vous n'avez pas rempli tous les champs", Colors.black87, TextAlign.center, 15),
            actions: [
              TextButton(onPressed: (){
                Navigator.pop(cont);
              },
                  child: textA("OK", value?Colors.blue:Colors.pink, TextAlign.center, 15))
            ],
          );
         }
     );
   }
  Future<Null> montreDate()async{
     var choix = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1992), 
        lastDate: DateTime(2026));
    if(choix != null){
      setState(() {
        age=2023-choix.year;
      });
    }

   }
   Widget radiod(String t,int i ){
     
     return Padding(
       padding: const EdgeInsets.symmetric(horizontal: 26.0),
       child: Column(
         children: [
           Radio(value: i,
               groupValue: item,
               onChanged:(int? i){
                 setState(() {
                   item=i;
                 });
               }
           ),
           textA(t, value?Colors.blue:Colors.pink, TextAlign.center, 16)
         ],
       ),
     );
   }


   Text textA(String data, Color col, TextAlign a, double s){
     return Text(
       data,
       textAlign: a,
       style: TextStyle(
         color: col,
         fontSize: s,
       ),
     );
   }
}
