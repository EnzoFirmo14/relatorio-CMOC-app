# Lista de Tarefas: Mecanismo de Atualização Automática

- [x] **Configurações e Dependências**
  - [x] Adicionar dependências no `pubspec.yaml` (`package_info_plus`, `crypto`)
  - [x] Configurar permissões e FileProvider no `AndroidManifest.xml`
  - [x] Criar `file_paths.xml` com caminhos compartilháveis

- [x] **Implementação Nativa Android**
  - [x] Implementar MethodChannel no `MainActivity.kt` (permissões e gatilho de instalação)

- [x] **Lógica de Negócios (Flutter)**
  - [x] Criar serviço `AppUpdateService` (Firestore fetch, download via HTTP stream, validação SHA-256, canal nativo)
  - [x] Criar gerenciador de estado `AppUpdateController` (Riverpod)

- [x] **Apresentação e UI (Flutter)**
  - [x] Criar widget dialog `AppUpdateDialog` (Identidade Visual CMOC, progresso do download, validação, botão de instalação)
  - [x] Integrar verificação de versão automática na inicialização do `ReportFormPage`

- [x] **Validação e Testes**
  - [x] Adicionar testes unitários ou simulação local de atualização
  - [x] Validar fluxo completo
