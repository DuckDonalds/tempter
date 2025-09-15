final querySnapshot = await FirebaseFirestore.instance
    .collection('users')
    .doc(user.uid)
    .collection('subscriptionHistory')
    .orderBy('timestamp', descending: true)
    .get();

final fetchedTransactions = querySnapshot.docs.map((doc) {
  final data = doc.data();
  return SubscriptionTransaction(
    type: data['type'] ?? 'Nieznany',
    plan: data['plan'] ?? 'Brak',
    date: (data['timestamp'] as Timestamp).toDate(),
    fromPlan: data['fromPlan'],
    toPlan: data['toPlan'],
  );
}).toList();
