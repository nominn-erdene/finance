import 'package:flutter/material.dart';

class CardInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Турйивч цэнэглэх'),
        leading: Icon(Icons.arrow_back),
        actions: [Icon(Icons.notifications)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ToggleButtons(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('Картууд'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('Аккаунт'),
                ),
              ],
              isSelected: [true, false],
              onPressed: (index) {},
            ),
            SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                height: 150,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.teal, Colors.green],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Debit Card',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      '6219 8610 2888 8075',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        letterSpacing: 2.0,
                      ),
                    ),
                    Text(
                      'IRVAN MOSES',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      '22/01',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Карт дээрх нэр',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'КАРТЫН ДУГААР',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'CVC',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'ДУУСАХ ХУГАЦАА YYYY/MM',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'ZIP',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AccountLinkScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Турйивчтэй холбох'),
        leading: Icon(Icons.arrow_back),
        actions: [Icon(Icons.notifications)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ToggleButtons(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('Картууд'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('Аккаунт'),
                ),
              ],
              isSelected: [false, true],
              onPressed: (index) {},
            ),
            SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.account_balance),
              title: Text('Bank Link'),
              subtitle: Text('Connect your bank account to deposit & fund'),
              trailing: Icon(Icons.check_circle, color: Colors.green),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.attach_money),
              title: Text('Microdeposits'),
              subtitle: Text('Connect bank in 5-7 days'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.payment),
              title: Text('Paypal'),
              subtitle: Text('Connect your Paypal account'),
              onTap: () {},
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {},
              child: Text('ДАРААХ'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CardInfoScreen(),
    routes: {
      '/accountLink': (context) => AccountLinkScreen(),
    },
  ));
}
