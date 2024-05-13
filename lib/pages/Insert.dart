import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../back.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'Register.dart';

class Insert extends StatefulWidget {
  final int iduser;

  const Insert({Key? key, required this.iduser}) : super(key: key);

  @override
  State<Insert> createState() => _InsertState();
}

BackEnd be = BackEnd(baseUrl: "http://10.0.2.2:3000");
TextEditingController name = TextEditingController();
TextEditingController description = TextEditingController();
TextEditingController video = TextEditingController();
TextEditingController nameController = TextEditingController();
TextEditingController weightController = TextEditingController();
TextEditingController stepController = TextEditingController();

int currentStepNumber = 0;
int currentProductID = 0;
const List<String> category = <String>['Завтрак', 'Обед', 'Ужин', 'Перекус'];
const List<String> tag = <String>[
  'Холодные закуски',
  'Горячие закуски',
  'Салаты',
  'Супы',
  'Горячие блюда',
  'Гарниры',
  'Десерты',
  'Напитки'
];
String image = 'http://10.0.2.2:3000/assets/recipes/image.png';
List<Product> products = [];
List<Steps> steps = [];
List<String> product = [];
List<String> weight = [];
List<String> step = [];

class _InsertState extends State<Insert> {
  String dropdownCategory = category.first;
  String dropdownTag = tag.first;

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
        title: Text("Ввод рецепта",
            style: GoogleFonts.lato(
              textStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
            )),
        actions: [
          IconButton(
            icon: Icon(Icons.check_circle_outline, color: Colors.green),
            onPressed: () async {
              uploadAndAdd();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(width: 20),
                      Text('Рецепт загружается...'),
                    ],
                  ),
                  backgroundColor: Colors.blueGrey,
                  duration: Duration(seconds: 3),
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Рецепт загружен'),
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
      body: Container(
        color: Color(0xFFEAF6FF),
        child: ListView(
          children: [
            Column(children: [
              const SizedBox(height: 15),
              SizedBox(
                width: 380,
                child: TextField(
                  style: GoogleFonts.lato(
                    textStyle:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                  controller: name,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    labelText: 'Введите название блюда',
                    labelStyle: GoogleFonts.lato(
                      textStyle:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 1,
                        )),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                    ),
                    child: DropdownMenu<String>(
                      width: 380,
                      inputDecorationTheme: InputDecorationTheme(
                          filled: true, fillColor: Colors.white),
                      textStyle: GoogleFonts.lato(
                        textStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                      menuStyle: MenuStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        surfaceTintColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                      ),
                      initialSelection: category.first,
                      onSelected: (String? value) {
                        setState(() {
                          dropdownCategory = value!;
                        });
                      },
                      dropdownMenuEntries: category
                          .map<DropdownMenuEntry<String>>((String value) {
                        return DropdownMenuEntry<String>(
                            style: MenuItemButton.styleFrom(
                              textStyle: GoogleFonts.lato(
                                textStyle: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                            ),
                            value: value,
                            label: value);
                      }).toList(),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                    ),
                    child: DropdownMenu<String>(
                      menuHeight: 300,
                      width: 380,
                      inputDecorationTheme: InputDecorationTheme(
                          filled: true, fillColor: Colors.white),
                      menuStyle: MenuStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        surfaceTintColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                      ),
                      textStyle: GoogleFonts.lato(
                        textStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                      initialSelection: tag.first,
                      onSelected: (String? value) {
                        setState(() {
                          dropdownTag = value!;
                        });
                      },
                      dropdownMenuEntries:
                          tag.map<DropdownMenuEntry<String>>((String value) {
                        return DropdownMenuEntry<String>(
                            style: MenuItemButton.styleFrom(
                              textStyle: GoogleFonts.lato(
                                textStyle: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                            ),
                            value: value,
                            label: value);
                      }).toList(),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              if (image == 'http://10.0.2.2:3000/assets/recipes/image.png')
                Image.network(image)
              else
                SizedBox(
                    width: 350, height: 300, child: Image.file(File(image))),
              TextButton(
                  onPressed: () async {
                    final pickedFile = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);
                    if (pickedFile != null) {
                      setState(() {
                        image = pickedFile.path;
                      });
                    }
                  },
                  style: ButtonStyle(),
                  child: Text('Загрузите фотографию',
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Colors.black),
                      ))),
              SizedBox(
                height: 10,
              ),
              for (var i = 0; i < product.length && i < weight.length; i++)
                ListTile(
                  title: Text('${i + 1}. ${product[i]} ${weight[i]}гр.',
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w800),
                      )),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Field(nameController, TextInputType.text, 'Введите продукт',
                      280),
                  Field(
                      weightController,
                      TextInputType.numberWithOptions(decimal: true),
                      "Вес гр.",
                      100)
                ],
              ),
              TextButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty &&
                        weightController.text.isNotEmpty) {
                      currentProductID++;
                      addProduct();
                      setState(() {
                        product.add(nameController.text);
                        nameController.clear();
                        weight.add(weightController.text);
                        weightController.clear();
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Заполните продукты'),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    }
                  },
                  child: Text('Добавить продукт',
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.black),
                      ))),
              SizedBox(
                height: 8,
              ),
              for (var item in step)
                ListTile(
                  title: Text('${step.indexOf(item) + 1}. $item',
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w800),
                      )),
                ),
              Field(stepController, TextInputType.text, 'Опишите шаг', 380),
              TextButton(
                  onPressed: () {
                    if (stepController.text.isNotEmpty) {
                      currentStepNumber++;
                      addStep();
                      setState(() {
                        step.add(stepController.text);
                        stepController.clear();
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Заполните описание шага'),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    }
                  },
                  child: Text('Добавить шаг',
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.black),
                      ))),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 380,
                child: TextField(
                  controller: video,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    labelText: 'Cсылка на видео',
                    labelStyle: GoogleFonts.lato(
                      textStyle:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 1,
                        )),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              )
            ]),
          ],
        ),
      ),
    );
  }

  void addProduct() async {
    String name = nameController.text;
    int weight = int.parse(weightController.text);
    products
        .add(Product(ProductID: currentProductID, Name: name, Weight: weight));
  }

  void addStep() async {
    String step = stepController.text;
    steps.add(Steps(StepNumber: currentStepNumber, Step: step));
  }

  Future<void> uploadAndAdd() async {
    try {
      await be.uploadFile(File(image), '${name.text}.${widget.iduser}',
          'recipes', 'uploadrecipe');
      add();
    } catch (error) {
      print('Error: $error');
    }
  }

  void add() async {
    Recipes o = Recipes(
        RecipeID: 0,
        UserID: widget.iduser,
        Name: name.text,
        Image:
            'http://10.0.2.2:3000/assets/recipes/${name.text}.${widget.iduser}.png',
        Description: steps,
        Products: products,
        Category: dropdownCategory,
        Tag: dropdownTag,
        Video: video.text);
    await be.add(o);
  }
}

Field(
    TextEditingController control, keyboardType, String string, double width) {
  return Column(
    children: [
      SizedBox(
        width: width,
        child: TextField(
          style: GoogleFonts.lato(
            textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          controller: control,
          keyboardType: keyboardType,
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
              labelText: string,
              labelStyle: GoogleFonts.lato(
                textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              )),
        ),
      ),
    ],
  );
}
