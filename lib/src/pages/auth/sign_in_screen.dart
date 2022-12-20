import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greengrocer/src/config/custom_colors.dart';
import 'package:greengrocer/src/pages/common_widgets/app_name_widget.dart';
import 'package:greengrocer/src/pages/common_widgets/custom_text_field.dart';
import 'package:greengrocer/src/pages/auth/sign_up_screen.dart';
import 'package:greengrocer/src/pages/base/base_screen.dart';
import 'package:greengrocer/src/pages_routes/app_pages.dart';
import 'package:dio/dio.dart';

import 'controller/auth_controller.dart';

class Teste extends GetxController {
  RxString texto = "".obs;
}

class SignInScreen extends StatelessWidget {
  SignInScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final Teste teste = Teste();

    return Scaffold(
      backgroundColor: CustomColors.customSwatchColor,
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height,
          width: size.width,
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Nome do app
                    const AppNameWidget(
                      greenTitleColor: Colors.white,
                      textSize: 40,
                    ),

                    // Categorias
                    SizedBox(
                      height: 30,
                      child: DefaultTextStyle(
                        style: const TextStyle(
                          fontSize: 25,
                        ),
                        child: AnimatedTextKit(
                          pause: Duration.zero,
                          repeatForever: true,
                          animatedTexts: [
                            FadeAnimatedText('Frutas'),
                            FadeAnimatedText('Verduras'),
                            FadeAnimatedText('Legumes'),
                            FadeAnimatedText('Carnes'),
                            FadeAnimatedText('Cereais'),
                            FadeAnimatedText('Laticíneos'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Formulário
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 40,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(45),
                  ),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Email
                      CustomTextField(
                        controller: emailController,
                        icon: Icons.email,
                        label: 'Email',
                        validator: (email) {
                          if (email == null || email.isEmpty)
                            return "Digite seu email!";

                          if (!email.isEmail) return "Digite um email válido!";

                          return null;
                        },
                      ),

                      // Senha
                      CustomTextField(
                        controller: passwordController,
                        icon: Icons.lock,
                        label: 'Senha',
                        isSecret: true,
                        validator: (password) {
                          if (password == null || password.isEmpty)
                            return "Digite sua senha!";

                          if (password.length < 7)
                            return "Digite uma senha com no mínimo 7 caracteres.";

                          return null;
                        },
                      ),

                      // Botão de entrar
                      SizedBox(
                        height: 50,
                        child: GetX<AuthController>(
                          builder: (_) {
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              onPressed: _.isLoading.value
                                  ? null
                                  : () {
                                      /* Navigator.of(context)
                                                        .pushReplacement(MaterialPageRoute(builder: (c) {
                                                      return BaseScreen();
                                                    })); */
                                      FocusScope.of(context)
                                          .unfocus(); // Tira o teclado ao apertar em entrar.

                                      if (_formKey.currentState!.validate()) {
                                        print("Todos os campos estão válidos");

                                        print(
                                            "Email: ${emailController.text}\nSenha: ${passwordController.text}");

                                        _.signIn(
                                            email: emailController.text,
                                            password: passwordController.text);
                                        // Get.offNamed(PagesRoutes.baseRoute);
                                      } else {
                                        print("O inferno é aqui");
                                      }
                                    },
                              child: _.isLoading.value
                                  ? const CircularProgressIndicator()
                                  : const Text(
                                      'Entrar',
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                            );
                          },
                        ),
                      ),

                      // Esqueceu a senha
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () async {
                            try {

                              // Requisição GET

                              /* var response = await Dio().get(
                                  "https://jsonplaceholder.typicode.com/posts/11");
                              print(response.data);
                              teste.texto.value = response.data.toString(); */

                              // Requisição POST

                              /* var response = await Dio().post(
                                  "https://jsonplaceholder.typicode.com/posts/",
                                  data: {
                                    "I tried so hard": "And get so far",
                                    "but in the end": "it doenst even matter"
                                  });
                              print(response.data); */


                            } on DioError catch (e) {
                              // print("erro generio: ${e}");
                              print("Error statusCode: ${e.response?.statusCode}");
                            }
                          },
                          child: Text(
                            'Esqueceu a senha?',
                            style: TextStyle(
                              color: CustomColors.customContrastColor,
                            ),
                          ),
                        ),
                      ),

                      // Divisor
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: Colors.grey.withAlpha(90),
                                thickness: 2,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Text('Ou'),
                            ),
                            Expanded(
                              child: Divider(
                                color: Colors.grey.withAlpha(90),
                                thickness: 2,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Botão de novo usuário
                      SizedBox(
                        height: 50,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            side: const BorderSide(
                              width: 2,
                              color: Colors.green,
                            ),
                          ),
                          onPressed: () {
                            /* Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (c) {
                                  return SignUpScreen();
                                },
                              ),
                            ); */
                            Get.toNamed(PagesRoutes.signUpRoute);
                          },
                          child: const Text(
                            'Criar conta',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      // Obx(() => Text("OS dados jotason: ${teste.texto}"))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
