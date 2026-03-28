import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'models/product.dart';

class ProductView extends StatefulWidget {
  const ProductView({super.key});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {

  late Future<http.Response> _response;

  List<Product> products = [];
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();

    Uri url = Uri.https('fakestoreapi.com', '/products');
    _response = http.get(url);
  }

  Future<void> addProduct() async {

    Uri url = Uri.https('fakestoreapi.com', '/products');

    var response = await http.post(
      url,
      body: {
        "title": "New Product",
        "price": "999",
        "description": "Added from app",
        "image": "https://i.pravatar.cc",
        "category": "electronics"
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {

      // Fakestore returns single object which is decoded manually
      final newProduct = productFromJson(response.body);

      setState(() {
        products.add(newProduct);
      });

    } else {
      print("POST failed");
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: const Text("Products"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),

      body: FutureBuilder<http.Response>(
        future: _response,

        builder: (context, snapshot) {

          // Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error
          else if (snapshot.hasError) {
            print(snapshot.error);

            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          }

          // Data received
          else if (snapshot.hasData) {

            if (snapshot.data!.statusCode == 200) {

              if (!isLoaded) {
                products = productFromMap(snapshot.data!.body);
                isLoaded = true;
              }

              return ListView.builder(
                itemCount: products.length,

                itemBuilder: (context, index) {

                  Product p = products[index];

                  return Card(
                    margin: const EdgeInsets.all(10),
                    elevation: 4,

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // IMAGE
                        Container(
                          height: 270,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(p.image),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              // TITLE + RATING
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      p.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text("⭐ ${p.rating.rate}")
                                ],
                              ),

                              const SizedBox(height: 8),

                              // DESCRIPTION
                              Text(
                                p.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),

                              const SizedBox(height: 10),

                              // CATEGORY + PRICE
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // CATEGORY
                                  Text(p.category),

                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text("Edit clicked")),
                                          );
                                        },
                                        icon: const Icon(Icons.mode_edit, color: Colors.blue),
                                      ),

                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            products.removeAt(index);
                                          });
                                        },
                                        icon: const Icon(Icons.delete_forever, color: Colors.red),
                                      ),
                                    ],
                                  ),

                                  Text("₹ ${p.price}"),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }

            return const Center(child: Text("Invalid response"));
          }

          return const Center(child: Text("No data"));
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: addProduct,
        child: const Icon(Icons.add),
      ),
    );
  }
}