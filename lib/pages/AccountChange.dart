import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../back.dart';

class Account extends StatefulWidget {
  final int iduser;
  final String image;
  final String nickname;
  final String email;
  const Account({Key? key,required this.email,required this.image, required this.nickname, required this.iduser});

  @override
  State<Account> createState() => _AccountState();
}


BackEnd be = BackEnd(baseUrl: "http://10.0.2.2:3000");
String img="";
String str="";
late TextEditingController name;



class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFEAF6FF),
        surfaceTintColor: Color(0xFFEAF6FF),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text("Изменение аккаунта",
          style: GoogleFonts.lato(
            textStyle:TextStyle(
                fontSize: 24, fontWeight: FontWeight.w800),
        ),),
        actions: [
          IconButton(
            icon: Icon(Icons.check,
                size: 30,
                color: Colors.black),
            onPressed: () async{
              await be.update(name.text, img,widget.iduser);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Данные обновлены'),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.of(context).pop();
            },
          ),
        ],
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body:
      Container(
        color: Color(0xFFEAF6FF),
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              SizedBox(
                child: (str == "")
                    ? Image.network(widget.image)
                    : Image.file(File(str)),
                width: 292,
                height: 292,

              ),
              SizedBox(height: 8,),

              TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.black, // your color here
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(30)))),
                onPressed: () async {
                  final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    await be.uploadFile(
                        File(pickedFile.path),
                        widget.email,
                        'users',
                        'uploaduser'
                    );
                    setState(() {
                      str = pickedFile.path;
                      img = 'http://10.0.2.2:3000/assets/images/${widget.email}.png';
                    });
                  }
                },
                child: Text("Изменить Аватар",
                    style: GoogleFonts.lato(
                      textStyle:TextStyle(
                          fontSize: 24, fontWeight: FontWeight.w500,color: Colors.black),
                  )
                ),
              ),

              SizedBox(height: 25),

              SizedBox(
                width: 350,
                height: 70,
                child: TextField(

                  style:
                  GoogleFonts.lato(
                    textStyle:TextStyle(
                        fontSize: 28, fontWeight: FontWeight.w600,color: Colors.black),
                  ),
                  controller: name = TextEditingController(text:widget.nickname),
                  decoration: InputDecoration(
                    labelText: 'Изменить Никнейм',
                    labelStyle: GoogleFonts.lato(
                      textStyle:TextStyle(
                          fontSize: 28, fontWeight: FontWeight.w500,color: Colors.black),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 2,

                      )
                      ),
                    fillColor: Colors.white,
                    filled: true,
                    focusedBorder:OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 2,

                        ),
                    ),
                  ),


                  ),
              ),
            ],
          ),
        ),
      ),

    );
  }
}
