// import 'dart:convert';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'OrderStatus/orderModel.dart';
// import 'OrderStatus/orderProvaider.dart';
// import 'package:http/http.dart' as http;
//
// DateTime currentDate = DateTime.now();
// String formattedDate = DateFormat('dd/MM/yyyy').format(currentDate);
//
// enum OrderStatusFilter {
//   New,
//   Preparing,
//   Ready,
//   Delivered,
// }
//
// class OrderDeatils extends StatefulWidget {
//   const OrderDeatils({Key? key}) : super(key: key);
//
//   @override
//   State<OrderDeatils> createState() => _OrderDeatilsState();
// }
//
// class _OrderDeatilsState extends State<OrderDeatils> {
//   OrderStatusFilter currentFilter = OrderStatusFilter.New;
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance?.addPostFrameCallback((_) {
//       OrderProvaider orderProvaider =
//           Provider.of<OrderProvaider>(context, listen: false);
//
//       // Fetch pending orders data
//       orderProvaider.fatchPanddingOrderData();
//     });
//   }
//
//   final firebaseUser = FirebaseAuth.instance.currentUser;
//
//   Future<void> _updateOrderStatus(String orderId, String newStatus) async {
//     OrderProvaider orderProvaider =
//         Provider.of<OrderProvaider>(context, listen: false);
//
//     // Update the order status in Firebase
//     await orderProvaider.sendOrderStatus(orderId, newStatus);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       // appBar: AppBar(
//       //   title: Text('Order Details New Design'),
//       //   backgroundColor: Colors.red,
//       // ),
//       body: Padding(
//         padding: const EdgeInsets.only(top: 30.0),
//         child: Consumer<OrderProvaider>(
//           builder: (context, orderProvaider, _) {
//             List<PendingOrder> pendingOrders =
//                 orderProvaider.getpendingOrdersList;
//             List<PendingOrder> filteredOrders = pendingOrders
//                 .where((order) =>
//                     (currentFilter == OrderStatusFilter.New &&
//                         order.orderStatus == 'pending') ||
//                     (currentFilter == OrderStatusFilter.Preparing &&
//                         order.orderStatus == 'Preparing') ||
//                     (currentFilter == OrderStatusFilter.Ready &&
//                         order.orderStatus == 'Ready') ||
//                     (currentFilter == OrderStatusFilter.Delivered &&
//                         order.orderStatus == 'Delivered'))
//                 .toList();
//
//             filteredOrders.sort((a, b) => a.orderTime.compareTo(b.orderTime));
//
//             return Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: SingleChildScrollView(
//                     scrollDirection:
//                         Axis.horizontal, // Make it scroll horizontally
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         ElevatedButton(
//                           onPressed: () {
//                             setState(() {
//                               currentFilter = OrderStatusFilter.New;
//                             });
//                           },
//                           style: ElevatedButton.styleFrom(
//                             primary: currentFilter == OrderStatusFilter.New
//                                 ? Colors.green
//                                 : Colors.grey,
//                           ),
//                           child: Text('New Orders'),
//                         ),
//                         SizedBox(
//                           width: 10,
//                         ),
//                         ElevatedButton(
//                           onPressed: () {
//                             setState(() {
//                               currentFilter = OrderStatusFilter.Preparing;
//                             });
//                           },
//                           style: ElevatedButton.styleFrom(
//                             primary:
//                                 currentFilter == OrderStatusFilter.Preparing
//                                     ? Colors.green
//                                     : Colors.grey,
//                           ),
//                           child: Text('Preparing'),
//                         ),
//                         SizedBox(
//                           width: 10,
//                         ),
//                         ElevatedButton(
//                           onPressed: () {
//                             setState(() {
//                               currentFilter = OrderStatusFilter.Ready;
//                             });
//                           },
//                           style: ElevatedButton.styleFrom(
//                             primary: currentFilter == OrderStatusFilter.Ready
//                                 ? Colors.green
//                                 : Colors.grey,
//                           ),
//                           child: Text('Ready'),
//                         ),
//                         SizedBox(
//                           width: 10,
//                         ),
//                         ElevatedButton(
//                           onPressed: () {
//                             setState(() {
//                               currentFilter = OrderStatusFilter.Delivered;
//                             });
//                           },
//                           style: ElevatedButton.styleFrom(
//                             primary:
//                                 currentFilter == OrderStatusFilter.Delivered
//                                     ? Colors.green
//                                     : Colors.grey,
//                           ),
//                           child: Text('Delivered'),
//                         ),
//                         SizedBox(
//                           width: 10,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: filteredOrders.length,
//                     itemBuilder: (context, index) {
//                       PendingOrder pendingOrder = filteredOrders[index];
//
//                       return Container(
//                         margin: EdgeInsets.all(20),
//                         child: Card(
//                           elevation: 4,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             side: BorderSide(
//                               color: Colors.grey,
//                               width: 1,
//                             ),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   children: [
//                                     Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text("Name: ${pendingOrder.userName}"),
//                                         SizedBox(
//                                           height: 8,
//                                         ),
//                                         Text("Time: ${pendingOrder.orderTime}"),
//                                         SizedBox(
//                                           height: 8,
//                                         )
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                                 Divider(color: Colors.black),
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Flexible(
//                                       child: Text("Item",
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.bold)),
//                                     ),
//                                     Spacer(),
//                                     Flexible(
//                                       child: Text("Quantity",
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.bold)),
//                                     ),
//                                     Spacer(),
//                                     Flexible(
//                                       child: Text("Price",
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.bold)),
//                                     ),
//                                   ],
//                                 ),
//                                 Divider(color: Colors.black),
//                                 FutureBuilder<List<OrderItem>>(
//                                   future: orderProvaider
//                                       .fetchOrderItemsForPendingOrder(
//                                           pendingOrder.orderId),
//                                   builder: (context, snapshot) {
//                                     if (snapshot.connectionState ==
//                                         ConnectionState.waiting) {
//                                       return CircularProgressIndicator();
//                                     } else if (snapshot.hasError) {
//                                       return Text('Error: ${snapshot.error}');
//                                     } else {
//                                       List<OrderItem> orderItems =
//                                           snapshot.data ?? [];
//
//                                       return Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: orderItems.map((orderItem) {
//                                           return Padding(
//                                             padding: const EdgeInsets.only(
//                                                 top: 10.0),
//                                             child: Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment
//                                                       .spaceBetween,
//                                               children: [
//                                                 Flexible(
//                                                   child:
//                                                       Text(orderItem.itemName!),
//                                                 ),
//                                                 Spacer(),
//                                                 Text(orderItem.itemQuantity
//                                                     .toString()),
//                                                 Spacer(),
//                                                 Text(orderItem.itemPrice
//                                                     .toString()),
//                                               ],
//                                             ),
//                                           );
//                                         }).toList(),
//                                       );
//                                     }
//                                   },
//                                 ),
//                                 Divider(color: Colors.black),
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text("Total : "),
//                                     Text(pendingOrder.totalAmount.toString()),
//                                   ],
//                                 ),
//                                 Divider(color: Colors.black),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Center(
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           if (currentFilter ==
//                                                   OrderStatusFilter.New &&
//                                               pendingOrder.orderStatus ==
//                                                   'pending')
//                                             TextButton(
//                                               child: Text('Accept'),
//                                               onPressed: () async {
//                                                 // Update order status to "Accepted"
//
//                                                 try {
//                                                   await _updateOrderStatus(
//                                                       pendingOrder.orderId,
//                                                       'Preparing');
//                                                   // pendingOrder.orderStatus =
//                                                   //     'Preparing';
//                                                   // print(".////////////////");
//
//                                                   // print(
//                                                   //     pendingOrder.orderStatus);
//
//                                                   // Call sendToConformHistory and pass the necessary parameters
//
//                                                   await orderProvaider
//                                                       .sendToConformHistory(
//                                                     firebaseUser!
//                                                         .uid, // Shop ID
//                                                     pendingOrder
//                                                         .userId, // User ID
//                                                     orderProvaider
//                                                         .getpendingOrdersList, // List of pending orders
//                                                     orderProvaider
//                                                         .getorderItemMainList,
//                                                     // List of order items
//                                                     "Prepering",
//
//                                                     pendingOrder
//                                                         .orderId, // Order ID
//                                                     index, // Index of the accepted order
//                                                   );
//                                                 } catch (e) {
//                                                   print('Error: $e');
//                                                 }
//                                               },
//                                             ),
//                                           if (currentFilter ==
//                                                   OrderStatusFilter.Preparing &&
//                                               pendingOrder.orderStatus ==
//                                                   'Preparing')
//                                             TextButton(
//                                               child: Text('Ready'),
//                                               onPressed: () async {
//                                                 // Update order status to "Ready"
//                                                 await _updateOrderStatus(
//                                                     pendingOrder.orderId,
//                                                     'Ready');
//                                                 // await _updateOrderStatus(
//                                                 //     pendingOrder.orderId,
//                                                 //     'Accepted');
//
//                                                 await orderProvaider
//                                                     .updateOrderStatus(
//                                                         firebaseUser!.uid,
//                                                         pendingOrder.userId,
//                                                         "Ready",
//                                                         pendingOrder.orderId);
//                                               },
//                                             ),
//                                           if (currentFilter ==
//                                                   OrderStatusFilter.Ready &&
//                                               pendingOrder.orderStatus ==
//                                                   'Ready')
//                                             TextButton(
//                                               child: Text('Delivered'),
//                                               onPressed: () async {
//                                                 // Update order status to "Delivered"
//                                                 await _updateOrderStatus(
//                                                     pendingOrder.orderId,
//                                                     'Delivered');
//
//                                                 await orderProvaider
//                                                     .updateOrderStatus(
//                                                         firebaseUser!.uid,
//                                                         pendingOrder.userId,
//                                                         "Delivered",
//                                                         pendingOrder.orderId);
//                                               },
//                                             ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// 2nd

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// // import 'package:provider/provider';
// import 'package:provider/provider.dart';
// import 'OrderStatus/orderModel.dart';
// import 'OrderStatus/orderProvaider.dart';
//
// enum OrderStatusFilter {
//   New,
//   Preparing,
//   Ready,
//   Delivered,
// }
//
// class OrderDeatils extends StatefulWidget {
//   const OrderDeatils({Key? key}) : super(key: key);
//
//   @override
//   State<OrderDeatils> createState() => _OrderDeatilsState();
// }
//
// class _OrderDeatilsState extends State<OrderDeatils> {
//   OrderStatusFilter currentFilter = OrderStatusFilter.New;
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance?.addPostFrameCallback((_) {
//       OrderProvaider orderProvaider =
//           Provider.of<OrderProvaider>(context, listen: false);
//
//       // Fetch pending orders data
//       orderProvaider.fetchOrdersAndItems();
//     });
//   }
//
//   Future<void> _updateOrderStatus(String orderId, String newStatus) async {
//     OrderProvaider orderProvaider =
//         Provider.of<OrderProvaider>(context, listen: false);
//
//     // Update the order status in Firebase
//     await orderProvaider.sendOrderStatus(orderId, newStatus);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Padding(
//         padding: const EdgeInsets.only(top: 30.0),
//         child: Consumer<OrderProvaider>(
//           builder: (context, orderProvaider, _) {
//             List<PendingOrder> pendingOrders = orderProvaider.pendingOrderList;
//             List<PendingOrder> filteredOrders = pendingOrders
//                 .where((order) =>
//                     (currentFilter == OrderStatusFilter.New &&
//                         order.orderStatus == 'pending') ||
//                     (currentFilter == OrderStatusFilter.Preparing &&
//                         order.orderStatus == 'Preparing') ||
//                     (currentFilter == OrderStatusFilter.Ready &&
//                         order.orderStatus == 'Ready') ||
//                     (currentFilter == OrderStatusFilter.Delivered &&
//                         order.orderStatus == 'Delivered'))
//                 .toList();
//
//             filteredOrders.sort((a, b) => a.orderTime.compareTo(b.orderTime));
//
//             return Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         ElevatedButton(
//                           onPressed: () {
//                             setState(() {
//                               currentFilter = OrderStatusFilter.New;
//                             });
//                           },
//                           style: ElevatedButton.styleFrom(
//                             primary: currentFilter == OrderStatusFilter.New
//                                 ? Colors.green
//                                 : Colors.grey,
//                           ),
//                           child: Text('New Orders'),
//                         ),
//                         SizedBox(width: 10),
//                         ElevatedButton(
//                           onPressed: () {
//                             setState(() {
//                               currentFilter = OrderStatusFilter.Preparing;
//                             });
//                           },
//                           style: ElevatedButton.styleFrom(
//                             primary:
//                                 currentFilter == OrderStatusFilter.Preparing
//                                     ? Colors.green
//                                     : Colors.grey,
//                           ),
//                           child: Text('Preparing'),
//                         ),
//                         SizedBox(width: 10),
//                         ElevatedButton(
//                           onPressed: () {
//                             setState(() {
//                               currentFilter = OrderStatusFilter.Ready;
//                             });
//                           },
//                           style: ElevatedButton.styleFrom(
//                             primary: currentFilter == OrderStatusFilter.Ready
//                                 ? Colors.green
//                                 : Colors.grey,
//                           ),
//                           child: Text('Ready'),
//                         ),
//                         SizedBox(width: 10),
//                         ElevatedButton(
//                           onPressed: () {
//                             setState(() {
//                               currentFilter = OrderStatusFilter.Delivered;
//                             });
//                           },
//                           style: ElevatedButton.styleFrom(
//                             primary:
//                                 currentFilter == OrderStatusFilter.Delivered
//                                     ? Colors.green
//                                     : Colors.grey,
//                           ),
//                           child: Text('Delivered'),
//                         ),
//                         SizedBox(width: 10),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: filteredOrders.length,
//                     itemBuilder: (context, index) {
//                       PendingOrder pendingOrder = filteredOrders[index];
//
//                       return Container(
//                         margin: EdgeInsets.all(20),
//                         child: Card(
//                           elevation: 4,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             side: BorderSide(
//                               color: Colors.grey,
//                               width: 1,
//                             ),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   children: [
//                                     Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text("Name: ${pendingOrder.userName}"),
//                                         SizedBox(height: 8),
//                                         Text("Time: ${pendingOrder.orderTime}"),
//                                         SizedBox(height: 8),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                                 Divider(color: Colors.black),
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Flexible(
//                                       child: Text("Item",
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.bold)),
//                                     ),
//                                     Spacer(),
//                                     Flexible(
//                                       child: Text("Quantity",
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.bold)),
//                                     ),
//                                     Spacer(),
//                                     Flexible(
//                                       child: Text("Price",
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.bold)),
//                                     ),
//                                   ],
//                                 ),
//                                 Divider(color: Colors.black),
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children:
//                                       pendingOrder.orderItems.map((orderItem) {
//                                     return Padding(
//                                       padding: const EdgeInsets.only(top: 10.0),
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Flexible(
//                                             child: Text(orderItem.itemName!),
//                                           ),
//                                           Spacer(),
//                                           Text(orderItem.itemQuantity
//                                               .toString()),
//                                           Spacer(),
//                                           Text(orderItem.itemPrice.toString()),
//                                         ],
//                                       ),
//                                     );
//                                   }).toList(),
//                                 ),
//                                 Divider(color: Colors.black),
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text("Total : "),
//                                     Text(pendingOrder.totalAmount.toString()),
//                                   ],
//                                 ),
//                                 Divider(color: Colors.black),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Center(
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           if (currentFilter ==
//                                                   OrderStatusFilter.New &&
//                                               pendingOrder.orderStatus ==
//                                                   'pending')
//                                             TextButton(
//                                               child: Text('Accept'),
//                                               onPressed: () async {
//                                                 try {
//                                                   await _updateOrderStatus(
//                                                       pendingOrder.orderId,
//                                                       'Preparing');
//                                                   await orderProvaider
//                                                       .sendToConformHistory(
//                                                     FirebaseAuth
//                                                         .instance
//                                                         .currentUser!
//                                                         .uid, // Shop ID
//                                                     pendingOrder
//                                                         .userId, // User ID
//                                                     orderProvaider
//                                                         .pendingOrderList, // List of pending orders
//                                                     pendingOrder
//                                                         .orderItems, // List of order items
//                                                     "Preparing",
//                                                     pendingOrder
//                                                         .orderId, // Order ID
//                                                     index, // Index of the accepted order
//                                                   );
//                                                 } catch (e) {
//                                                   print('Error: $e');
//                                                 }
//                                               },
//                                             ),
//                                           if (currentFilter ==
//                                                   OrderStatusFilter.Preparing &&
//                                               pendingOrder.orderStatus ==
//                                                   'Preparing')
//                                             TextButton(
//                                               child: Text('Ready'),
//                                               onPressed: () async {
//                                                 await _updateOrderStatus(
//                                                     pendingOrder.orderId,
//                                                     'Ready');
//                                                 await orderProvaider
//                                                     .updateOrderStatus(
//                                                   FirebaseAuth.instance
//                                                       .currentUser!.uid,
//                                                   pendingOrder.userId,
//                                                   "Ready",
//                                                   pendingOrder.orderId,
//                                                 );
//                                               },
//                                             ),
//                                           if (currentFilter ==
//                                                   OrderStatusFilter.Ready &&
//                                               pendingOrder.orderStatus ==
//                                                   'Ready')
//                                             TextButton(
//                                               child: Text('Delivered'),
//                                               onPressed: () async {
//                                                 await _updateOrderStatus(
//                                                     pendingOrder.orderId,
//                                                     'Delivered');
//                                                 await orderProvaider
//                                                     .updateOrderStatus(
//                                                   FirebaseAuth.instance
//                                                       .currentUser!.uid,
//                                                   pendingOrder.userId,
//                                                   "Delivered",
//                                                   pendingOrder.orderId,
//                                                 );
//                                               },
//                                             ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// 3rd

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'OrderStatus/orderModel.dart';
import 'OrderStatus/orderProvaider.dart';
// import 'orderModel.dart';
// import 'order_provider.dart';

enum OrderStatusFilter {
  New,
  Preparing,
  Ready,
  Delivered,
}

class OrderDetails extends StatefulWidget {
  const OrderDetails({Key? key}) : super(key: key);

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  Future<void> _updateOrderStatus(String orderId, String newStatus) async {
    OrderProvider orderProvider =
        Provider.of<OrderProvider>(context, listen: false);

    // Update the order status in Firebase
    await orderProvider.sendOrderStatus(orderId, newStatus);
  }

  OrderStatusFilter currentFilter = OrderStatusFilter.New;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      OrderProvider orderProvider =
          Provider.of<OrderProvider>(context, listen: false);
      orderProvider.fetchOrdersAndItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: Consumer<OrderProvider>(
          builder: (context, orderProvider, _) {
            List<PendingOrder> pendingOrders = orderProvider.pendingOrderList;
            List<PendingOrder> filteredOrders = pendingOrders
                .where((order) =>
                    (currentFilter == OrderStatusFilter.New &&
                        order.orderStatus == 'pending') ||
                    (currentFilter == OrderStatusFilter.Preparing &&
                        order.orderStatus == 'Preparing') ||
                    (currentFilter == OrderStatusFilter.Ready &&
                        order.orderStatus == 'Ready') ||
                    (currentFilter == OrderStatusFilter.Delivered &&
                        order.orderStatus == 'Delivered'))
                .toList();

            filteredOrders.sort((a, b) => a.orderTime.compareTo(b.orderTime));

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              currentFilter = OrderStatusFilter.New;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                currentFilter == OrderStatusFilter.New
                                    ? Colors.green
                                    : Colors.grey,
                          ),
                          child: Text('New Orders'),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              currentFilter = OrderStatusFilter.Preparing;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                currentFilter == OrderStatusFilter.Preparing
                                    ? Colors.green
                                    : Colors.grey,
                          ),
                          child: Text('Preparing'),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              currentFilter = OrderStatusFilter.Ready;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                currentFilter == OrderStatusFilter.Ready
                                    ? Colors.green
                                    : Colors.grey,
                          ),
                          child: Text('Ready'),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              currentFilter = OrderStatusFilter.Delivered;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                currentFilter == OrderStatusFilter.Delivered
                                    ? Colors.green
                                    : Colors.grey,
                          ),
                          child: Text('Delivered'),
                        ),
                        SizedBox(width: 10),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredOrders.length,
                    itemBuilder: (context, index) {
                      PendingOrder pendingOrder = filteredOrders[index];

                      return Container(
                        margin: EdgeInsets.all(20),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Name: ${pendingOrder.userName}"),
                                        SizedBox(height: 8),
                                        Text("Time: ${pendingOrder.orderTime}"),
                                        SizedBox(height: 8),
                                      ],
                                    ),
                                  ],
                                ),
                                Divider(color: Colors.black),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text("Item",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Spacer(),
                                    Flexible(
                                      child: Text("Quantity",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Spacer(),
                                    Flexible(
                                      child: Text("Price",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                                Divider(color: Colors.black),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:
                                      pendingOrder.orderItems.map((orderItem) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Text(orderItem.itemName!),
                                          ),
                                          Spacer(),
                                          Text(orderItem.itemQuantity
                                              .toString()),
                                          Spacer(),
                                          Text(orderItem.itemPrice.toString()),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                                Divider(color: Colors.black),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Total : "),
                                    Text(pendingOrder.totalAmount.toString()),
                                  ],
                                ),
                                Divider(color: Colors.black),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          if (currentFilter ==
                                                  OrderStatusFilter.New &&
                                              pendingOrder.orderStatus ==
                                                  'pending')
                                            TextButton(
                                              child: Text('Accept'),
                                              onPressed: () async {
                                                try {
                                                  await _updateOrderStatus(
                                                      pendingOrder.orderId,
                                                      'Preparing');
                                                  await orderProvider
                                                      .sendToConformHistory(
                                                    FirebaseAuth
                                                        .instance
                                                        .currentUser!
                                                        .uid, // Shop ID
                                                    pendingOrder
                                                        .userId, // User ID
                                                    orderProvider
                                                        .pendingOrderList, // List of pending orders
                                                    pendingOrder
                                                        .orderItems, // List of order items
                                                    "Preparing",
                                                    pendingOrder
                                                        .orderId, // Order ID
                                                    index, // Index of the accepted order
                                                  );
                                                } catch (e) {
                                                  print('Error: $e');
                                                }
                                              },
                                            ),
                                          if (currentFilter ==
                                                  OrderStatusFilter.Preparing &&
                                              pendingOrder.orderStatus ==
                                                  'Preparing')
                                            TextButton(
                                              child: Text('Ready'),
                                              onPressed: () async {
                                                await _updateOrderStatus(
                                                    pendingOrder.orderId,
                                                    'Ready');
                                                await orderProvider
                                                    .updateOrderStatus(
                                                  FirebaseAuth.instance
                                                      .currentUser!.uid,
                                                  pendingOrder.userId,
                                                  "Ready",
                                                  pendingOrder.orderId,
                                                );
                                              },
                                            ),
                                          if (currentFilter ==
                                                  OrderStatusFilter.Ready &&
                                              pendingOrder.orderStatus ==
                                                  'Ready')
                                            TextButton(
                                              child: Text('Delivered'),
                                              onPressed: () async {
                                                await _updateOrderStatus(
                                                    pendingOrder.orderId,
                                                    'Delivered');
                                                await orderProvider
                                                    .updateOrderStatus(
                                                  FirebaseAuth.instance
                                                      .currentUser!.uid,
                                                  pendingOrder.userId,
                                                  "Delivered",
                                                  pendingOrder.orderId,
                                                );
                                              },
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
