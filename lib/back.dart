import 'dart:convert';
import 'dart:io';
import 'package:cookrecipe/pages/RecipesByCategory.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class BackEnd {
  late String baseUrl;
  var client = http.Client();

  BackEnd({required this.baseUrl});




  Future<void> uploadFile(File file,String name,String str,String upload) async {
    var uri = Uri.parse('http://10.0.2.2:3000/$str/$upload');
    var request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('file', file.path , filename: '$name.png'));
    if (await File('$name.png').exists()) {
      // Если файл существует, удаляем его
      await File('$name.png').delete();
      print('Старый файл с именем $name.png удален.');
    }
    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        print('Файл успешно загружен на сервер.');
      } else {
        print('Ошибка при загрузке файла. Код ответа: ${response.statusCode}');
      }
    } catch (e) {
      print('Ошибка при отправке запроса: $e');
    }
  }

  Future<void> update(String name, String image, int id) async {
    try {
      var request = await client.put(
        Uri.parse("$baseUrl/users/$id"),
        body: json.encode({
          "image": image,
          "nickname":name}),
      );
      print(request.body);
      // Обработка успешного обновления изображения
    } catch (e) {
      print("Error updating image: $e");
      // Обработка ошибки
    }
  }


  Future<void> add(Recipes recipes) async {
    try {

      var request = await client.post(
        Uri.parse("$baseUrl/recipes"),
        body: json.encode({
          "user_id": recipes.UserID,
          "name": recipes.Name,
          "image": recipes.Image,
          "description": recipes.Description.map((steps)=>{
            "step_number": steps.StepNumber,
            "step": steps.Step,
        } ).toList(),
          "products": recipes.Products.map((products) => {
            "product_id": products.ProductID,
            "name": products.Name,
            "weight":products.Weight,
          }).toList(),
          "category":recipes.Category,
          "tag" : recipes.Tag,
          "video" : recipes.Video
        }),
        headers: {
          "Content-Type": "application/json",
        },

      );
      print(request.body);
    } catch (e) {
      print("Error $e");
    }
  }


  Future<bool> isEmailUnique(String email) async {
    try {
      var request = await client.post(
        Uri.parse("$baseUrl/users/check"),
        body: json.encode({
          "email": email,
        }),
        headers: {
          "Content-Type": "application/json", //token
        },
      );

      print("Response Status Code: ${request.statusCode}");
      print("Response Body: ${request.body}");

      if (request.statusCode == 401) {
        return true;
      } else if (request.statusCode == 200) {
        var jsonResponse = jsonDecode(request.body);
        return false;
      } else {
        print("Error: ${request.statusCode}");
      }
    } catch (e) {
      print("Error $e");
    }

    return false;
  }




  Future<void> post(Users users) async {
    try {
      var request = await client.post(
        Uri.parse("$baseUrl/users"),
        body: json.encode({
          "image": users.Image,
          "email": users.Email,
          "password": users.Password,
          "nickname": users.NickName,
        }),
        headers: {
          "Content-Type": "application/json",
        },
      );
    } catch (e) {
      print("Error $e");
    }
  }


  Future<Users> login(Users users) async {
    Users user = Users(UserID: 0, Email: "", Password: "");
    try {
      var request = await client.post(
        Uri.parse("$baseUrl/users/login"),
        body: json.encode({
          "email": users.Email,
          "password": users.Password,
        }),
        headers: {
          "Content-Type": "application/json",
        },
      );
      print(request.body);
      if (request.statusCode == 200) {
        var jsonResponse = jsonDecode(request.body);
        user = Users(
          UserID: jsonResponse["user_id"],
          Image: jsonResponse["image"],
          Email: jsonResponse["email"],
          Password: jsonResponse["password"],
          NickName: jsonResponse["nickname"],
        );
      }


    } catch (e) {
      print("Error $e");
    }
    finally {
      return user;
    }
  }

  Future<List<Recipes>> findName(Recipes recipe) async {
    List<Recipes> recipes = [];
    try {
      var response = await client.post(
        Uri.parse("$baseUrl/recipes/NameFind"),
        body: json.encode({
          "name": recipe.Name,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      print(response.body);

      var jsonResponse = jsonDecode(response.body);

      // Проверяем, что "recipe" не является null
      if (jsonResponse["recipe"] != null) {
        // Проверяем, что "recipe" является массивом
        if (jsonResponse["recipe"] is List) {
          for (var o in jsonResponse["recipe"]) {
            List<Product> products = [];
            if (o["product"] != null && o["product"] is List) {
              for (var i in o["product"]) {
                Product ln = Product(ProductID: i["product_id"], Name: i["name"], Weight: i["weight"]);
                products.add(ln);
              }
            }

            List<Steps> steps = [];
            if (o["step"] != null && o["step"] is List) {
              for (var i in o["step"]) {
                Steps ln = Steps(StepNumber: i["step_number"], Step: i["step"]);
                steps.add(ln);
              }
            }
            Recipes recipe = Recipes(
              RecipeID: o["recipe_id"],
              UserID: o["user_id"],
              Image: o["image"],
              Name: o["name"],
              Description: steps,
              Products: products,
              Category: o["category"],
              Tag: o["tag"],
              Video: o["video"],
            );
            recipes.add(recipe);
          }
        }
      }
    } catch (e) {
      print("Error $e");
    } finally {
      return recipes;
    }
  }


  Future<List<Recipes>> SearchByCategory(Recipes recipe) async {
    List<Recipes> recipes = [];
    try {
      var response = await client.post(
        Uri.parse("$baseUrl/recipes/Category"),
        body: json.encode({
          "name": recipe.Name,
          "category": recipe.Category,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      print(response.body);

      var jsonResponse = jsonDecode(response.body);

      // Проверяем, что "recipe" не является null
      if (jsonResponse["recipe"] != null) {
        // Проверяем, что "recipe" является массивом
        if (jsonResponse["recipe"] is List) {
          for (var o in jsonResponse["recipe"]) {
            List<Product> products = [];
            if (o["product"] != null && o["product"] is List) {
              for (var i in o["product"]) {
                Product ln = Product(ProductID: i["product_id"], Name: i["name"], Weight: i["weight"]);
                products.add(ln);
              }
            }

            List<Steps> steps = [];
            if (o["step"] != null && o["step"] is List) {
              for (var i in o["step"]) {
                Steps ln = Steps(StepNumber: i["step_number"], Step: i["step"]);
                steps.add(ln);
              }
            }
            Recipes recipe = Recipes(
              RecipeID: o["recipe_id"],
              UserID: o["user_id"],
              Image: o["image"],
              Name: o["name"],
              Description: steps,
              Products: products,
              Category: o["category"],
              Tag: o["tag"],
              Video: o["video"],
            );
            recipes.add(recipe);
          }
        }
      }
    } catch (e) {
      print("Error $e");
    } finally {
      return recipes;
    }
  }


  Future<List<Recipes>> SearchByTag(Recipes recipe) async {
    List<Recipes> recipes = [];
    try {
      var response = await client.post(
        Uri.parse("$baseUrl/recipes/Tag"),
        body: json.encode({
          "name": recipe.Name,
          "tag": recipe.Tag,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      print(response.body);

      var jsonResponse = jsonDecode(response.body);

      // Проверяем, что "recipe" не является null
      if (jsonResponse["recipe"] != null) {
        // Проверяем, что "recipe" является массивом
        if (jsonResponse["recipe"] is List) {
          for (var o in jsonResponse["recipe"]) {
            List<Product> products = [];
            if (o["product"] != null && o["product"] is List) {
              for (var i in o["product"]) {
                Product ln = Product(ProductID: i["product_id"], Name: i["name"], Weight: i["weight"]);
                products.add(ln);
              }
            }

            List<Steps> steps = [];
            if (o["step"] != null && o["step"] is List) {
              for (var i in o["step"]) {
                Steps ln = Steps(StepNumber: i["step_number"], Step: i["step"]);
                steps.add(ln);
              }
            }
            Recipes recipe = Recipes(
              RecipeID: o["recipe_id"],
              UserID: o["user_id"],
              Image: o["image"],
              Name: o["name"],
              Description: steps,
              Products: products,
              Category: o["category"],
              Tag: o["tag"],
              Video: o["video"],
            );
            recipes.add(recipe);
          }
        }
      }
    } catch (e) {
      print("Error $e");
    } finally {
      return recipes;
    }
  }


  Future<Recipes> getRecipeById(int id) async {
    final url = Uri.parse('$baseUrl/recipes/$id'); // замените на ваш реальный URL
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      List<Product> products = [];
      if (jsonResponse["products"] != null && jsonResponse["products"] is List) {
        for (var i in jsonResponse["products"]) {
          Product ln = Product(
              ProductID: i["product_id"], Name: i["name"], Weight: i["weight"]);
          products.add(ln);
        }
      }

      List<Steps> steps = [];
      if (jsonResponse["description"] != null && jsonResponse["description"] is List) {
        for (var i in jsonResponse["description"]) {
          Steps ln = Steps(StepNumber: i["step_number"], Step: i["step"]);
          steps.add(ln);
        }
      }

      Recipes recipe = Recipes(
        RecipeID: jsonResponse["recipe_id"],
        UserID: jsonResponse["user_id"],
        Image: jsonResponse["image"],
        Name: jsonResponse["name"],
        Description: steps,
        Products: products,
        Category: jsonResponse["category"],
        Tag: jsonResponse["tag"],
        Video: jsonResponse["video"],
      );

      return recipe;
    } else {
      throw Exception('Failed to load recipe');
    }
  }

  Future<Recipes> PopularRecipe() async {
    final url = Uri.parse('$baseUrl/recipes/popularrecipe'); // замените на ваш реальный URL
    final response = await http.post(url);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      List<Product> products = [];
      if (jsonResponse["products"] != null && jsonResponse["products"] is List) {
        for (var i in jsonResponse["products"]) {
          Product ln = Product(
              ProductID: i["product_id"], Name: i["name"], Weight: i["weight"]);
          products.add(ln);
        }
      }

      List<Steps> steps = [];
      if (jsonResponse["description"] != null && jsonResponse["description"] is List) {
        for (var i in jsonResponse["description"]) {
          Steps ln = Steps(StepNumber: i["step_number"], Step: i["step"]);
          steps.add(ln);
        }
      }

      Recipes recipe = Recipes(
        RecipeID: jsonResponse["recipe_id"],
        UserID: jsonResponse["user_id"],
        Image: jsonResponse["image"],
        Name: jsonResponse["name"],
        Description: steps,
        Products: products,
        Category: jsonResponse["category"],
        Tag: jsonResponse["tag"],
        Video: jsonResponse["video"],
      );

      return recipe;
    } else {
      throw Exception('Failed to load recipe');
    }
  }


  Future<List<Recipes>> RecipesByUser(int id) async {
    List<Recipes> recipes = [];
    try {
      var response = await client.post(
        Uri.parse("$baseUrl/recipes/user$id"),
      );

      print(response.body);

      var jsonResponse = jsonDecode(response.body);

      // Проверяем, что "recipe" не является null
      if (jsonResponse["recipe"] != null) {
        // Проверяем, что "recipe" является массивом
        if (jsonResponse["recipe"] is List) {
          for (var o in jsonResponse["recipe"]) {
            List<Product> products = [];
            if (o["product"] != null && o["product"] is List) {
              for (var i in o["product"]) {
                Product ln = Product(ProductID: i["product_id"], Name: i["name"], Weight: i["weight"]);
                products.add(ln);
              }
            }

            List<Steps> steps = [];
            if (o["step"] != null && o["step"] is List) {
              for (var i in o["step"]) {
                Steps ln = Steps(StepNumber: i["step_number"], Step: i["step"]);
                steps.add(ln);
              }
            }
            Recipes recipe = Recipes(
              RecipeID: o["recipe_id"],
              UserID: o["user_id"],
              Image: o["image"],
              Name: o["name"],
              Description: steps,
              Products: products,
              Category: o["category"],
              Tag: o["tag"],
              Video: o["video"],
            );
            recipes.add(recipe);
          }
        }
      }
    } catch (e) {
      print("Error $e");
    } finally {
      return recipes;
    }
  }

  Future<List<Comments>> CommentsByRecipe(int id) async {
    List<Comments> comments = [];
    try {
      var response = await client.post(
        Uri.parse("$baseUrl/recipes/comments$id"),
      );

      print(response.body);

      var jsonResponse = jsonDecode(response.body);

      // Проверяем, что "recipe" не является null
      if (jsonResponse["comments"] != null) {
        // Проверяем, что "recipe" является массивом
        if (jsonResponse["comments"] is List) {
          for (var o in jsonResponse["comments"]) {
            Comments comment = Comments(
              Number: o["number"],
              IdRecipe: o["id_recipe"],
              ImageUser: o["image_user"],
              NameUser: o["name_user"],
              Comment: o["comment"],
              Date: o["date"] ==  null ? null : DateTime.tryParse(o["date"]),
            );
            comments.add(comment);
          }
        }
      }
    } catch (e) {
      print("Error $e");
    } finally {
      return comments;
    }
  }
  Future<void> addcomment(Comments comments) async {
    try {
      print("Sending comment data to server:");
      print("IdRecipe: ${comments.IdRecipe}");
      print("ImageUser: ${comments.ImageUser}");
      print("NameUser: ${comments.NameUser}");
      print("Comment: ${comments.Comment}");

      var request = await client.post(
        Uri.parse("$baseUrl/recipes/addcomments"),
        body: json.encode({
          "id_recipe": comments.IdRecipe,
          "image_user": comments.ImageUser,
          "name_user": comments.NameUser,
          "comment":comments.Comment,
        }),
        headers: {
          "Content-Type": "application/json",
        },
      );
      print("Server response: ${request.body}");
    } catch (e) {
      print("Error $e");
    }
  }


  void close() {
    client.close();
  }
}





class Users {
  final int UserID;
  final String? Image;
  final String Email;
  final String Password;
  final String? NickName;

  Users({required this.UserID,
     this.Image,
    required this.Email,
    required this.Password,
    this.NickName});
}
class Recipes {
  final int RecipeID;
  final int UserID;
  final String Name;
  final String? Image;
  final List<Steps> Description;
  final List<Product> Products;
  final String Category;
  final String Tag;
  final String Video;

  Recipes({
    required this.RecipeID,
    required this.UserID,
    required this.Name,
    this.Image,
    required this.Description,
    required this.Products,
    required this.Category,
    required this.Tag,
    required this.Video
  });
}


class Product  {
  final int ProductID;
  final String Name;
  final int Weight;

  Product({required this.ProductID,
    required this.Name,
    required this.Weight});
}

class Steps  {
  final int StepNumber;
  final String Step;

  Steps({required this.StepNumber,
    required this.Step});
}

class Comments {
  final int Number;
  final int IdRecipe;
  final String ImageUser;
  final String NameUser;
  final String Comment;
  final DateTime? Date;

  Comments({required this.Number,
    required this.IdRecipe,
    required this.ImageUser,
    required this.NameUser,
    required this.Comment,
    required this.Date});
}

