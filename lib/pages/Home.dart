import 'package:cookrecipe/pages/AccountChange.dart';
import 'package:cookrecipe/pages/RecipeByTag.dart';
import 'package:cookrecipe/pages/RecipesByCategory.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cookrecipe/pages/login.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../back.dart';
import 'Insert.dart';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'Recipe.dart';
import 'package:dropdown_search/dropdown_search.dart';

class HomePage extends StatefulWidget {
  final TextEditingController email;
  final TextEditingController password;

  const HomePage({Key? key, required this.email, required this.password})
      : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  BackEnd be = BackEnd(baseUrl: "http://10.0.2.2:3000");

  TextEditingController nameController = TextEditingController();
  TextEditingController NickNameContrl = TextEditingController();
  String urlvideo = "";
  String NickName = "NickName";
  int currentPageIndex = 1;
  int id = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      bottomNavigationBar: NavigationBar(

        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor:Color(0xFFEAF6FF),
        surfaceTintColor:Color(0xFFEAF6FF),
        shadowColor:Color(0xFFEAF6FF),
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.search),
            icon: Icon(Icons.search_outlined),
            label: 'Search',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.person_2),
            icon: Icon(Icons.person_2_outlined),
            label: 'Account',
          ),
        ],
      ),
      body: <Widget>[
        /// Search
        Container(
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
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        ),
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
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                      ),
                    ),
                  ],
                ),


                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: FutureBuilder<List<Recipes>>(
                    future: be.findName(Recipes(
                        RecipeID: 0,
                        UserID: 0,
                        Name: nameController.text,
                        Image: "",
                        Description: [],
                        Products: [],
                        Category: "",
                        Tag: "",
                        Video: "")),
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
                                            email: widget.email.text,
                                            password: widget.password.text,
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

        /// Home page
        Container(
          color: Color(0xFFEAF6FF),
          child: ListView(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(100,20,10,10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("Книга Кулинарных",
                            style: GoogleFonts.poppins(
                              textStyle:TextStyle(
                                  fontSize: 28, fontWeight: FontWeight.bold),
                            )),
                        Text("Рецептов",
                            style: GoogleFonts.poppins(
                              textStyle:TextStyle(
                                  fontSize: 28, fontWeight: FontWeight.bold),
                            )),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CardsCategory(
                          "Завтрак",
                          "http://10.0.2.2:3000/assets/material/Zavtrak.jpg",
                          "Завтрак",
                          170,
                          200),
                      SizedBox(width: 10,),
                      CardsCategory(
                          "Обед",
                          "http://10.0.2.2:3000/assets/material/Obed.jpg",
                          "Обед",
                          170,
                          200),
                    ],
                  ),
                  SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CardsCategory(
                          "Ужин",
                          "http://10.0.2.2:3000/assets/material/Ujin.jpg",
                          "Ужин",
                          170,
                          200),
                      SizedBox(width: 10,),
                      CardsCategory(
                          "Перекус",
                          "http://10.0.2.2:3000/assets/material/Perekys.jpg",
                          "Перекус",
                          170,
                          200),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Divider(thickness: 1,),
              ),
              Center(
                child: Text("Популярный рецепт",
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600),
                  ),),
              ),

              FutureBuilder<Recipes>(future: be.PopularRecipe(),
                  builder: (BuildContext context, AsyncSnapshot<Recipes> snapshot) {
                if (snapshot.hasData){
                  Recipes? items = snapshot.data;
                  if (items != null){
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
                                  name: items.Name,
                                  id: items.RecipeID,
                                  email: widget.email.text,
                                  password: widget.password.text,
                                  urlvid: items.Video,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
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
                                        '${items.Image}',
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
                                            '${items.Name}',
                                            style: GoogleFonts.lato(
                                              textStyle: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                          Text(
                                            '${items.Category}',
                                            style: GoogleFonts.lato(
                                              textStyle: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          Text(
                                            '${items.Tag}',
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

                  }
                }
                return CircularProgressIndicator();
              }),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: Divider(thickness: 1,),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Text(
                  "Рецепты по категории",
                  style: GoogleFonts.lato(
                    textStyle:TextStyle(
                        fontSize: 24, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                child: Column(
                  children: [
                    CardsTag(
                        "Холодные закуски",
                        "http://10.0.2.2:3000/assets/material/Hol.Zakys.png",
                        "Холодные закуски",
                        360,
                        90),
                    CardsTag(
                        "Горячие закуски",
                        "http://10.0.2.2:3000/assets/material/Gor.Zakys.png",
                        "Горячие закуски",
                        360,
                        90),
                    CardsTag(
                        "Салаты",
                        "http://10.0.2.2:3000/assets/material/Salat.png",
                        "Салаты",
                        360,
                        90),
                    CardsTag(
                        "Супы",
                        "http://10.0.2.2:3000/assets/material/Syp.png",
                        "Супы",
                        360,
                        90),
                    CardsTag(
                        "Горячие блюда",
                        "http://10.0.2.2:3000/assets/material/Gor.Bludo.png",
                        "Горячие блюда",
                        360,
                        90),
                    CardsTag(
                        "Гарниры",
                        "http://10.0.2.2:3000/assets/material/Garnir.png",
                        "Гарниры",
                        360,
                        90),
                    CardsTag(
                        "Десерты",
                        "http://10.0.2.2:3000/assets/material/Desert.png",
                        "Десерты",
                        360,
                        90),
                    CardsTag(
                        "Напитки",
                        "http://10.0.2.2:3000/assets/material/Napitki.png",
                        "Напитки",
                        360,
                        90),
                  ],
                ),
              )
            ],
          ),
        ),

        /// Account page
        Container(
          color: Color(0xFFEAF6FF),
          child: Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Align(
              alignment: Alignment.topCenter,
              child: FutureBuilder<Users>(
                future: be.login(Users(
                  UserID: 0,
                  Email: "${widget.email.text}",
                  Password: "${widget.password.text}",
                )),
                builder: (BuildContext context, AsyncSnapshot<Users> snapshot) {
                  if (snapshot.hasData) {
                    Users? items = snapshot.data;
                    if (items != null) {
                      return Column(
                        children: [
                          CircleAvatar(
                            radius: 80,
                            backgroundImage: NetworkImage(
                                "${items?.Image}?${DateTime.now().millisecondsSinceEpoch}"),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(width: 40),
                              Text(
                                '${items?.NickName}',
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                      fontSize: 28, fontWeight: FontWeight.w700),
                                ),
                              ),
                              SizedBox(
                                  width: 40,
                                  child: IconButton(
                                      onPressed: () async {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Account(
                                                  email: items.Email.toString(),
                                                  image: items.Image.toString(),
                                                  nickname:
                                                      items.NickName.toString(),
                                                  iduser: items.UserID)),
                                        );
                                        setState(() {});
                                      },
                                      icon: Icon(Icons.edit)))
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        Insert(iduser: items.UserID),
                                  ));
                            },
                            child: Text(
                              "Загрузить рецепт",
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          Container(
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              color:Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15.0),
                                topRight: Radius.circular(15.0),
                              ),
                            ),
                            child: SizedBox(
                            width: 370,
                              child: Text(
                                " Мои рецепты:",
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(15.0),
                                bottomRight: Radius.circular(15.0),
                              ),
                            ),
                            child: SizedBox(
                              height: 370,
                              width: 370,
                              child: FutureBuilder<List<Recipes>>(
                                future: be.RecipesByUser(items.UserID),
                                builder: (BuildContext context,
                                    AsyncSnapshot<List<Recipes>> snapshot) {
                                  if (snapshot.hasData) {
                                    List<Recipes>? items = snapshot.data;
                                    if (items != null) {
                                      return Container(
                                        color:Colors.white,
                                        child: ListView.builder(
                                            itemCount: items.length,
                                            itemBuilder: (context, index) {
                                              return Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    10, 0, 0, 10),
                                                child: Container(
                                                  color:Colors.white,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => Recipe(
                                                                name: items[index]
                                                                    .Name,
                                                                id: items[index]
                                                                    .RecipeID,
                                                                email: widget
                                                                    .email.text,
                                                                password: widget
                                                                    .password
                                                                    .text,
                                                                urlvid:
                                                                    items[index]
                                                                        .Video)),
                                                      );
                                                    },
                                                    child: Container(
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            width: 70,
                                                            height: 70,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape:
                                                                  BoxShape.circle,
                                                              image:
                                                                  DecorationImage(
                                                                fit: BoxFit.cover,
                                                                image: NetworkImage(
                                                                    '${items[index].Image}'),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(width: 10),
                                                          Expanded(
                                                            child: Text(
                                                              '${items[index].Name}',
                                                              softWrap: true,
                                                              style: GoogleFonts
                                                                  .lato(
                                                                textStyle: TextStyle(
                                                                    fontSize: 25,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),
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
                          ),
                        ],
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
          ),
        )
      ][currentPageIndex],
    );
  }

  void updateList() {
    setState(() {});
  }

  CardsCategory(
      String text, String image, String name, double width, double height) {
    return Column(
      children: [
        SizedBox(
          width: width,
          height: height,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SearchByCategory(
                        name: name,
                        email: widget.email.text,
                        password: widget.password.text)),
              );
            },
            child: Card(
              color: Colors.white,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        child: Image.network(
                          image,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        child: Text(
                          text,
                            style: GoogleFonts.lato(
                              textStyle:TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  CardsTag(
      String text, String image, String name, double width, double height) {
    return Row(
      children: [
        SizedBox(
          width: width,
          height: height,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SearchByTag(
                        name: name,
                        email: widget.email.text,
                        password: widget.password.text)),
              );
            },
            child: Card(
              color:Colors.white,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: Container(
                  color: Colors.white,
                  child: Row(
                    children: [
                      ClipRRect(
                        child: Image.network(
                          image,
                          fit: BoxFit.fill,
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        color: Colors.white,
                        child: Text(
                          text,
                          style: GoogleFonts.lato(
                            textStyle:TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
