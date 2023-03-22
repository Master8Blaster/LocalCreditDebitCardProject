import 'package:cardproject/models/CardModel.dart';
import 'package:cardproject/models/CardOwnerModel.dart';
import 'package:cardproject/models/ExpenseModel.dart';
import 'package:cardproject/utils/GlobalMethods.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseHelper {
  static final _databaseName = "carddb.db";
  static final _databaseVersion = 1;

  // card holder table name and column names
  static const CARD_OWNER_TABLE = 'card_Owner_table';
  static const cardOwnerId = 'card_Owner_id';
  static const cardOwnerName = 'card_owner_name';

  // CARDTABLE name and column names
  static const CARDTABLE = 'card_table';

  static const cardId = 'card_id';
  static const cardCompanyName = 'card_company_name';
  static const cardBankName = 'card_bank_name';
  static const cardType = 'card_type';
  static const cardNumber = 'card_number';
  static const cardExpiryDate = 'card_expiry_date';
  static const cardCvv = 'card_cvv';
  static const cardGenerateDate = 'card_generate_date';
  static const cardPaymentDate = 'card_payment_date';
  static const cardHolderName = 'card_holder_name';
  static const cardLimit = 'card_limit';

  // CardExpenseTable name and column names
  static const EXPENSE_TABLE = 'expense_table';
  static const expenseID = 'expense_id';
  static const expensePaymentType =
      'expense_payment_type'; //like gpay or phone pay online etc
  static const expenseTransactionID = 'expense_transaction_id';
  static const expenseAmount = 'expense_amount';
  static const expenseDate = 'expense_date'; // date of transaction
  static const expenseDescription = 'expense_description';

  // make this a singleton class
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $CARD_OWNER_TABLE (
            $cardOwnerId INTEGER PRIMARY KEY AUTOINCREMENT,
            $cardOwnerName TEXT
          )
          ''');
    await db.execute('''
          CREATE TABLE $CARDTABLE (
            $cardId INTEGER PRIMARY KEY AUTOINCREMENT,
            $cardOwnerId INTEGER NOT NULL,
            $cardBankName TEXT,
            $cardCompanyName TEXT,
            $cardHolderName TEXT,
            $cardNumber TEXT,
            $cardExpiryDate TEXT,
            $cardGenerateDate TEXT,
            $cardCvv TEXT,
            $cardType TEXT,
            $cardLimit REAL,
            $cardPaymentDate TEXT
          )
          ''');
    await db.execute('''
          CREATE TABLE $EXPENSE_TABLE (
            $expenseID INTEGER PRIMARY KEY AUTOINCREMENT,
            $cardId INTEGER,
            $cardOwnerId INTEGER,
            $expenseAmount TEXT,
            $expensePaymentType TEXT,
            $expenseTransactionID REAL,
            $expenseDate TEXT,
            $expenseDescription TEXT
          )
          ''');
  }

  // all ownersTable operations methods
  Future addCardOwners(String name) async {
    Database db = await instance.database;
    var data = await db.insert(CARD_OWNER_TABLE, {cardOwnerName: name});
    GlobalMethods.printLog(data.toString());
    return data;
  }

  Future<List<CardOwnerModel>> getAllCardOwners() async {
    Database db = await instance.database;
    final allRows = await db.query(CARD_OWNER_TABLE);
    print(allRows.toSet().toString());
    List<CardOwnerModel> list = [];
    allRows.forEach((row) => list.add(CardOwnerModel.fromMap(row)));
    return list;
  }

  Future<int> deleteCardOwnerId(int id) async {
    Database db = await instance.database;
    return await db
        .delete(CARD_OWNER_TABLE, where: '$cardOwnerId = ?', whereArgs: [id]);
  }

  // all cardtable operation methods
  Future<int> addCard(CardModel data) async {
    Database db = await instance.database;
    Map map = data.toMap();
    map.remove(cardId);
    return await db.insert(CARDTABLE, map as Map<String, Object?>);
  }

  Future<List<CardModel>> getAllCardByOwnerId(int id) async {
    Database db = await instance.database;
    final allRows =
        await db.query(CARDTABLE, where: "$cardOwnerId = ?", whereArgs: [id]);

    List<CardModel> list = [];
    allRows.forEach((row) => list.add(CardModel.fromMap(row)));
    return list;
  }

  Future<int> editCard(CardModel data) async {
    Database db = await instance.database;
    return await db.update(CARDTABLE, data.toMap(),
        where: '$cardId = ?', whereArgs: [data.cardId]);
  }

  Future<int> deleteCardById(int id) async {
    Database db = await instance.database;
    return await db.delete(CARDTABLE, where: '$cardId = ?', whereArgs: [id]);
  }

  // all expanseTable operation methods
  /* Future<int> addProduct(model) async {
    Database db = await instance.database;
    return await db.insert(productTable, {
      productName: model.name,
      productCatId: model.catId,
      productCatName: model.catName,
      productCmpName: model.comName,
      productCmpId: model.comId,
      productDes: model.des,
      productQnt: model.qty,
      productPrice: model.price,
      productImage_1: model.image1,
      productImage_2: model.image2,
      productImage_3: model.image3,
      productImage_4: model.image4,
    });
  }*/

  Future<int> addExpense(ExpenseModel data) async {
    Database db = await instance.database;
    Map map = data.toMap();
    map.remove(expenseID);
    return await db.insert(EXPENSE_TABLE, map as Map<String, Object?>);
  }

  Future<List<ExpenseModel>> getAllExpense() async {
    Database db = await instance.database;
    final allRows = await db.query(EXPENSE_TABLE);
    List<ExpenseModel> list = [];
    allRows.forEach((row) => list.add(ExpenseModel.fromMap(row)));
    return list;
  }

  Future<int> deleteExpense(int id) async {
    Database db = await instance.database;
    return await db
        .delete(EXPENSE_TABLE, where: '$expenseID = ?', whereArgs: [id]);
  }

  Future<int> editExpense(ExpenseModel data) async {
    Database db = await instance.database;
    return await db.update(EXPENSE_TABLE, data.toMap(),
        where: '$expenseID = ?', whereArgs: [data.expenseID]);
  }
}
