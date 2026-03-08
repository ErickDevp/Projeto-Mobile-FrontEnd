<div align="center">

<h1>💪 FitTracker Pro — App Mobile</h1>

<p>Aplicativo mobile para gerenciamento de treinos e rotinas, desenvolvido com <strong>Flutter + Dart</strong>.</p>

<p>
  <img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white" />
  <img src="https://img.shields.io/badge/Dart-3.9-0175C2?style=for-the-badge&logo=dart&logoColor=white" />
  <img src="https://img.shields.io/badge/Android-Suportado-3DDC84?style=for-the-badge&logo=android&logoColor=white" />
  <img src="https://img.shields.io/badge/JWT-Autenticação-000000?style=for-the-badge&logo=jsonwebtokens&logoColor=white" />
</p>

<p>
  <a href="https://github.com/ErickDevp/Projeto-Mobile-Backend">⚙️ Repositório Back-end (Spring Boot)</a>
</p>

</div>

---

## 📋 Sobre o Projeto

O **FitTracker Pro** é um aplicativo mobile fullstack voltado para o acompanhamento de atividades físicas. Com ele, o usuário pode criar treinos personalizados, montar rotinas semanais, explorar templates prontos e acompanhar sua evolução diretamente pelo celular.

Este repositório contém o **app Flutter** que consome a API REST do back-end.

---

## 📱 Telas do Aplicativo

| Tela | Descrição |
|---|---|
| **Login** | Autenticação com e-mail e senha |
| **Cadastro** | Registro de nova conta com login automático |
| **Recuperar Senha** | Solicitação de reset por e-mail |
| **Home (Treino)** | Hub central com acesso às principais ações |
| **Perfil** | Foto, dados do usuário e histórico |
| **Editar Perfil** | Atualização de nome, dados e foto de perfil |
| **Meus Treinos** | Lista de treinos cadastrados pelo usuário |
| **Ver Treino** | Detalhes e exercícios de um treino específico |
| **Registrar Treino** | Criação de novo treino |
| **Registrar Detalhes** | Adição de detalhes e configurações do treino |
| **Adicionar Exercícios** | Adição de exercícios a um treino |
| **Editar Treino** | Edição de treino existente |
| **Minhas Rotinas** | Rotinas semanais do usuário |
| **Criar Rotina** | Criação de nova rotina com dias da semana |
| **Adicionar Exercício à Rotina** | Associação de exercícios a dias da rotina |
| **Explorar Rotinas** | Templates de rotinas pré-definidos para usar |

---

## 🚀 Funcionalidades

- 🔐 **Autenticação** com JWT armazenado via `flutter_secure_storage`
- 👤 **Perfil do usuário** com upload de foto via câmera ou galeria
- 🏋️ **CRUD completo de treinos** com exercícios personalizados
- 📅 **Rotinas semanais** — distribua treinos por dia da semana
- 📋 **Explorar templates** de rotinas prontas para clonar
- 🌙 **Tema escuro** por padrão, seguindo o design do Figma
- 📡 **Integração HTTP** com a API Spring Boot via pacote `http`

---

## 🛠️ Tecnologias e Pacotes

| Pacote | Versão | Uso |
|---|---|---|
| `flutter` | SDK | Framework principal |
| `dart` | ^3.9.2 | Linguagem |
| `http` | ^1.2.1 | Requisições à API REST |
| `flutter_secure_storage` | ^9.2.2 | Armazenamento seguro do JWT |
| `image_picker` | ^1.0.7 | Upload de foto de perfil |
| `shared_preferences` | ^2.5.4 | Preferências locais do usuário |
| `cupertino_icons` | ^1.0.8 | Ícones no estilo iOS |

---

## 📁 Estrutura do Projeto

```
lib/
├── main.dart                        # Ponto de entrada do app e tema global
├── dto/                             # Modelos de dados (espelham o backend)
│   ├── exercicio_request_dto.dart
│   ├── exercicio_response_dto.dart
│   ├── treino_request_dto.dart
│   ├── treino_response_dto.dart
│   ├── usuario_request_dto.dart
│   ├── usuario_response_dto.dart
│   ├── rotina/
│   │   ├── request/                 # DTOs de envio (rotina, treino, dia, exercício)
│   │   └── response/                # DTOs de resposta
│   └── rotinaTemplate/
│       └── response/                # DTO de template de rotina
├── pages/                           # Telas do aplicativo
│   ├── login_page.dart
│   ├── register_page.dart
│   ├── forgot_password_page.dart
│   ├── main_page.dart               # Navegação principal (BottomNavigationBar)
│   ├── home_content.dart            # Aba de Treino
│   ├── perfil_page.dart             # Aba de Perfil
│   ├── editar_perfil_page.dart
│   ├── treino_page.dart
│   ├── ver_treino_page.dart
│   ├── registrar_treino_page.dart
│   ├── registrar_detalhes_treino_page.dart
│   ├── adicionar_exercicios_page.dart
│   ├── editar_treino_page.dart
│   ├── minhas_rotinas_page.dart
│   ├── criar_rotina_screen.dart
│   ├── adicionar_exercicio_rotina.dart
│   └── explorar_rotinas_page.dart
└── services/                        # Comunicação com a API REST
    ├── auth_service.dart            # Login, registro, logout, recuperar senha
    ├── usuario_service.dart         # Perfil e foto
    ├── treino_service.dart          # CRUD de treinos e exercícios
    ├── rotina_service.dart          # CRUD de rotinas e dias
    └── rotina_template_service.dart # Listagem de templates
```

---

## ⚙️ Pré-requisitos

- [Flutter SDK 3.x+](https://docs.flutter.dev/get-started/install)
- [Dart 3.9+](https://dart.dev/get-dart)
- Android Studio ou VS Code com extensão Flutter
- Emulador Android ou dispositivo físico
- Back-end rodando localmente ou em rede acessível

---

## 🔧 Configuração e Execução

### 1. Clone o repositório

```bash
git clone https://github.com/ErickDevp/Projeto-Mobile-FrontEnd.git
cd Projeto-Mobile-FrontEnd
```

### 2. Instale as dependências

```bash
flutter pub get
```

### 3. Configure a URL do back-end

Em cada arquivo de serviço em `lib/services/`, atualize a variável `_baseUrl` com o IP da máquina onde o back-end está rodando:

```dart
// Exemplo em auth_service.dart
final String _baseUrl = "http://SEU_IP_LOCAL:8080";
```

> 💡 Use o IP da sua rede local (ex: `192.168.x.x`) ao testar em dispositivo físico. Para emulador Android, use `http://10.0.2.2:8080`.

### 4. Execute o app

```bash
flutter run
```

---

## 🏗️ Build para Android

```bash
flutter build apk --release
```

O APK gerado estará em `build/app/outputs/flutter-apk/app-release.apk`.

---

## 🧭 Navegação do App

O app utiliza `BottomNavigationBar` com duas abas principais:

```
📱 MainPage
├── 👤 Perfil   → PerfilPage (histórico, dados do usuário)
└── 🏋️ Treino  → HomeContent (ações: treinar, rotinas, explorar)
```

A navegação entre telas secundárias é feita via `Navigator.push`.

---

## 🔗 Repositório Relacionado

| Projeto | Tecnologia | Link |
|---|---|---|
| ⚙️ Back-end | Java + Spring Boot | [Projeto-Mobile-Backend](https://github.com/ErickDevp/Projeto-Mobile-Backend) |

---

## 🧪 Testes

```bash
flutter test
```

---

## 🎓 Sobre

Projeto desenvolvido para a disciplina de **Projeto Mobile**, com foco em desenvolvimento de apps nativos multiplataforma utilizando Flutter, integração com APIs REST e boas práticas de arquitetura com separação entre DTOs, Services e Pages.

---

<div align="center">
  Feito com 💙 Flutter e ☕ Java Spring Boot
</div>
