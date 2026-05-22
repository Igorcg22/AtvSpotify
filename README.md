
lib/
├── core/            # Configurações globais (Tema, Clientes de Rede, Banco Local)
├── domain/          # Lógica de Negócios pura (Entidades, Interfaces de Repositório)
├── data/            # Implementação de Dados (Modelos de parse, Repositórios concretos)
└── presentation/    # Camada de Interface (Telas, Stores do MobX, Widgets reutilizáveis)


Clonar:
git clone https://github.com/seu-usuario/spotfy_copy.git
cd spotfy_copy

Dependências:
flutter pub get

Gerador de Código:
flutter pub run build_runner build --delete-conflicting-outputs

Iniciar:
flutter run
(Opção 2)