import 'package:flutter/material.dart';

void main() {
  runApp(MyRecipeApp());
}

class MyRecipeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        hintColor: Colors.orangeAccent,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: RecipeListScreen(),
    );
  }
}

class RecipeListScreen extends StatefulWidget {
  @override
  _RecipeListScreenState createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  final List<Recipe> recipes = [


    Recipe('puran-poli','Indian', 'chana-dal pow,atta,oil,ghee,masala for curry', 'assets/images/pranpoli.jpeg'),
    Recipe('Pasta Carbonara', 'Italian', 'Spaghetti, eggs, pancetta, Parmesan cheese, black pepper', 'assets/images/pasta_carbonara.jpeg'),
    Recipe('Chicken Curry', 'Indian', 'Chicken, curry powder, onions, tomatoes, coconut milk', 'assets/images/chicken_curry.jpeg'),
    // Add more recipes as needed
  ];

  List<Recipe> filteredRecipes = [];

  @override
  void initState() {
    super.initState();
    filteredRecipes = List.from(recipes);
  }

  void _filterRecipes(String query) {
    setState(() {
      filteredRecipes = recipes.where((recipe) => recipe.name.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipes'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              final String? query = await showSearch<String>(
                context: context,
                delegate: RecipeSearchDelegate(recipes),
              );
              if (query != null && query.isNotEmpty) {
                _filterRecipes(query);
              }
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: filteredRecipes.length,
        itemBuilder: (context, index) {
          return RecipeCard(recipe: filteredRecipes[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your code to handle adding new recipes here
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class RecipeCard extends StatelessWidget {
  final Recipe recipe;

  RecipeCard({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(10),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RecipeDetailScreen(recipe: recipe)),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5),
              ),
              child: Image.asset(
                recipe.image,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.name,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text('Cuisine: ${recipe.cuisine}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;

  RecipeDetailScreen({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.name),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            recipe.image,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Cuisine: ${recipe.cuisine}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text('Ingredients: ${recipe.ingredients}', style: TextStyle(fontSize: 16)),
                // Add more details as needed
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RecipeSearchDelegate extends SearchDelegate<String> {
  final List<Recipe> recipes;

  RecipeSearchDelegate(this.recipes);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(); // You can customize the search results here if needed
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? []
        : recipes.where((recipe) => recipe.name.toLowerCase().contains(query.toLowerCase())).toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestionList[index].name),
          onTap: () {
            close(context, suggestionList[index].name);
          },
        );
      },
    );
  }
}

class Recipe {
  final String name;
  final String cuisine;
  final String ingredients;
  final String image;

  Recipe(this.name, this.cuisine, this.ingredients, this.image);
}
