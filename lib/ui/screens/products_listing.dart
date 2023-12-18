import 'package:flutter/material.dart';
import 'package:tradex_mobile/core/models.dart';
import 'package:tradex_mobile/core/api.dart';
import 'package:tradex_mobile/ui/screens/create_product.dart';
import 'package:tradex_mobile/ui/widgets/product.dart';

class ProductListing extends StatefulWidget {
  const ProductListing({super.key});

  @override
  State<ProductListing> createState() => _ProductListingState();
}

class _ProductListingState extends State<ProductListing> {
  late Future<List<Product>> response;


  @override
  void initState() {
    response = getProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Listagem de produtos"),
      ),
      body: FutureBuilder(
        future: response,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListProduct(snapshot.data ?? []);
          }
          return Container();
        }),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (c) => const CreateProduct())).then((v){
          setState(() {
            response = getProducts();
          });
        });
      },child: const Icon(Icons.add),),
    );
  }
}

class ListProduct extends StatelessWidget {
  final List<Product> products;
  const ListProduct(this.products, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
      child: ListView(children: products.map((e) => ProductWidget(e)).toList()));
  }
}
