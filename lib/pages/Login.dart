import 'package:cookrecipe/pages/Home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../back.dart';
import 'Register.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  BackEnd be = BackEnd(baseUrl: "http://10.0.2.2:3000");

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  void setHome() {
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title:  Text("Страница входа",
            style: GoogleFonts.lato(
              textStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
            )),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              const SizedBox(height: 10),
              SizedBox(
                width: 200,
                height: 200,
                child: Image.network('http://10.0.2.2:3000/assets/material/recipebook.png',
                  fit: BoxFit.contain,),
              ),
              Column(
                children: [
                  Text("Книга",
                      style: GoogleFonts.lato(
                        textStyle:TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
                      )),
                  Text("Кулинарных",
                      style: GoogleFonts.lato(
                        textStyle:TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
                      )),
                  Text("Рецептов",
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
                      )),
                ],
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0,30,0,0),
                  child: Column(
                    children: [
                      SizedBox(
                          width: 250,
                          child: TextField(
                            style:
                            GoogleFonts.lato(
                              textStyle:TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w600,color: Colors.black),
                            ),
                            controller: email,
                            decoration:  InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(8)),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 1,

                                  )
                              ),
                              focusedBorder:OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 1,

                                ),
                              ),
                              labelText: 'Логин',
                              labelStyle: GoogleFonts.lato(
                            textStyle:TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w800, color: Colors.black),
                          ),
                            ),
                          )
                      ),
                      const SizedBox(
                        height:20,
                      ),
                      SizedBox(
                          width: 250,
                          child: TextField(
                            style:
                            GoogleFonts.lato(
                              textStyle:TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w600,color: Colors.black),
                            ),
                            controller: password,
                            obscureText: true,
                            decoration:  InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(8)),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 1,

                                  )
                              ),
                              focusedBorder:OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 1,

                                ),
                              ),
                              labelText: 'Пароль',
                              labelStyle: GoogleFonts.lato(
                            textStyle:TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w800, color: Colors.black),
                          ),
                            ),
                          )
                      ),
                      SizedBox(height: 15,),
                      SizedBox(
                        width: 150,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () async{
                            if (email.text.isNotEmpty && password.text.isNotEmpty){
                              Users loggedInUser = await login();
                              if (loggedInUser.UserID != 0) {
                                Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) =>
                                      HomePage(email: email, password: password)),
                                );
                              }
                                else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                   SnackBar(
                                    content: Text('Неправильный логин или пароль', style: GoogleFonts.lato(
                                      textStyle: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white),
                                    ),),
                                    backgroundColor: Colors.redAccent,
                                  ),
                                );
                              }

                              } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                 SnackBar(
                                  content: Text('Поля должны быть заполнены',style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white),
                                  ),),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFEAF6FF),
                              foregroundColor:Color(0xFFEAF6FF),
                          ),
                          child:  Text("Вход",
                              style: GoogleFonts.lato(
                                textStyle:TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.w800,color: Colors.black),
                              )),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context,
                            MaterialPageRoute(builder: (context)=>RegisterPage(setHome: setHome)),
                          );
                        },
                        child:  Text("Регистрация",
                            style: GoogleFonts.lato(
                              textStyle:TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w800, color: Colors.black),
                            ),),
                      ),
                    ],),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Users> login() async{
    Users o = Users(
      UserID: 0,
      Email: email.text,
      Password: password.text,);
     return await be.login(o);
  }
}




