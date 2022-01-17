import 'package:flutter/material.dart';
import '/screens/decrypt_screen.dart';
import '/screens/encrypt_screen.dart';
import '/screens/generate_key_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({Key? key}) : super(key: key);

  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  List<Map<String, Object>>? _pages;
  int _selectedPageIndex = 0;

  @override
  void initState() {
    _pages = [
      {
        'page': GenerateKeyScreen(),
        'title': 'Generate Keypair',
      },
      {
        'page': const PgpScreen(),
        'title': 'Encrypt',
      },
      {
        'page': const DecryptScreen(),
        'title': 'Decrypt',
      },
    ];
    super.initState();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text(_pages![_selectedPageIndex]['title'] as String),
        actions: [
          DropdownButton(
            items: [
              DropdownMenuItem(
                child: Container(
                  child: Row(
                    children: const [
                      Icon(Icons.exit_to_app),
                      SizedBox(
                        width: 8,
                      ),
                      Text('Logout')
                    ],
                  ),
                ),
                value: 'logout',
              ),
            ],
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            onChanged: (itemIdentifier) {
              if (itemIdentifier == 'logout') {
                FirebaseAuth.instance.signOut();
              }
            },
          ),
        ],
      ),
      body: _pages![_selectedPageIndex]['page'] as Widget,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey.shade300,
        selectedItemColor: Colors.white,
        currentIndex: _selectedPageIndex,
        unselectedFontSize: 15,
        selectedFontSize: 20,
        selectedLabelStyle:
            const TextStyle(fontFamily: 'Lato', fontWeight: FontWeight.bold),
        // type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).colorScheme.primary,
            icon: Icon(Icons.category),
            label: 'Generate',
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).colorScheme.primary,
            icon: const Icon(Icons.lock),
            label: 'Encrypt',
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).colorScheme.primary,
            icon: const Icon(Icons.lock_open),
            label: 'Decrypt',
          ),
        ],
      ),
    );
  }
}
