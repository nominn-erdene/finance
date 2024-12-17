import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance/menu/bottom_navigation.dart';
import 'package:finance/screens/card_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: const BoxDecoration(
                color: Color(0xFF388b85),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 50),
                child: AppBar(
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BottomNavigation(),
                        ),
                      );
                    },
                  ),
                  title: const Text(
                    'Түрийвч',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.notifications_active_rounded),
                      color: Colors.white,
                      onPressed: () {},
                    ),
                  ],
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  centerTitle: true,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 180),
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  color: Colors.white,
                ),
                height: double.infinity,
                width: double.infinity,
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Center(
                        child: Text(
                          'Нийт үлдэгдэл',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    StreamBuilder<List<QuerySnapshot>>(
                      stream: CombineLatestStream.list([
                        FirebaseFirestore.instance
                            .collection('Incomes')
                            .snapshots(),
                        FirebaseFirestore.instance
                            .collection('Expenses')
                            .snapshots(),
                      ]),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.hasError) {
                          return const Center(
                            child: Text('Алдаа гарлаа!'),
                          );
                        }

                        // Орлого, зарлагын нийт дүнг тооцоолох
                        double totalIncome =
                            snapshot.data![0].docs.fold(0.0, (sum, doc) {
                          return sum +
                              (double.tryParse((doc.data()
                                              as Map<String, dynamic>)['fee']
                                          ?.toString() ??
                                      '0') ??
                                  0);
                        });

                        double totalExpense =
                            snapshot.data![1].docs.fold(0.0, (sum, doc) {
                          return sum +
                              (double.tryParse((doc.data()
                                              as Map<String, dynamic>)['fee']
                                          ?.toString() ??
                                      '0') ??
                                  0);
                        });

                        double totalBalance = totalIncome - totalExpense;

                        return Text(
                          '₮${totalBalance.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _ActionButton(icon: Icons.payment, label: 'Төлөх'),
                        const _ActionButton(icon: Icons.send, label: 'Илгээх'),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CardInfoScreen()), // Replace RechargeScreen with your target widget
                            );
                          },
                          child: const _ActionButton(
                              icon: Icons.flash_auto, label: 'Цэнэглэх'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const TabBar(
                      tabs: [
                        Tab(text: 'Гүйлгээнүүд'),
                        Tab(text: 'Хүлээгдэж буй'),
                      ],
                      unselectedLabelColor: Colors.grey,
                      labelColor: Colors.teal,
                      labelStyle:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorPadding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                    const Expanded(
                      child: TabBarView(
                        children: [
                          TransactionsTab(),
                          PendingTransactionsTab(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TransactionsTab extends StatelessWidget {
  const TransactionsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<QuerySnapshot>>(
      // Орлого, зарлага хоёулыг нэгтгэж харуулах
      stream: CombineLatestStream.list([
        FirebaseFirestore.instance
            .collection('Incomes')
            .orderBy('time', descending: true)
            .snapshots(),
        FirebaseFirestore.instance
            .collection('Expenses')
            .orderBy('time', descending: true)
            .snapshots(),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Алдаа гарлаа!'));
        }

        // Орлого, зарлагын документуудыг нэгтгэх
        final List<DocumentSnapshot> allDocs = [];
        final incomes = snapshot.data![0].docs;
        final expenses = snapshot.data![1].docs;

        allDocs.addAll(incomes);
        allDocs.addAll(expenses);

        // Огноогоор эрэмбэлэх
        allDocs.sort((a, b) {
          final aTime = (a.data() as Map<String, dynamic>)['time'] as Timestamp;
          final bTime = (b.data() as Map<String, dynamic>)['time'] as Timestamp;
          return bTime.compareTo(aTime);
        });

        return ListView.builder(
          itemCount: allDocs.length,
          itemBuilder: (context, index) {
            final data = allDocs[index].data() as Map<String, dynamic>;
            final isIncome = allDocs[index].reference.parent.id == 'Incomes';

            // Огноог форматлах
            String formattedTime = '';
            if (data['time'] is Timestamp) {
              Timestamp timestamp = data['time'];
              DateTime dateTime = timestamp.toDate();
              formattedTime =
                  '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
                  '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
            }

            return ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    data['image'] ?? '',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              title: Text(data['name'] ?? 'Нэргүй'),
              subtitle: Text(formattedTime),
              trailing: Text(
                // Орлого бол +, зарлага бол - тэмдэг
                '${isIncome ? "+" : "-"} ₮${(double.tryParse(data['fee']?.toString() ?? '0') ?? 0).abs()}',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                  color: isIncome ? Colors.green : Colors.red,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class PendingTransactionsTab extends StatelessWidget {
  const PendingTransactionsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Expenses')
          .where('status', isEqualTo: 'pending') // Хүлээгдэж буй
          .orderBy('time', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Алдаа гарлаа!'));
        }

        final docs = snapshot.data!.docs;

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;

            // Convert Timestamp to String using DateTime
            String formattedTime = '';
            if (data['time'] is Timestamp) {
              Timestamp timestamp = data['time'];
              DateTime dateTime = timestamp.toDate();
              formattedTime =
                  '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
                  '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
            } else {
              formattedTime = data['time'] ?? 'Цаг байхгүй';
            }

            return ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    data['image'] ?? '', // Image URL
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              title: Text(data['name'] ?? 'Нэргүй'),
              subtitle: Text(formattedTime),
              trailing: Text(
                // Directly handle the sign of the fee
                '${(data['fee'] ?? 0) > 0 ? '+' : '-'} ₮ ${data['fee'] ?? 0}',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                  color: (data['fee'] ?? 0) > 0 ? Colors.green : Colors.red,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _TransactionItem extends StatefulWidget {
  final IconData icon;
  final String title;
  final String date;
  final String amount;
  final Color amountColor;

  const _TransactionItem({
    required this.icon,
    required this.title,
    required this.date,
    required this.amount,
    required this.amountColor,
  });

  @override
  State<_TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<_TransactionItem> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey[200],
        child: Icon(widget.icon, color: Colors.black),
      ),
      title: Text(widget.title),
      subtitle: Text(widget.date),
      trailing: Text(
        widget.amount,
        style:
            TextStyle(color: widget.amountColor, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ActionButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF388b85),
              width: 1,
            ),
          ),
          child: Center(
            child: Icon(icon, color: const Color(0xFF388b85), size: 30),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
