import 'package:flutter/material.dart';
import 'package:tradex_mobile/core/models.dart';
import 'package:tradex_mobile/core/utils.dart';
import 'package:tradex_mobile/ui/screens/show_product.dart';

class ProductWidget extends StatelessWidget {
  final Product product;
  const ProductWidget(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (c)=>ShowProduct(product)));
      },
      child: SizedBox(
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 80,
              color: Colors.white10,
              child: (product.image != null && product.image!.isNotEmpty)
                ? Image.network(product.image!)
                : Container(),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text(product.name), Text("Preço: ${product.price?.toPrice() ?? "Indefinido"}")],
              ),
            )
          ],
        ),
      ),
    );
  }
}
