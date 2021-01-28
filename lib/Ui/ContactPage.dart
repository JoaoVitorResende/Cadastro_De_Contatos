import 'dart:io';

import 'package:agenda_de_contatos/helpers/contact_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {
  final Contact contact;

  // {} para deixar opicional
  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  Contact _edited_contact;
  bool _user_edited = false;

  final _name_controller = TextEditingController();
  final _email_controller = TextEditingController();
  final _phone_controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.contact == null) {
      _edited_contact = Contact();
    } else {
      _edited_contact = Contact.formMap(widget.contact.toMap());
      _name_controller.text = _edited_contact.name;
      _email_controller.text = _edited_contact.email;
      _phone_controller.text = _edited_contact.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text(_edited_contact.name ?? "novo contato"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(
          Icons.save,
          color: Colors.redAccent,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            GestureDetector(
              child: Container(
                width: 140.0,
                height: 140.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: _edited_contact.img != null
                            ? FileImage(File(_edited_contact.img))
                            : AssetImage("imagens/person-male.png"))),
              ),
            ),
            TextField(
              controller: _name_controller,
              decoration: InputDecoration(labelText: "Nome"),
              onChanged: (text) {
                _user_edited = true;
                setState(() {
                  _edited_contact.name = text;
                });
              },
            ),
            TextField(
              controller: _email_controller,
              decoration: InputDecoration(labelText: "Email"),
              onChanged: (text) {
                _user_edited = true;
                _edited_contact.email = text;
              },
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _phone_controller,
              decoration: InputDecoration(labelText: "Phone"),
              onChanged: (text) {
                _user_edited = true;
                _edited_contact.phone = text;
              },
              keyboardType: TextInputType.phone,
            )
          ],
        ),
      ),
    );
  }
}
