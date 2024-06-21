import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:highty_inventory/domain/usecases/auth.dart';
import 'package:highty_inventory/presentation/bloc/login_bloc.dart';
import 'package:highty_inventory/presentation/constants/colors.dart';
import 'package:highty_inventory/presentation/constants/fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:highty_inventory/data/repositories/auth_repository_impl.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
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
            const SizedBox(height: 40,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: BlocProvider(
                create: (context) {
                  final supabase = Supabase.instance.client;
                  final authRepository = AuthRepositoryImpl(supabase);
                  final signInUseCase = SignInUseCase(authRepository);
                  return LoginCubit(signInUseCase);
                },
                child: LoginForm(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscureText = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
      },
      builder: (context, state) {
        return Column(
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
            const SizedBox(height: 16.0,),
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
                ),
              ),
              obscureText: _obscureText,
            ),
            const SizedBox(height: 28,),
            state.isLoading
            ? const CircularProgressIndicator()
            : SizedBox(
                height: 48,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<LoginCubit>().signIn(context, emailController.text, passwordController.text);
                  },
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
        );
      },
    );
  }
}
