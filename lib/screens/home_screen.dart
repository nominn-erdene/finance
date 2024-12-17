import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double totalIncome = 0.0;
  double totalExpense = 0.0;

  // Fetch income data and calculate totalIncome
  Future<void> _fetchIncomeData() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('Incomes').get();
    double income = 0.0;
    for (var doc in snapshot.docs) {
      // Convert fee from string to double
      double fee = double.tryParse(doc['fee'].toString()) ?? 0.0;
      income += fee;
    }
    setState(() {
      totalIncome = income;
      print('Total Income: $totalIncome'); // Debugging line
    });
  }

  // Fetch expense data and calculate totalExpense
  Future<void> _fetchExpenseData() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('Expenses').get();
    double expense = 0.0;
    for (var doc in snapshot.docs) {
      // Convert fee from string to double
      double fee = double.tryParse(doc['fee'].toString()) ?? 0.0;
      expense += fee;
    }
    setState(() {
      totalExpense = expense;
      print('Total Expense: $totalExpense'); // Debugging line
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchIncomeData();
    _fetchExpenseData();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size using MediaQuery
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: SizedBox(
                      height: screenHeight * 0.4, child: _header(screenWidth)),
                ),
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Гүйлгээний түүх',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 19,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'Бүгдийг харах',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // FutureBuilder for Incomes
                FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('Incomes')
                      .orderBy('time',
                          descending: true) // Order by time descending
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SliverToBoxAdapter(
                          child: Center(child: CircularProgressIndicator()));
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const SliverToBoxAdapter(
                          child: Center(child: Text("No data available")));
                    }

                    // Show list of incomes
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final data = snapshot.data!.docs[index];
                          final name = data['name'];
                          final image = data['image'];
                          final time = data['time']; // Timestamp field
                          final fee = data['fee'];

                          // Convert Timestamp to DateTime and format it manually
                          final timeFormatted = (time as Timestamp).toDate();
                          final formattedTime =
                              '${timeFormatted.day}/${timeFormatted.month}/${timeFormatted.year}';

                          return ListTile(
                            leading: Container(
                              width: screenWidth *
                                  0.1, // Adjust the size based on screen width
                              height: screenWidth *
                                  0.1, // Adjust the size based on screen width
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            title: Text(
                              name,
                              style: TextStyle(
                                fontSize:
                                    screenWidth * 0.045, // Relative font size
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              formattedTime,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize:
                                    screenWidth * 0.04, // Relative font size
                              ),
                            ),
                            trailing: Text(
                              '₮ ${fee}',
                              style: TextStyle(
                                fontSize:
                                    screenWidth * 0.05, // Relative font size
                                fontWeight: FontWeight.w600,
                                color: Colors.green,
                              ),
                            ),
                          );
                        },
                        childCount: snapshot
                            .data!.docs.length, // Dynamically set the count
                      ),
                    );
                  },
                ),
                // FutureBuilder for Expenses
                FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('Expenses')
                      .orderBy('time',
                          descending: true) // Order by time descending
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SliverToBoxAdapter(
                          child: Center(child: CircularProgressIndicator()));
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const SliverToBoxAdapter(
                          child: Center(child: Text("No data available")));
                    }

                    // Show list of expenses
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final data = snapshot.data!.docs[index];
                          final name = data['name'];
                          final image = data['image'];
                          final time = data['time']; // Timestamp field
                          final fee = data['fee'];

                          // Convert Timestamp to DateTime and format it manually
                          final timeFormatted = (time as Timestamp).toDate();
                          final formattedTime =
                              '${timeFormatted.day}/${timeFormatted.month}/${timeFormatted.year}';

                          return ListTile(
                            leading: Container(
                              width: screenWidth *
                                  0.1, // Adjust the size based on screen width
                              height: screenWidth *
                                  0.1, // Adjust the size based on screen width
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            title: Text(
                              name,
                              style: TextStyle(
                                fontSize:
                                    screenWidth * 0.045, // Relative font size
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              formattedTime,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize:
                                    screenWidth * 0.04, // Relative font size
                              ),
                            ),
                            trailing: Text(
                              '₮ ${fee}',
                              style: TextStyle(
                                fontSize:
                                    screenWidth * 0.05, // Relative font size
                                fontWeight: FontWeight.w600,
                                color: Colors.red,
                              ),
                            ),
                          );
                        },
                        childCount: snapshot
                            .data!.docs.length, // Dynamically set the count
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _header(double screenWidth) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: screenWidth * 0.6, // Adjust based on screen width
          decoration: const BoxDecoration(
            color: Color(0xFF388b85),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
        ),
        Positioned(
          top: 140,
          left: 37,
          child: Container(
            height: 170,
            width: 320,
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(47, 125, 121, .3),
                  offset: Offset(0, 6),
                  blurRadius: 12,
                  spreadRadius: 6,
                ),
              ],
              color: const Color.fromARGB(255, 47, 125, 121),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Нийт үлдэгдэл',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      Icon(
                        Icons.more_horiz,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 7),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Row(
                    children: [
                      Text(
                        '₮ ${totalIncome - totalExpense}', // Calculate remaining balance
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 13,
                            backgroundColor: Color.fromARGB(255, 85, 145, 141),
                            child: Icon(
                              Icons.arrow_downward,
                              color: Colors.white,
                              size: 19,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Орлого',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Color.fromARGB(255, 216, 216, 216),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 13,
                            backgroundColor: Color.fromARGB(255, 85, 145, 141),
                            child: Icon(
                              Icons.arrow_upward,
                              color: Colors.white,
                              size: 19,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Зарлага',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Color.fromARGB(255, 216, 216, 216),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '₮ ${totalIncome}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '₮ ${totalExpense}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: screenWidth * 0.1, // Adjust position based on screen width
          left: screenWidth * 0.05, // Adjust position based on screen width
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Өглөөний мэнд?',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: screenWidth * 0.04, // Relative font size
                  color: const Color.fromARGB(255, 216, 216, 216),
                ),
              ),
              Text(
                'Пүрэвдорж Номин-Эрдэнэ',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: screenWidth * 0.055, // Relative font size
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
