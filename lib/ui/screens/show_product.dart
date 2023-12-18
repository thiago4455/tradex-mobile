import 'package:flutter/material.dart';
import 'package:tradex_mobile/core/api.dart';
import 'package:tradex_mobile/core/models.dart';
import 'package:tradex_mobile/ui/widgets/product_chart.dart';

class ShowProduct extends StatelessWidget {
  final Product product;
  const ShowProduct(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(product.name),
      ),
      body: ProductBuilder(product),
    );
  }
}

class ProductBuilder extends StatefulWidget {
  final Product product;
  const ProductBuilder(this.product, {super.key});
  @override
  State<ProductBuilder> createState() => _ProductBuilderState();
}

class _ProductBuilderState extends State<ProductBuilder> {
  late Future<List<Pricing>> response;

  @override
  void initState() {
    response = getPricing(widget.product.ean);
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
            height: 200,
            child: widget.product.image != null
                ? Image.network(widget.product.image!)
                : Container()),
        Align(alignment: Alignment.center, child: Text("Preço atual: ${widget.product.price?.toDouble()??"Não informado"}")),
        const SizedBox(height: 40),
        FutureBuilder(future: response, builder: (context, snapshot) {
          if(snapshot.hasData && snapshot.data != null){
            return PricingChart(snapshot.data!);
          }
          return Container();
        },)
      ],
    );
  }
}
