// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:brik_test_app/data/constant.dart';
import 'package:brik_test_app/presentation/pages/add_update_product_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../bloc/product_bloc.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final _searchController = TextEditingController();

  bool isTable = true;
  int _currentPage = 1;
  final int _pageSize = 5;

  void _loadProducts() {
    BlocProvider.of<ProductBloc>(context)
        .add(ProductsLoadEvent(page: _currentPage, pageSize: _pageSize));
  }

  void _nextPage() {
    setState(() {
      _currentPage++;
    });
    _loadProducts();
  }

  void _prevPage() {
    if (_currentPage > 1) {
      setState(() {
        _currentPage--;
      });
      _loadProducts();
    }
  }

  void changeMenu() {
    setState(() {
      isTable = !isTable;
    });
  }

  void _searchProducts(String query) {
    BlocProvider.of<ProductBloc>(context).add(SearchProductsEvent(query));
  }

  void _deleteSearch() {
    setState(() {
      _searchController.clear();
    });
    BlocProvider.of<ProductBloc>(context)
        .add(ProductsLoadEvent(page: 1, pageSize: 5));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Product'),
          actions: [
            IconButton(
                onPressed: () {
                  changeMenu();
                },
                icon: Icon(Icons.change_circle_outlined)),
          ],
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_currentPage > 1)
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _prevPage();
                    },
                    child: Text('Prev'),
                  ),
                ),
              if (_currentPage > 1) SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _nextPage();
                  },
                  child: Text('Next'),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddProductPage(),
                settings: RouteSettings(
                  arguments: {
                    'tag': 'add',
                  },
                ),
              ),
            );
          },
          child: Icon(Icons.post_add_rounded),
        ),
        body: BlocConsumer<ProductBloc, ProductState>(
          listener: (context, state) {
            if (state is ProductError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
            if (state is ProductDeleted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Product deleted successfully')),
              );
            }
          },
          builder: (context, state) {
            if (state is ProductLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is ProductHasData) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(12)),
                        labelText: 'Cari Produk',
                        prefixIcon: Icon(Icons.search),
                        suffixIcon: IconButton(
                            onPressed: _deleteSearch, icon: Icon(Icons.close)),
                      ),
                      onEditingComplete: () {
                        _searchProducts(_searchController.text);
                      },
                    ),
                  ),
                  isTable
                      ? Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: DataTable(
                                  border: TableBorder(
                                    top:
                                        BorderSide(color: Colors.grey.shade300),
                                    bottom:
                                        BorderSide(color: Colors.grey.shade300),
                                    left:
                                        BorderSide(color: Colors.grey.shade300),
                                    right:
                                        BorderSide(color: Colors.grey.shade300),
                                  ),
                                  columns: [
                                    DataColumn(label: Text('No')),
                                    DataColumn(label: Text('Name')),
                                    DataColumn(label: Text('Price')),
                                    DataColumn(label: Text('Action'))
                                  ],
                                  rows: List.generate(
                                    state.result.length,
                                    (index) {
                                      final item = state.result[index];
                                      return DataRow(
                                        cells: [
                                          DataCell(Text('${index + 1}')),
                                          DataCell(Text(item.name.toString())),
                                          DataCell(Text('\Rp${item.harga}')),
                                          DataCell(Row(
                                            children: [
                                              InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            AddProductPage(),
                                                        settings: RouteSettings(
                                                          arguments: {
                                                            'tag': 'edit',
                                                            'product': item,
                                                          },
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Icon(Icons.edit)),
                                              SizedBox(width: 5),
                                              InkWell(
                                                  onTap: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          AlertDialog(
                                                        title: Text(
                                                            'Delete ${item.name}'),
                                                        content: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Text(
                                                                'Are you sure want to delete ${item.name}?'),
                                                          ],
                                                        ),
                                                        actions: [
                                                          ElevatedButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: Text(
                                                                  'Cancel')),
                                                          ElevatedButton(
                                                              style: ElevatedButton
                                                                  .styleFrom(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .red),
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                                BlocProvider.of<
                                                                            ProductBloc>(
                                                                        context)
                                                                    .add(ProductDeleteEvent(item
                                                                        .id
                                                                        .toString()));
                                                              },
                                                              child: Text(
                                                                  'Delete'))
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                  child: Icon(Icons.delete)),
                                            ],
                                          ))
                                        ],
                                      );
                                    },
                                  )),
                            ),
                          ),
                        )
                      : Expanded(
                          child: RefreshIndicator(
                            onRefresh: () async {
                              BlocProvider.of<ProductBloc>(context)
                                  .add(ProductsLoadEvent(page: 1, pageSize: 5));
                              return Future.value();
                            },
                            child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 10,
                                      crossAxisSpacing: 10),
                              shrinkWrap: true,
                              padding: EdgeInsets.all(10),
                              itemCount: state.result.length,
                              itemBuilder: (context, index) {
                                final product = state.result[index];
                                return Card(
                                  elevation: 4,
                                  margin: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 120,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                onError: (exception,
                                                        stackTrace) =>
                                                    Icon(Icons
                                                        .broken_image_outlined),
                                                image: NetworkImage(
                                                    product.image ?? ''),
                                                fit: BoxFit.cover),
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(12),
                                                topRight: Radius.circular(12))),
                                      ),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: 100,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                      vertical: 10),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Flexible(
                                                    child: Text(
                                                      '${product.name}',
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  Text('Rp ${product.harga}'),
                                                ],
                                              ),
                                            ),
                                            InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          AddProductPage(),
                                                      settings: RouteSettings(
                                                        arguments: {
                                                          'tag': 'edit',
                                                          'product': product,
                                                        },
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Icon(Icons.edit)),
                                            InkWell(
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                      title: Text(
                                                          'Delete ${product.name}'),
                                                      content: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Text(
                                                              'Are you sure want to delete ${product.name}?'),
                                                        ],
                                                      ),
                                                      actions: [
                                                        ElevatedButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child:
                                                                Text('Cancel')),
                                                        ElevatedButton(
                                                            style: ElevatedButton
                                                                .styleFrom(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .red),
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                              BlocProvider.of<
                                                                          ProductBloc>(
                                                                      context)
                                                                  .add(ProductDeleteEvent(
                                                                      product.id
                                                                          .toString()));
                                                            },
                                                            child:
                                                                Text('Delete'))
                                                      ],
                                                    ),
                                                  );
                                                },
                                                child: Icon(Icons.delete)),
                                            SizedBox(width: 5),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                ],
              );
            } else if (state is ProductError) {
              return Center(child: Text(state.message));
            }
            return Container();
          },
        ));
  }
}
