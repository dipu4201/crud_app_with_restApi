import 'dart:async';
import 'dart:convert';

import 'package:crud_app/Products.dart';
import 'package:crud_app/add_product.dart';
import 'package:crud_app/update_product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class CrudApp extends StatefulWidget {
  const CrudApp({super.key});

  @override
  State<CrudApp> createState() => _CrudAppState();
}

class _CrudAppState extends State<CrudApp> {
  bool _getProductInprogress = false;
  List <Product> productList = [];
  @override
  void initState() {
    super.initState();
    _getProductList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
      ),
      body: RefreshIndicator(
        onRefresh: _getProductList,
        child: Visibility(
          visible: _getProductInprogress == false,
          replacement: const Center(
            child:CircularProgressIndicator(),),
          child: ListView.separated(
            itemCount: productList.length,
            itemBuilder: (context, index) {
              return _buildProductitem(productList[index]);
            },
            separatorBuilder: (_, __) => const Divider(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddProductScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
  Future<void> _getProductList() async{
    _getProductInprogress = true;
    setState(() {});
    productList.clear();
    const String getProductListurl = 'https://crud.teamrabbil.com/api/v1/ReadProduct';
    Uri uri = Uri.parse(getProductListurl);
    Response response = await get(uri);

    print(response.statusCode);
    print(response.body);

    if (response.statusCode==200){
      final deCodedData = jsonDecode(response.body);
      final jsonProductList = deCodedData['data'];
      for (Map<String, dynamic> d in jsonProductList) {
        Product product = Product(
            id: d["_id"] ?? '',
            ProductName: d["ProductName"] ?? 'Unkown',
            productCode: d["ProductCode"] ?? 'Unkown',
            productImage: d["Img"] ?? 'Unkown',
            productUnitPrice: d["UnitPrice"] ?? 'Unkown',
            productQuatity: d["Qty"] ?? 'Unkown',
            productTotalPrice: d["TotalPrice"] ?? 'Unkown');
      productList.add(product);}
    }
    else {
    ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Get Product Failed! Try Again')),
    );
    }
    _getProductInprogress = false;
    setState(() {});
  }

  Widget _buildProductitem(Product product) {
    return ListTile(
          leading: Image.network(
            product.productImage,
            height: 70,
            width: 70,
          ),
          title: Text(product.ProductName),
          subtitle: Wrap(
            spacing: 18,
            children: [
              Text('Unit Price: ${product.productUnitPrice}'),
              Text('Quatity: ${product.productQuatity}'),
              Text('Total Price: ${product.productTotalPrice}'),
            ],
          ),
          trailing: Wrap(
            children: [
              IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UpdateProductScreen(
                    product: product,
                  ),
                ),
              );
            },
          ),
          IconButton(
                icon: Icon(Icons.delete_outline_sharp),
                onPressed: () {
                  _ShowDeleteConfirmationDialog();
                },
              )
            ],
          ),
        );
  }

  void _ShowDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete'),
          content: Text('Are You Sure To Delete This Product'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Yes,Delete'),
            ),
          ],
        );
      },
    );
  }
}
