import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../back.dart';
import 'Login.dart';

class RegisterPage extends StatefulWidget {
  VoidCallback setHome;

  RegisterPage({Key? key, required this.setHome}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  BackEnd be = BackEnd(baseUrl: "http://10.0.2.2:3000");

  void setInsert() {
    setState(() {});
  }

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController password1 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Text("Регистрация",
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
                child: Image.network(
                  'http://10.0.2.2:3000/assets/material/recipebook.png',
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: Column(
                    children: [
                      SizedBox(
                          width: 250,
                          child: TextField(
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                            controller: email,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 1,
                                  )),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                              labelText: 'Логин',
                              labelStyle: GoogleFonts.lato(
                                textStyle: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black),
                              ),
                            ),
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                          width: 250,
                          child: TextField(
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                            controller: password,
                            obscureText: true,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 1,
                                  )),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                              labelText: 'Пароль',
                              labelStyle: GoogleFonts.lato(
                                textStyle: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black),
                              ),
                            ),
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                          width: 250,
                          child: TextField(
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                            controller: password1,
                            obscureText: true,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 1,
                                  )),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                              labelText: 'Повторите пароль',
                              labelStyle: GoogleFonts.lato(
                                textStyle: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black),
                              ),
                            ),
                          )),
                      SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width: 200,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (await be.isEmailUnique(email.text) == true) {
                              if (password.text == password1.text &&
                                  email.text.isNotEmpty &&
                                  password.text.isNotEmpty) {
                                insert();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Данные введены успешно',
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white),
                                      ),
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              } else
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Пароль не совпадает',
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white),
                                      ),
                                    ),
                                    backgroundColor: Colors.redAccent,
                                  ),
                                );
                            } else
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Аккаунт с таким email уже создан',
                                    style: GoogleFonts.lato(
                                      textStyle: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white),
                                    ),
                                  ),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFEAF6FF),
                            foregroundColor: Color(0xFFEAF6FF),
                          ),
                          child: Text(
                            "Регистрация",
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginPage()),
                          );
                        },
                        child: Text(
                          "Вход",
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void insert() async {
    Users o = Users(
        UserID: 0,
        Image: "http://10.0.2.2:3000/assets/images/avatar.png",
        Email: email.text,
        Password: password.text,
        NickName: "NickName");
    await be.post(o);
    widget.setHome();
    Navigator.of(context).pop();
  }
}
