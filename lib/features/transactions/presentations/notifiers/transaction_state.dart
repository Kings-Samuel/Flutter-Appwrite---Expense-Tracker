import 'package:appwrite/appwrite.dart';
import 'package:flutter/foundation.dart';
import 'package:flutterappwrite/core/res/app_constants.dart';
import 'package:flutterappwrite/features/transactions/data/model/transaction.dart';

class TransactionState extends ChangeNotifier {
  final String collectionId = "62693a6b7f00ca9061ac";
  late Client client = Client();
  late Database db;
  String? _error;
  String? get error => _error;
  List<Transaction>? _transactions;
  List<Transaction>? get transactions => _transactions!;

  late String _query;
  List<Transaction>? _searchResults;

  set query(String? query) {
    _query = query!;
    _searchTransactions();
    notifyListeners();
  }

  List<Transaction>? get searchResults => _searchResults ?? [];
  Database get getDb => db;

  TransactionState() {
    _init();
  }

  _init() {
    client
        .setEndpoint(AppConstants.endpoint)
        .setProject(AppConstants.projectId);
    db = Database(client);
    _transactions = [];
    _query = "";
    getTransactions();
  }

  Future<List<Transaction>?> getTransactions() async {
    try {
      final res = (await db.listDocuments(
          collectionId: collectionId, 
          orderAttributes: ["transaction_date"],
          orderTypes: ["ASC"]
      ));
      _transactions = <Transaction>[
        ...res.documents.map((doc) => Transaction.fromJson(doc.data))
      ];
      notifyListeners();
      return _transactions;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return <Transaction>[];
    }
  }

  Future<void> addTransaction(Transaction transaction) async {
    try {
      final res = await db.createDocument(
          collectionId: collectionId,
          data: transaction.toJson(),
          documentId: "unique()",
          read: ["user:${transaction.userId}"],
          write: ["user:${transaction.userId}"]);
      _transactions!.add(Transaction.fromJson(res.data));
      notifyListeners();
      if (kDebugMode) {
        print(res.toString());
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      _error = e.toString();
      notifyListeners();
    }
  }

  Future updateTransaction(Transaction transaction) async {
    try {
      final res = await db.updateDocument(
          collectionId: collectionId,
          documentId: transaction.id!,
          data: transaction.toJson(),
          read: ["user:${transaction.userId}"],
          write: ["user:${transaction.userId}"]);

      // Transaction updated = Transaction.fromJson(res.data);
      // _transactions = List<Transaction>.from(_transactions!
      //     .map((tran) => {tran.id == updated.id ? updated : tran}));

      _transactions!.removeWhere((t) => t.id == transaction.id);
      _transactions!.add(Transaction.fromJson(res.data));
      notifyListeners();
      if (kDebugMode) {
        print(res.toString());
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteTransaction(Transaction transaction) async {
    try {
      final res = await db.deleteDocument(
        collectionId: collectionId,
        documentId: transaction.id!,
      );
      _transactions!.removeWhere((t) => t.id == transaction.id);
      notifyListeners();
      if (kDebugMode) {
        print(res.toString());
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> _searchTransactions() async {
    try {
      final res = await db.listDocuments(collectionId: collectionId, queries: [
        // Query.search('title', _query),
        Query.search('description', _query),
      ]);
      _searchResults = <Transaction>[
        ...res.documents.map((doc) => Transaction.fromJson(doc.data))
      ];
      notifyListeners();
      if (kDebugMode) {
        print(res.toString());
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<List<Transaction>?> queryTransactions({DateTime? from, DateTime? to}) async {
    try {
      final res = await db.listDocuments(collectionId: collectionId, queries: [
        Query.greaterEqual('transaction_date', from!.millisecondsSinceEpoch,),
        Query.lesserEqual('transaction_date', to!.millisecondsSinceEpoch),
      ]);
      return <Transaction>[
        ...res.documents.map((doc) => Transaction.fromJson(doc.data))
      ];
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      _error = e.toString();
      notifyListeners();
      return <Transaction>[];
    }
  }
}
