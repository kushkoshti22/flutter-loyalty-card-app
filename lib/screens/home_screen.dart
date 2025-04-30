import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/loyalty_card_provider.dart';
import '../models/loyalty_card.dart';
import 'add_card_screen.dart';
import 'qr_code_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load cards when the screen is first created
    Future.microtask(
      () =>
          Provider.of<LoyaltyCardProvider>(context, listen: false).loadCards(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Loyalty Cards'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search functionality
            },
          ),
        ],
      ),
      body: Consumer<LoyaltyCardProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.cards.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.credit_card, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'No loyalty cards yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddCardScreen(),
                        ),
                      );
                    },
                    child: const Text('Add Your First Card'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: provider.cards.length,
            itemBuilder: (context, index) {
              final card = provider.cards[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Text(
                      card.name[0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(card.name),
                  subtitle: Text(card.cardNumber),
                  trailing: IconButton(
                    icon: const Icon(Icons.qr_code),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QRCodeScreen(card: card),
                        ),
                      );
                    },
                  ),
                  onTap: () {
                    // TODO: Navigate to card details
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddCardScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
