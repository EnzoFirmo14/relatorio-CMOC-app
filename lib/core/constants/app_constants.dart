class AppConstants {
  AppConstants._();

  static const List<String> matOptions = [
    'Duto de 800',
    'Duto de 1000',
    'Duto de 1200',
    'Duto Y',
    'Tubo de 63',
    'Tubo de 110',
    'Tubo de 180',
    'Abraçadeira de 63',
    'Abraçadeira de 110',
    'Abraçadeira de 160',
    'Abraçadeira de 180',
    'Abraçadeira Comum',
    'Corrente',
    'Suporte',
    'Cortina',
    'Cabo de Aço',
    'Ponteira',
    'Carretel Tubulação 63',
    'Carretel Tubulação 110',
    'Carretel Tubulação 180'
  ];

  static const List<String> manutOptions = [
    'Avanço',
    'Corretiva',
    'Recuo',
    'Transporte',
    'Apoio'
  ];

  static const Map<String, List<String>> causaMap = {
    'Avanço': [
      'Avanço de Ventilação',
      'Avanço de Tubulação'
    ],
    'Corretiva': [
      'Tubo Danificado',
      'Tubo Arriado',
      'Tubo Desacoplado',
      'Duto Acidentado',
      'Duto Arriado',
      'Duto Desacoplado',
      'Ventilação Ineficiente'
    ],
    'Recuo': [
      'Recuar Tubulação',
      'Recuar Ventilação'
    ],
    'Apoio': [
      'Apoio a Elétrica'
    ],
    'Transporte': [
      'Transporte'
    ]
  };

  static const List<String> statusOptions = [
    'Liberado',
    'Corrigido',
    'Em Andamento'
  ];

  static const List<String> equipOptions = [
    'PT302',
    'PT305',
    'PT306',
    'MT001',
    'MT002',
    'N/A'
  ];

  static const List<String> shiftOptions = ['T1', 'T2', 'T3'];
  static const List<String> teamOptions = ['A', 'B', 'C', 'D'];

  static const List<Map<String, String>> colaboradoresIniciais = [
    {'mat': '4786', 'nome': 'Acacio Oliveira Souza'},
    {'mat': '99300599', 'nome': 'Adailton Silva Santos'},
    {'mat': '99300182', 'nome': 'Adonis Evaristo Sousa dos Santos'},
    {'mat': '5115', 'nome': 'Adriano Silva de Matos'},
    {'mat': '99300217', 'nome': 'Adriano da Fonseca Santana'},
    {'mat': '70205994', 'nome': 'Aleandro Bonifacio dos Santos'},
    {'mat': '99300607', 'nome': 'Altair da Silva Almeida'},
    {'mat': '99300855', 'nome': 'Anderson Andrey Gomes'},
    {'mat': '99300603', 'nome': 'Andeson de Jesus Santos'},
    {'mat': '99300868', 'nome': 'Carlos Daniel De Queiroz Firmo'},
    {'mat': '5252', 'nome': 'Celio Marinho Carvalho Junior'},
    {'mat': '99300906', 'nome': 'Claudemiro Gordiano Cunha'},
    {'mat': '99300377', 'nome': 'Claudio Augusto do Prado de Oliveira'},
    {'mat': '5237', 'nome': 'Clebson Oliveira Moura'},
    {'mat': '5257', 'nome': 'Cleilson Araujo de Jesus'},
    {'mat': '99300193', 'nome': 'Cleinilson da Mota Firmo'},
    {'mat': '4895', 'nome': 'Cristiano Rodrigues Dias de Jesus'},
    {'mat': '99300582', 'nome': 'Danilo Pereira da Silva'},
    {'mat': '99300595', 'nome': 'Deyferson de Queiroz Firmo'},
    {'mat': '99300164', 'nome': 'Dimelson Souza da Silva'},
    {'mat': '99300538', 'nome': 'Edimari Barreto da Cruz'},
    {'mat': '70205582', 'nome': 'Edmundo Santos de Jesus'},
    {'mat': '4753', 'nome': 'Emanuelle Santos Silva'},
    {'mat': '99300606', 'nome': 'Emilio Manaia Lima'},
    {'mat': '99300432', 'nome': 'Erick de Araujo Pimentel'},
    {'mat': '99300346', 'nome': 'Erique de Matos Santos'},
    {'mat': '99300635', 'nome': 'Fabricio de Carvalho Santos'},
    {'mat': '991000100', 'nome': 'Fagner de Queiroz Mendonca'},
    {'mat': '99300144', 'nome': 'Felipe Matos Santos'},
    {'mat': '991000150', 'nome': 'Felipe Souza Barbosa'},
    {'mat': '99300389', 'nome': 'Fernando Juriti Reis'},
    {'mat': '70205583', 'nome': 'Fernando de Jesus Santos'},
    {'mat': '99300203', 'nome': 'Francisco Elexsandro da Silva'},
    {'mat': '99300268', 'nome': 'Francisco Fagne Oliveira Silva'},
    {'mat': '99300456', 'nome': 'Gabriel Alves Queiroz Lopes'},
    {'mat': '4929', 'nome': 'Genesio Muniz dos Santos'},
    {'mat': '99300447', 'nome': 'Genilson Ribeiro dos Santos'},
    {'mat': '5255', 'nome': 'Geovane Bispo dos Santos'},
    {'mat': '4774', 'nome': 'Geovane Oliveira Araujo'},
    {'mat': '99300532', 'nome': 'Gildenor Lopes de Oliveira'},
    {'mat': '99300535', 'nome': 'Gilmar Nascimento Moreira'},
    {'mat': '99300575', 'nome': 'Gilmar Olivera de Jesus'},
    {'mat': '99300383', 'nome': 'Gilvandro Damiao de Jesus'},
    {'mat': '4788', 'nome': 'Girlan Queiroz dos Santos'},
    {'mat': '99300433', 'nome': 'Gustavo Oliveira Santana'},
    {'mat': '99300598', 'nome': 'Gutierry Santos Matos'},
    {'mat': '99300491', 'nome': 'Hamilton Araujo dos Santos'},
    {'mat': '4825', 'nome': 'Hitalo Dantas Queiroz'},
    {'mat': '5178', 'nome': 'Isac Valerio dos Santos'},
    {'mat': '5353', 'nome': 'Italo da Costa Dutra'},
    {'mat': '99300305', 'nome': 'Itamar da Silva Lima'},
    {'mat': '5247', 'nome': 'Ivanilson de Jesus Santos'},
    {'mat': '4775', 'nome': 'Jackson de Jesus Silva'},
    {'mat': '5254', 'nome': 'Jailton Oliveira dos Santos'},
    {'mat': '99300149', 'nome': 'Jenivaldo Silva dos Santos'},
    {'mat': '5256', 'nome': 'Joanderson Silva Gonçalves'},
    {'mat': '99300472', 'nome': 'Joelson Pereira da Silva'},
    {'mat': '99300619', 'nome': 'Jonathan Gordiano Rodrigues'},
    {'mat': '70205586', 'nome': 'Jose Milton Bispo dos Santos'},
    {'mat': '99300378', 'nome': 'Jose Nacirso Ferreira de Queiroz'},
    {'mat': '99300239', 'nome': 'Josevaldo Santos de Jesus'},
    {'mat': '4748', 'nome': 'José Alberto de Araujo Cristo'},
    {'mat': '70205556', 'nome': 'José Cerqueira dos Santos'},
    {'mat': '5170', 'nome': 'Jucineia Queiroz Oliveira'},
    {'mat': '99300525', 'nome': 'Kezya Queiroz Oliveira Borges'},
    {'mat': '5236', 'nome': 'Kleberlito Luciano Carneiro da Silva'},
    {'mat': '4752', 'nome': 'Leonardo Mota Nascimento'},
    {'mat': '99300264', 'nome': 'Leonardo dos Santos Lima de Queiroz'},
    {'mat': '99300295', 'nome': 'Lucas Evangelista Farias Cerqueira'},
    {'mat': '70205587', 'nome': 'Lucas Moura de Mendonca'},
    {'mat': '4793', 'nome': 'Marcolino dos Santos'},
    {'mat': '99300327', 'nome': 'Marcos Cassiano Oliveira Santos'},
    {'mat': '4933', 'nome': 'Marcos Neves Moura'},
    {'mat': '99300152', 'nome': 'Marcos Real Mota'},
    {'mat': '99300061', 'nome': 'Mateus Barreto Calvacante'},
    {'mat': '4795', 'nome': 'Matheus Silva Pastor'},
    {'mat': '70206772', 'nome': 'Natalino Paixão dos Santos'},
    {'mat': '99300589', 'nome': 'Niel Pereira Rodrigues'},
    {'mat': '70207289', 'nome': 'Pablo Oliveira Araujo'},
    {'mat': '99300461', 'nome': 'Paulo Ditarso Guimaraes Porto Souza'},
    {'mat': '5248', 'nome': 'Paulo Henrique Lima de Santana'},
    {'mat': '5169', 'nome': 'Pedro Henrique Alves De Souza'},
    {'mat': '5251', 'nome': 'Rafael de Oliveira Cardoso'},
    {'mat': '99300772', 'nome': 'Rayane silva lima'},
    {'mat': '99300440', 'nome': 'Ricardo Moraes'},
    {'mat': '99300594', 'nome': 'Ricardo Santos Lima'},
    {'mat': '4797', 'nome': 'Robenilson Cerqueira dos Santos'},
    {'mat': '4798', 'nome': 'Roberto das Virgens Ferreira'},
    {'mat': '5258', 'nome': 'Robson Ricardo da Soares da Silva'},
    {'mat': '4758', 'nome': 'Romilson Lima Oliveira'},
    {'mat': '99300699', 'nome': 'Romilson Santos de Jesus'},
    {'mat': '99300677', 'nome': 'Ronaldo do Rosario Nascimento'},
    {'mat': '99300446', 'nome': 'Sandro Pereira dos Santos'},
    {'mat': '4899', 'nome': 'Saul Vinicius de Jesus Souza'},
    {'mat': '4800', 'nome': 'Venancio Araújo Queiroz'},
    {'mat': '4802', 'nome': 'William Pereira da Silva'}
  ];
}
