import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String contact_table = "contact table";
final String id_column = "id column";
final String name_column = "name column";
final String email_column = "email column";
final String phone_column = "phone column";
final String img_column = "img column";

class ContactHelper {
  // dessa forma só cria um unico objeto mantendo o código sempre na mesma
  // posição de memoria
  static final ContactHelper _instance = ContactHelper.internal();

  factory ContactHelper() => _instance;

  ContactHelper.internal(); //construtor
  //------------------------------------------------
  Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await InitDb();
      return _db;
    }
  }

  Future<Database> InitDb() async {
    // pega o local do db
    // await necessário pois não é instantanio
    final database_path = await getDatabasesPath();
    final path = join(database_path, "contactsnew.db");
    // abrindo o banco de dados
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newversion) async {
      // criando coluna do banco para os itens serem armazenados
      await db.execute(
          "CREATE TABLE $contact_table($id_column INTEGER PRIMARY KEY,$name_column TEXT,$email_column TEXT,"
          "$phone_column TEXT,$img_column TEXT)");
    });
  }

  Future<Contact> SaveContact(Contact contact) async {
    // salva os contatos no banco
    Database dbcontact = await db;
    // para que insira corretamente é necessário transformar o contato em mapa
    contact.id = await dbcontact.insert(contact_table, contact.toMap());
    return contact;
  }

  // pega o contato que quer pelo id no banco
  // tem a função de comparar e devolver os itens do banco
  Future<Contact> GetContact(int id) async {
    Database dbcontact = await db;
    // query busca somente os dados que você quer
    List<Map> maps = await dbcontact.query(contact_table,
        columns: [name_column, email_column, phone_column, img_column],
        where: "$id_column = ?",
        whereArgs: [id]);

    if (maps.length > 0) {
      // pega o primeiro mapa
      return Contact.formMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> DeletContact(int id) async {
    Database dbcontact = await db;
    return await dbcontact
        .delete(contact_table, where: "$id_column = ?", whereArgs: [id]);
  }

  Future<int> UpdateContact(Contact contact) async {
    Database dbcontact = await db;
    return await dbcontact.delete(contact_table,
        where: "$id_column = ?", whereArgs: [contact.id]);
  }

  Future<List> GetAllContacts() async {
    //pegar todos os itens do banco
    Database dbcontact = await db;
    List list_map = await dbcontact.rawQuery("SELECT * FROM $contact_table");
    List contacts_list = List();
    // transformar maps em contatos armazenando todos em uma lista de
    //classe de contatos

    for (Map m in list_map) {
      contacts_list.add(Contact.formMap(m));
    }

    return contacts_list;
  }

  Future<int> GetNumber() async {
    Database dbcontact = await db;
    return Sqflite.firstIntValue(
        await dbcontact.rawQuery("SELECT COUNT (*) FROM $contact_table"));
  }

  Future CloseDataBase() async {
    Database dbcontact = await db;
    dbcontact.close();
  }
}

// id name email phone img

class Contact {
  String name, email, phone, img;

  int id;

  Contact();

  Contact.formMap(Map map) {
    id = map[id_column];
    name = map[name_column];
    email = map[email_column];
    phone = map[phone_column];
    img = map[img_column];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      name_column: name,
      email_column: email,
      phone_column: phone,
      img_column: img,
    };

    if (id != null) {
      map[id_column] = id;
    }

    return map;
  }

  @override
  String toString() {
    return "Contato "
        "id : $id"
        "name : $name"
        "email : $email"
        "phone : $phone"
        "img : $img";
  }
}
