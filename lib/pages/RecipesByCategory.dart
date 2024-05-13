import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../back.dart';
import 'Insert.dart';
import 'package:http/http.dart' as http;
import 'Recipe.dart';



class SearchByCategory extends StatefulWidget {

  final String name;
  final String email;
  final String password;


  const SearchByCategory({super.key,required this.name,required this.email,required this.password});

  @override
  State<SearchByCategory> createState() => _SearchByCategoryState();
}

class _SearchByCategoryState extends State<SearchByCategory> {

  BackEnd be = BackEnd(baseUrl: "http://10.0.2.2:3000");


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFFEAF6FF),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50,
                    width: 360,
                    child: TextField(
                      textAlignVertical: TextAlignVertical.top,
                      style: TextStyle(fontSize: 18),
                      controller: nameController,
                      textCapitalization: TextCapitalization.sentences,
                      onChanged: (text) {
                        updateList();
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        focusedBorder: OutlineInputBorder( // Новое свойство focusedBorder
                          borderRadius: BorderRadius.circular(40),
                          borderSide: BorderSide(color: Colors.black), // Установка черного цвета границы при фокусе
                        ),
                        fillColor: Colors.white, // Установка цвета фона на белый
                        filled: true,
                      ),
                    ),
                  ),
                ],
              ),

              Expanded(
                child: FutureBuilder<List<Recipes>>(
                  future: be.SearchByCategory(Recipes(
                      RecipeID: 0,
                      UserID: 0,
                      Name: nameController.text,
                      Image: "",
                      Description: [],
                      Products: [],
                      Category: widget.name,
                      Tag: "",
                      Video: "",)),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Recipes>> snapshot) {
                    if (snapshot.hasData) {
                      List<Recipes>? items = snapshot.data;
                      if (items != null) {
                        return ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(7.5,8,7.5,0),
                              child: SizedBox(
                                width: 370,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Recipe(
                                          name: items[index].Name,
                                          id: items[index].RecipeID,
                                          email: widget.email,
                                          password: widget.password,
                                          urlvid: items[index].Video,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Card(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8), // Применяем округление краев к Card
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          color: Colors.white,
                                          child: SizedBox(
                                            width: 370,
                                            height: 200,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(8),
                                              child: Image.network(
                                                '${items[index].Image}',
                                                fit: BoxFit.fitWidth,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Container(
                                          color: Colors.white,
                                          child: SizedBox(
                                            width: 370,
                                            child: Padding(
                                              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${items[index].Name}',
                                                    style: GoogleFonts.lato(
                                                      textStyle: TextStyle(
                                                          fontSize: 24,
                                                          fontWeight: FontWeight.w700),
                                                    ),
                                                  ),
                                                  Text(
                                                    '${items[index].Category}',
                                                    style: GoogleFonts.lato(
                                                      textStyle: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.w500),
                                                    ),
                                                  ),
                                                  Text(
                                                    '${items[index].Tag}',
                                                    style: GoogleFonts.lato(
                                                      textStyle: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.w500),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }
                    } else {
                      return Center(
                        child: Text("Empty"),
                      );
                    }
                    return CircularProgressIndicator();
                  },
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }
  void updateList() {
    setState(() {
    });
  }
}
