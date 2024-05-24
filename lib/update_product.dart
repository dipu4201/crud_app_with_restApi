import 'dart:convert';

import 'package:crud_app/Products.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class UpdateProductScreen extends StatefulWidget {
  const UpdateProductScreen({super.key, required this.product});
  final Product product;

  @override
  State<UpdateProductScreen> createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  final TextEditingController _nameTEcontroller = TextEditingController();
  final TextEditingController _unitPriceTEcontroller = TextEditingController();
  final TextEditingController _qantityTEcontroller = TextEditingController();
  final TextEditingController _totalpriceTEcontroller = TextEditingController();
  final TextEditingController _imageTEcontroller = TextEditingController();
   final TextEditingController _productCodeTEcontroller = TextEditingController();
   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
   bool _updateProductInProgress = false;

  @override
  void initState() {
    super.initState();
    _nameTEcontroller.text = widget.product.ProductName;
    _unitPriceTEcontroller.text = widget.product.productUnitPrice;
    _qantityTEcontroller.text = widget.product.productQuatity;
    _totalpriceTEcontroller.text = widget.product.productTotalPrice;
    _imageTEcontroller.text = widget.product.productImage;
    _productCodeTEcontroller.text = widget.product.productCode;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Product'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                    controller: _nameTEcontroller,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                        hintText: 'Name',
                        labelText: 'Name'
                    ),
                    validator: (String ? value){
                      if (value == null || value.trim().isEmpty){
                        return 'Write a Product Name';
                      }
                      return null;
                    }
                ),
                const SizedBox(height: 16,),
                TextFormField(
                    controller: _unitPriceTEcontroller,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        hintText: 'Unit Price',
                        labelText: 'Unit Price'
                    ),
                    validator: (String ? value){
                      if (value == null || value.trim().isEmpty){
                        return 'Write a Product Unit Price';
                      }
                      return null;
                    }
                ),
                const SizedBox(height: 16,),
                TextFormField(
                    controller: _qantityTEcontroller,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        hintText: 'Quantity',
                        labelText: 'Quantity'
                    ),
                    validator: (String ? value){
                      if (value == null || value.trim().isEmpty){
                        return 'Write a Product Quantity';
                      }
                      return null;
                    }
                ),
                const SizedBox(height: 16,),
                TextFormField(
                    controller: _totalpriceTEcontroller,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        hintText: 'Total Price',
                        labelText: 'Total Price'
                    ),
                    validator: (String ? value){
                      if (value == null || value.trim().isEmpty){
                        return 'Write a Total Price';
                      }
                      return null;
                    }
                ),
                const SizedBox(height: 16,),
                TextFormField(
                    controller: _productCodeTEcontroller,
                    decoration: const InputDecoration(
                        hintText: 'Product Code',
                        labelText: 'Product Code'
                    ),
                    validator: (String ? value){
                      if (value == null || value.trim().isEmpty){
                        return 'Write a Product Code';
                      }
                      return null;
                    }
                ),
                const SizedBox(height: 16,),
                TextFormField(
                    controller: _imageTEcontroller,
                    decoration: const InputDecoration(
                        hintText: 'Image',
                        labelText: 'Image'
                    ),
                    validator: (String ? value){
                      if (value == null || value.trim().isEmpty){
                        return 'Write a Product Image';
                      }
                      return null;
                    }
                ),
                const SizedBox(height: 16,),
                Visibility(
                  visible: _updateProductInProgress == false,
                  replacement: Center(
                    child: CircularProgressIndicator(),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()){
                        _updateProduct();
                      }
                    },
                    child: const Text('Update'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _updateProduct() async {
    _updateProductInProgress = true;
    setState(() {});

    Map<String, String> inputData = {
      "Img": _imageTEcontroller.text,
      "ProductCode": _productCodeTEcontroller.text,
      "ProductName": _nameTEcontroller.text,
      "Qty": _qantityTEcontroller.text,
      "TotalPrice": _totalpriceTEcontroller.text,
      "UnitPrice": _unitPriceTEcontroller.text
    };

    String updateProductUrl =
        'https://crud.teamrabbil.com/api/v1/UpdateProduct/${widget.product.id}';
    Uri uri = Uri.parse(updateProductUrl);
    Response response =await post(uri,
        headers: {'content-type': 'application/json'},
        body: jsonEncode(inputData));
    print(response.statusCode);
    print(response.body);
    if (response.statusCode==200){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product Has Been Updated!')),
      );
      Navigator.pop(context);
    }else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product Update Failed! Try Again')),
      );
    }
  }

  @override
  void dispose() {
    _nameTEcontroller.dispose();
    _unitPriceTEcontroller.dispose();
    _qantityTEcontroller.dispose();
    _totalpriceTEcontroller.dispose();
    _imageTEcontroller.dispose();
    super.dispose();
  }
}
