import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:highty_inventory/presentation/constants/colors.dart';
import 'package:highty_inventory/presentation/constants/fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final SupabaseClient supabase = Supabase.instance.client;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    final sm = ScaffoldMessenger.of(context);
    setState(() {
      isLoading = true;
    });

    try {
      final authResponse = await Supabase.instance.client.auth.signInWithPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      if (authResponse.session != null) {
        Navigator.popAndPushNamed(context, '/homescreen');
      } else {
        sm.showSnackBar(SnackBar(content: Text("Login failed. Please try again.")));
      }
    } catch (e) {
      sm.showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
  
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              //padding: const EdgeInsets.all(40),
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: const BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0)
                )
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 160,),
                  Image.asset(
                    'assets/highty_logo.png',
                    width: 200,
                  ),
                ],
              ),
            ),
            SizedBox(height: 40,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  TextField(
                    controller: emailController,
                    style: primary,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                      labelStyle: primaryGrey,
                      floatingLabelStyle: primary,
                      focusColor: kPrimaryColor,
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: kPrimaryColor, width: 2.0)
                      ),
                      
                    ),                   
                  ),
                  SizedBox(height: 16.0,),
                  TextField(
                    controller: passwordController,
                    style: primary,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      labelStyle: primaryGrey,
                      floatingLabelStyle: primary,
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: kPrimaryColor, width: 2.0)
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText ? Icons.visibility : Icons.visibility_off
                        ),
                        onPressed: (){
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      )
                    ),
                    obscureText: _obscureText,
                  ),
                  const SizedBox(height: 28,),
                  isLoading 
                  ? CircularProgressIndicator()
                  : SizedBox(
                      height: 48,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)
                          )
                        ),
                        child: Text(
                          'Login',
                          style: primaryWhite,
                        )
                      )
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  
}