import 'package:cookrecipe/pages/Insert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../back.dart';

class Recipe extends StatefulWidget {
  final int id;
  final String name;
  final String email;
  final String password;
  final String urlvid;

  const Recipe(
      {Key? key,
      required this.name,
      required this.id,
      required this.email,
      required this.password,
      required this.urlvid})
      : super(key: key);

  @override
  State<Recipe> createState() => _RecipeState();
}

class _RecipeState extends State<Recipe> {
  BackEnd be = BackEnd(baseUrl: "http://10.0.2.2:3000");
  TextEditingController comment = TextEditingController();
  bool isPlaying = true;
  late YoutubePlayerController _controller;

  void initState() {
    super.initState();
    if (widget.urlvid != "") {
      _controller = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(widget.urlvid)!,
        flags: YoutubePlayerFlags(
          autoPlay: false,
          mute: true,
        ),
      );
      _controller.addListener(() {
        final playerState = _controller.value.playerState;
        if (playerState == PlayerState.playing) {
          setState(() {
            isPlaying = true;
          });
        } else {
          setState(() {
            isPlaying = false;
          });
        }
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFEAF6FF),
        surfaceTintColor: Color(0xFFEAF6FF),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.name,
                style: GoogleFonts.lato(
                  textStyle:
                      TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                )),
            SizedBox(
              width: 40,
            )
          ],
        ),
      ),
      body: Container(
        color: Color(0xFFEAF6FF),
        child: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder<Recipes>(
                future: be.getRecipeById(widget.id),
                builder:
                    (BuildContext context, AsyncSnapshot<Recipes> snapshot) {
                  if (snapshot.hasData) {
                    Recipes? items = snapshot.data;
                    if (items != null) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: 290,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  '${items.Image}',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Рецепт по шагам",
                            style: GoogleFonts.lato(
                              textStyle:TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w800),
                            ),
                          ),
                          Container(
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),),
                            child: SizedBox(
                              width: 370,
                              child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: items.Description.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    color: Colors.white,
                                    child: ListTile(
                                      tileColor: Colors.white,
                                      title: Text(
                                        'Шаг ${items.Description[index].StepNumber}. ${items.Description[index].Step}',
                                        style: GoogleFonts.lato(
                                          textStyle:TextStyle(
                                              fontSize: 20, fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          const Divider(
                            color: Colors.grey,
                          ),
                          Text(
                            'Список продуктов:',
                            style:
                              GoogleFonts.lato(
                                textStyle:TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.w800),
                              ),

                          ),
                          Container(
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),),
                            child: SizedBox(
                              width: 370,
                              child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: items.Products.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 0, 0),
                                      child: ListTile(
                                        tileColor:Colors.white,
                                        dense: true,
                                        // устанавливаем параметр dense для уменьшения расстояния между элементами
                                        contentPadding:
                                            EdgeInsets.symmetric(vertical: 0),
                                        title: Text(
                                          ' ${items.Products[index].ProductID}:${items.Products[index].Name} ${items.Products[index].Weight}гр.',
                                          style: GoogleFonts.lato(
                                            textStyle:TextStyle(
                                                fontSize: 20, fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          if (items.Video != "")
                            Builder(builder: (context) {
                              if (items.Video != "") {
                                return Column(
                                  children: [
                                    const Divider(
                                      color: Colors.grey,
                                    ),
                                    Text(
                                      "Видео-рецепт",
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        if (isPlaying) {
                                          _controller.pause();
                                        } else {
                                          _controller.play();
                                        }
                                        print(isPlaying);
                                      },
                                      child: Container(
                                        child: YoutubePlayer(
                                          controller: _controller,
                                          showVideoProgressIndicator: true,
                                          progressIndicatorColor: Colors.amber,
                                          progressColors:
                                              const ProgressBarColors(
                                            playedColor: Colors.amber,
                                            handleColor: Colors.amberAccent,
                                          ),
                                          onReady: () {
                                            // Когда видео готово к воспроизведению, запускаем его
                                            _controller.play();
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              } else
                                return Text("Нет видео");
                            }),
                        ],
                      );
                    }
                  }
                  return CircularProgressIndicator();
                },
              ),
              const Divider(
                color: Colors.grey,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                'Комментарии',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
              Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),),
                child: SizedBox(
                  width: 370,
                  height: 400,
                  child: FutureBuilder<List<Comments>>(
                    future: be.CommentsByRecipe(widget.id),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Comments>> snapshot) {
                      if (snapshot.hasData) {
                        List<Comments>? items = snapshot.data;
                        if (items != null) {
                          return Container(
                            color: Colors.white,
                            child: Card(
                              child: Container(
                                color: Colors.white,
                                child: ListView.builder(
                                    itemCount: items.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        color: Colors.white,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.fromLTRB(5, 5, 5, 0),
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 32,
                                                      backgroundImage: NetworkImage(
                                                          items[index].ImageUser),
                                                    ),
                                                    SizedBox(
                                                      width: 8,
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            items[index].NameUser,
                                                            style: GoogleFonts.lato(
                                                              textStyle:TextStyle(
                                                                  fontSize: 20, fontWeight: FontWeight.w700),
                                                            ),
                                                          ),
                                                          Text(
                                                            items[index].Comment,
                                                            style: GoogleFonts.lato(
                                                              textStyle:TextStyle(
                                                                  fontSize: 16, fontWeight: FontWeight.w600),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            ),
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
              SizedBox(
                height: 5,
              ),
              SizedBox(
                child: FutureBuilder<Users>(
                  future: be.login(Users(
                    UserID: 0,
                    Email: widget.email,
                    Password: widget.password,
                  )),
                  builder:
                      (BuildContext context, AsyncSnapshot<Users> snapshot) {
                    if (snapshot.hasData) {
                      Users? items = snapshot.data;
                      if (items != null) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 310,
                              child: TextField(
                                controller: comment,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  labelText: 'Ваш комментарий',
                                  labelStyle: GoogleFonts.lato(
                                textStyle:TextStyle(
                                  color: Colors.black,
                                fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      )),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                addcomment(widget.id, items.Image!,
                                    items.NickName!, comment.text);
                                setState(() {
                                  comment.text =
                                      ''; // Очищаем содержимое TextField
                                });
                              },
                              icon: Icon(
                                Icons.done,
                                size: 35,
                                color: Colors.green,
                              ),
                            )
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
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void addcomment(
      int IdRecipe, String ImageUser, String NameUser, String Comment) async {
    Comments o = Comments(
        Number: 0,
        IdRecipe: IdRecipe,
        ImageUser: ImageUser,
        NameUser: NameUser,
        Comment: "$Comment",
        Date: DateTime.now());
    await be.addcomment(o);
  }
}
