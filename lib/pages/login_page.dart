import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:fit_tracker_pro_app/pages/main_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _authService = AuthService();

  bool _isLoading = false;


  Future<void> _handleLogin() async {
    // 6. Valida se os campos estão preenchidos
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // 7. Chama o AuthService
      bool loginSuccess = await _authService.login(
        _emailController.text,
        _passwordController.text,
      );

      // Não precisamos mais do setState aqui, pois vamos sair da tela
      // setState(() { _isLoading = false; }); // Esta linha pode ser removida

      // 8. Feedback e Navegação (A MUDANÇA ESTÁ AQUI)
      if (loginSuccess) {
        // SUCESSO!
        // Navega para a MainPage e REMOVE a LoginPage da pilha
        // Isso impede o usuário de apertar "Voltar" e retornar ao Login
        if (mounted) { // Verifica se o widget ainda está na tela
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const MainPage(),
            ),
          );
        }
      } else {
        // FALHA! (Mostra a SnackBar de erro)
        // Precisamos garantir que _isLoading seja definido como false aqui
        setState(() {
          _isLoading = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Falha no login. Verifique suas credenciais.')),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    // 9. Limpa os controladores quando a tela é destruída
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 10. Scaffold é a estrutura básica da tela (fundo, appbar, etc.)
    return Scaffold(
      // Define a cor de fundo para combinar com o Figma (tema escuro)
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView( // Permite rolar a tela se o teclado cobrir
            padding: const EdgeInsets.all(24.0),
            child: Form( // 11. O widget Form usa a _formKey para validação
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 12. Título (Baseado no Figma)
                  Text(
                    'Washers', // TODO: Mudar para FIT TRACKER PRO
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.blue[400],
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Entre com sua conta',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // 13. Campo de E-mail (Baseado no Figma)
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'E-mail',
                      labelStyle: TextStyle(color: Colors.white70),
                      prefixIcon: Icon(Icons.email, color: Colors.white70),
                      filled: true,
                      fillColor: Colors.grey[800],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                    validator: (value) { // Validação simples
                      if (value == null || value.isEmpty || !value.contains('@')) {
                        return 'Por favor, insira um e-mail válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // 14. Campo de Senha (Baseado no Figma)
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true, // Esconde a senha
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      labelStyle: TextStyle(color: Colors.white70),
                      prefixIcon: Icon(Icons.lock, color: Colors.white70),
                      suffixIcon: Icon(Icons.visibility_off, color: Colors.white70), // Ícone do olho
                      filled: true,
                      fillColor: Colors.grey[800],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                    validator: (value) { // Validação simples
                      if (value == null || value.isEmpty || value.length < 6) {
                        return 'A senha deve ter pelo menos 6 caracteres';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),

                  // 15. Botão ENTRAR (Baseado no Figma)
                  _isLoading // Se estiver carregando, mostra um indicador
                      ? Center(child: CircularProgressIndicator())
                      : ElevatedButton( // Se não, mostra o botão
                    onPressed: _handleLogin, // Chama nossa função de login
                    child: Text('ENTRAR'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[600],
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),

                  // TODO: Adicionar "Esqueci minha senha" e "Registre-se"
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}