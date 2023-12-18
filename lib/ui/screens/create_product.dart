import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tradex_mobile/core/api.dart';

class CreateProduct extends StatefulWidget {
  const CreateProduct({super.key});

  @override
  State<CreateProduct> createState() => _CreateProductState();
}

class _CreateProductState extends State<CreateProduct> {
  final _formKey = GlobalKey<FormState>();

  String? name;
  String? ean;
  double? price;
  double? minPrice;
  double? maxPrice;
  XFile? image;

  Future<void> getImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file == null) {
      return;
    }
    setState(() {
      image = file;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Adicionar produto"),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  onSaved: (v) {
                    name = v;
                  },
                  decoration: const InputDecoration(hintText: 'Nome'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Insira um texto válido';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  onSaved: (v) {
                    ean = v;
                  },
                  decoration: const InputDecoration(hintText: 'EAN'),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length != 13) {
                      return 'Insira um EAN de 13 dígitos';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  onSaved: (v) {
                    price = double.tryParse(v ?? "");
                  },
                  decoration: const InputDecoration(hintText: 'Preço inicial'),
                  keyboardType: const TextInputType.numberWithOptions(
                      signed: false, decimal: true),
                  validator: (value) {
                    final val = double.tryParse(value ?? "");
                    if (val == null || val.isNaN || val < 0) {
                      return 'Insira preço válido';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  onSaved: (v) {
                    minPrice = double.tryParse(v ?? "");
                  },
                  decoration: const InputDecoration(hintText: 'Preço mínimo'),
                  keyboardType: const TextInputType.numberWithOptions(
                      signed: false, decimal: true),
                  validator: (value) {
                    final val = double.tryParse(value ?? "");
                    if (val == null || val.isNaN || val < 0) {
                      return 'Insira preço mínimo válido';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  onSaved: (v) {
                    maxPrice = double.tryParse(v ?? "");
                  },
                  decoration: const InputDecoration(hintText: 'Preço máximo'),
                  keyboardType: const TextInputType.numberWithOptions(
                      signed: false, decimal: true),
                  validator: (value) {
                    final val = double.tryParse(value ?? "");
                    if (val == null || val.isNaN || val < 0) {
                      return 'Insira preço máximo válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                Text("Imagem: ${image?.name ?? "Nenhuma"}"),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          getImage();
                        },
                        child: const Text('Selecionar imagem'),
                      ),
                      const SizedBox(width: 15),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            createProduct(
                                    name: name!,
                                    ean: ean!,
                                    price: price!,
                                    minPrice: minPrice!,
                                    maxPrice: maxPrice!,
                                    image: image)
                                .then((_) {
                              addPricing(ean!, price!).then((_) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Produto adicionado com sucesso')),
                                );
                              });
                            });
                          }
                        },
                        child: const Text('Adicionar produto'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
