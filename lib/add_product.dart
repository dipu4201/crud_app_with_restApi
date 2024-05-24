import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController _nameTEcontroller = TextEditingController();
  final TextEditingController _unitPriceTEcontroller = TextEditingController();
  final TextEditingController _qantityTEcontroller = TextEditingController();
  final TextEditingController _totalpriceTEcontroller = TextEditingController();
  final TextEditingController _productCodeTEcontroller = TextEditingController();
  final TextEditingController _imageTEcontroller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _addNewProductinprogress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Product'),
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
                    keyboardType: TextInputType.text,
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
                // if (_addNewProductinprogress==true)
                //   Center(
                //     child: CircularProgressIndicator(),
                //   )
                // else
                // ElevatedButton(
                //   onPressed: () {
                //     if (_formKey.currentState!.validate()){
                //       _addProduct();
                //     }
                //   },
                //   child: const Text('Add'),
                // ),

                Visibility(
                  visible: _addNewProductinprogress == false,
                  replacement: const Center(
                    child: CircularProgressIndicator(),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _addProduct();
                      }
                    },
                    child: const Text('Add'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

   Future <void> _addProduct() async {
    _addNewProductinprogress = true;
    setState(() {});
     const String newProductUrl =
        'https://crud.teamrabbil.com/api/v1/CreateProduct';
    Map <String, dynamic>  inputData = {
      "Img": _imageTEcontroller.text.trim(),
      "ProductCode":_productCodeTEcontroller.text,
      "ProductName":_nameTEcontroller.text,
      "Qty":_qantityTEcontroller.text,
      "TotalPrice":_totalpriceTEcontroller.text,
      "UnitPrice":_unitPriceTEcontroller.text
    };
    Uri uri = Uri.parse(newProductUrl);
    Response response = await post(
      uri,
      body: jsonEncode(inputData),
      headers: {'content-type': 'application/json'},
    );
    print(response.statusCode);
    print(response.body);
    print(response.headers);

    _addNewProductinprogress=false;
    setState(() {});
    if (response.statusCode == 200){
      _nameTEcontroller.clear();
      _unitPriceTEcontroller.clear();
      _qantityTEcontroller.clear();
      _totalpriceTEcontroller.clear();
      _productCodeTEcontroller.clear();
      _imageTEcontroller.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product Added!')),
      );
    }
       else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product Failed! Try Again')),
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
