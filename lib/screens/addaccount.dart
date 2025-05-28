import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:passwords/screens/accounttype.dart';

class AddPasswordScreen extends StatefulWidget {
  const AddPasswordScreen({super.key});

  @override
  State<AddPasswordScreen> createState() => _AddPasswordScreenState();
}

class _AddPasswordScreenState extends State<AddPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController websiteController = TextEditingController();
  final TextEditingController accountTypeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  bool isLoading = false;

  final secretKey = encrypt.Key.fromUtf8('my32lengthsupersecretnooneknows1');
  final iv = encrypt.IV.fromLength(16);

  String encryptPassword(String password) {
    final encrypter = encrypt.Encrypter(encrypt.AES(secretKey));
    final encrypted = encrypter.encrypt(password, iv: iv);
    return encrypted.base64;
  }

  Future<void> _savePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final encryptedPassword = encryptPassword(passwordController.text);
    final userId = Supabase.instance.client.auth.currentUser?.id;

    try {
      await Supabase.instance.client.from('accounts').insert({
        'user_id': userId,
        'website': websiteController.text.trim(),
        'service': accountTypeController.text.trim(),
        'email': emailController.text.trim(),
        'password': encryptedPassword,
        'username': usernameController.text.trim(),
        'notes': notesController.text.trim(),
      });

      if (context.mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al guardar: $e')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Account')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: websiteController,
                decoration: const InputDecoration(labelText: 'Website'),
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Text(
                      'Account',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      final selected = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SelectAccountTypeScreen(),
                        ),
                      );
                      if (selected != null) {
                        accountTypeController.text = selected.toString();
                        setState(() {});
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        accountTypeController.text.isEmpty
                            ? 'Seleccionar tipo de cuenta'
                            : accountTypeController.text,
                        style: TextStyle(
                          fontSize: 16,
                          color:
                              accountTypeController.text.isEmpty
                                  ? Colors.grey
                                  : Colors.white,
                        ),
                      ),
                    ),
                  ),
                  if (accountTypeController.text.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text(
                        'Selecciona un tipo de cuenta',
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                  const SizedBox(height: 12),
                ],
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              TextFormField(
                controller: notesController,
                decoration: const InputDecoration(labelText: 'Notes'),
                maxLines: 4,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : _savePassword,
                child:
                    isLoading
                        ? const CircularProgressIndicator()
                        : const Text('SAVE'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
