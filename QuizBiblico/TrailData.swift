import Foundation

enum TrailData {
    static let nodes: [TrailNodeData] = [
        TrailNodeData(
            id: 1,
            title: "A Criação",
            subtitle: "O início de tudo",
            emoji: "🌍",
            reference: "Gênesis 1–2",
            studyText: """
            No princípio, Deus criou os céus e a terra. Em seis dias, Ele formou o universo inteiro: no primeiro dia, separou a luz das trevas; no segundo, o firmamento das águas; no terceiro, fez surgir a terra seca e a vegetação; no quarto, colocou o sol, a lua e as estrelas; no quinto, encheu o mar e o céu de criaturas; e no sexto, criou os animais e, por fim, o homem.

            O ser humano foi o ponto culminante da criação. Deus o formou do pó da terra e soprou em suas narinas o fôlego de vida — e o homem se tornou um ser vivente. Diferente de todas as outras criaturas, o homem e a mulher foram feitos à imagem e semelhança de Deus.

            No sétimo dia, Deus descansou de toda a obra que havia feito e abençoou esse dia, tornando-o santo. Esse padrão — seis dias de trabalho e um de descanso — continua a ser o fundamento do sábado para o povo de Deus.
            """,
            keyVerses: [
                TrailVerse(text: "No princípio, Deus criou os céus e a terra.", reference: "Gênesis 1:1"),
                TrailVerse(text: "E criou Deus o homem à sua imagem; à imagem de Deus o criou; homem e mulher os criou.", reference: "Gênesis 1:27"),
                TrailVerse(text: "Então, o Senhor Deus formou o homem do pó da terra e soprou nas suas narinas o fôlego de vida.", reference: "Gênesis 2:7"),
            ],
            questions: [
                TrailQuestion(id: 101, question: "Em quantos dias Deus criou o mundo?", options: ["3 dias", "6 dias", "7 dias", "10 dias"], correctIndex: 1, explanation: "Deus criou o mundo em 6 dias e no 7º descansou (Gênesis 2:2)."),
                TrailQuestion(id: 102, question: "O que Deus criou no primeiro dia?", options: ["Os animais", "A luz", "O céu e a terra", "Os peixes"], correctIndex: 1, explanation: "No primeiro dia Deus disse 'Haja luz' e separou a luz das trevas (Gênesis 1:3-5)."),
                TrailQuestion(id: 103, question: "Do que Deus formou o corpo do homem?", options: ["Da água", "Do ar", "Do pó da terra", "Da madeira"], correctIndex: 2, explanation: "Deus formou o homem do pó da terra e soprou o fôlego de vida (Gênesis 2:7)."),
                TrailQuestion(id: 104, question: "Como se chamava o jardim onde Adão e Eva viviam?", options: ["Sinai", "Éden", "Canaã", "Babel"], correctIndex: 1, explanation: "Deus plantou o jardim do Éden no oriente e colocou lá o homem que havia formado (Gênesis 2:8)."),
                TrailQuestion(id: 105, question: "O que Deus fez no sétimo dia?", options: ["Criou o mar", "Julgou o homem", "Descansou", "Plantou árvores"], correctIndex: 2, explanation: "No sétimo dia Deus descansou de toda a sua obra e abençoou esse dia, santificando-o (Gênesis 2:2-3)."),
            ],
            status: .available
        ),

        TrailNodeData(
            id: 2,
            title: "Adão e Eva",
            subtitle: "A queda do homem",
            emoji: "🍎",
            reference: "Gênesis 3",
            studyText: """
            Deus havia plantado no jardim do Éden duas árvores especiais: a árvore da vida e a árvore do conhecimento do bem e do mal. Deus ordenou a Adão que não comesse do fruto desta última, sob pena de morte.

            A serpente, mais astuta que todos os animais do campo, aproximou-se de Eva e a enganou, dizendo que ela não morreria, mas que seus olhos seriam abertos e ela seria como Deus, conhecendo o bem e o mal. Eva comeu do fruto e deu a Adão, que também comeu.

            Imediatamente, os dois perceberam que estavam nus e sentiram vergonha. Quando Deus os chamou, Adão se escondeu. Como consequência da desobediência, a serpente foi amaldiçoada, Eva recebeu dores no parto e Adão passou a ter que trabalhar com suor do rosto. Eles foram expulsos do jardim do Éden.
            """,
            keyVerses: [
                TrailVerse(text: "E viu a mulher que aquela árvore era boa para se comer, e agradável aos olhos, e árvore desejável para dar entendimento; tomou do seu fruto, e comeu, e deu também a seu marido.", reference: "Gênesis 3:6"),
                TrailVerse(text: "Comerás o pão com o suor do teu rosto, até que tornes à terra; porque dela foste tomado; porquanto és pó e ao pó tornarás.", reference: "Gênesis 3:19"),
            ],
            questions: [
                TrailQuestion(id: 201, question: "Quem tentou Eva no jardim do Éden?", options: ["Um leão", "Um anjo", "A serpente", "Um outro homem"], correctIndex: 2, explanation: "A serpente, mais astuta que todos os animais, enganou Eva (Gênesis 3:1)."),
                TrailQuestion(id: 202, question: "O que aconteceu quando Adão e Eva comeram o fruto proibido?", options: ["Dormiram profundamente", "Viraram animais", "Perceberam que estavam nus", "Tornaram-se fortes"], correctIndex: 2, explanation: "Então os olhos de ambos se abriram e perceberam que estavam nus (Gênesis 3:7)."),
                TrailQuestion(id: 203, question: "Para onde Adão e Eva foram expulsos?", options: ["Para o deserto do Negueve", "Para fora do jardim do Éden", "Para o Egito", "Para o mar"], correctIndex: 1, explanation: "Deus expulsou o homem do jardim do Éden (Gênesis 3:23)."),
                TrailQuestion(id: 204, question: "Qual foi a punição de Adão após a queda?", options: ["Ser escravo", "Trabalhar com suor do rosto", "Nunca mais dormir", "Perder a fala"], correctIndex: 1, explanation: "Deus disse a Adão que comeria o pão com o suor do rosto (Gênesis 3:19)."),
                TrailQuestion(id: 205, question: "O que Deus colocou para guardar o acesso à árvore da vida?", options: ["Um muro de pedra", "Um anjo com espada flamejante", "Um rio profundo", "Uma montanha"], correctIndex: 1, explanation: "Deus pôs querubins e uma espada flamejante para guardar o caminho à árvore da vida (Gênesis 3:24)."),
            ],
            status: .locked
        ),

        TrailNodeData(
            id: 3,
            title: "O Dilúvio",
            subtitle: "Noé e a arca",
            emoji: "🌊",
            reference: "Gênesis 6–9",
            studyText: """
            Com o crescimento da humanidade, a maldade dos homens também aumentou muito. Deus se arrependeu de ter criado o homem e decidiu destruir toda a carne que vivia sobre a terra. Porém, Noé era um homem justo e íntegro entre seus contemporâneos — ele andava com Deus.

            Deus ordenou que Noé construísse uma arca de madeira de gófer, com medidas exatas, para salvar sua família e um par de cada espécie de animal. Noé obedeceu a tudo que Deus ordenou. Quando a arca estava pronta, Noé, sua esposa, seus três filhos e as esposas deles entraram, junto com os animais.

            A chuva durou quarenta dias e quarenta noites, e as águas cobriram até as mais altas montanhas. Todos os seres vivos da terra morreram. Depois que as águas baixaram e a terra secou, Noé saiu da arca e ofereceu holocaustos a Deus. Deus fez uma aliança com Noé e colocou um arco-íris no céu como sinal de que nunca mais destruiria a terra com um dilúvio.
            """,
            keyVerses: [
                TrailVerse(text: "Faze para ti uma arca de madeira de gófer... Porque eu, eis que farei vir o dilúvio de águas sobre a terra.", reference: "Gênesis 6:14,17"),
                TrailVerse(text: "O meu arco tenho posto nas nuvens, o qual será por sinal de aliança entre mim e a terra.", reference: "Gênesis 9:13"),
            ],
            questions: [
                TrailQuestion(id: 301, question: "Por que Deus enviou o dilúvio sobre a terra?", options: ["Porque Noé pecou", "Pela grande maldade dos homens", "Para criar os oceanos", "Por causa de uma guerra"], correctIndex: 1, explanation: "A maldade dos homens era grande na terra e todo desígnio do seu coração era mau (Gênesis 6:5)."),
                TrailQuestion(id: 302, question: "Quantos dias e noites choveu durante o dilúvio?", options: ["7 dias", "20 dias", "40 dias e 40 noites", "100 dias"], correctIndex: 2, explanation: "A chuva caiu sobre a terra por quarenta dias e quarenta noites (Gênesis 7:12)."),
                TrailQuestion(id: 303, question: "Qual ave Noé soltou para verificar se as águas haviam baixado?", options: ["Águia", "Corvo e pomba", "Gaivota", "Pardal"], correctIndex: 1, explanation: "Noé soltou um corvo e depois uma pomba. A pomba voltou com um ramo de oliveira, sinal de que as águas tinham baixado (Gênesis 8:6-11)."),
                TrailQuestion(id: 304, question: "Qual foi o sinal da aliança de Deus com Noé?", options: ["Uma estrela brilhante", "Um arco-íris", "Uma pedra de fogo", "Uma pomba"], correctIndex: 1, explanation: "Deus pôs seu arco nas nuvens como sinal de aliança de que nunca mais destruiria a terra com dilúvio (Gênesis 9:13)."),
                TrailQuestion(id: 305, question: "Quantos filhos Noé tinha?", options: ["Dois", "Três", "Quatro", "Cinco"], correctIndex: 1, explanation: "Noé tinha três filhos: Sem, Cam e Jafé (Gênesis 6:10)."),
            ],
            status: .locked
        ),

        TrailNodeData(
            id: 4,
            title: "Torre de Babel",
            subtitle: "A confusão das línguas",
            emoji: "🗼",
            reference: "Gênesis 11",
            studyText: """
            Depois do dilúvio, toda a terra tinha uma só língua e um só modo de falar. Os homens migraram para o oriente e se estabeleceram numa planície chamada Sinear, na terra da Babilônia.

            Lá, eles decidiram construir uma cidade e uma torre que chegasse até o céu, para que fizessem um nome para si mesmos e não fossem espalhados pela face de toda a terra. Esse plano era contrário ao mandamento de Deus, que os havia ordenado a encher e dominar a terra.

            Deus desceu para ver a cidade e a torre que os filhos dos homens edificavam. Vendo sua ambição desmedida, Deus confundiu a linguagem deles para que um não entendesse o outro, e os dispersou por toda a face da terra. A cidade foi chamada Babel, que significa "confusão". Esse evento explica a origem das diferentes línguas e povos da terra.
            """,
            keyVerses: [
                TrailVerse(text: "Venha, edifiquemos nós uma cidade e uma torre cujo cume chegue até ao céu, e façamos um nome para nós.", reference: "Gênesis 11:4"),
                TrailVerse(text: "Por isso se chamou o seu nome Babel, porquanto ali confundiu o Senhor a linguagem de toda a terra.", reference: "Gênesis 11:9"),
            ],
            questions: [
                TrailQuestion(id: 401, question: "Por que os homens quiseram construir a Torre de Babel?", options: ["Para se proteger de inimigos", "Para chegar ao céu e fazer um nome", "Para armazenar alimentos", "Para observar as estrelas"], correctIndex: 1, explanation: "Eles queriam construir uma torre cujo cume chegasse ao céu e fazer um nome para si mesmos (Gênesis 11:4)."),
                TrailQuestion(id: 402, question: "O que Deus fez para impedir a construção da torre?", options: ["Destruiu a torre com fogo", "Confundiu a linguagem dos homens", "Enviou um anjo armado", "Inundou o local"], correctIndex: 1, explanation: "Deus confundiu a linguagem de toda a terra para que um não entendesse o outro (Gênesis 11:7)."),
                TrailQuestion(id: 403, question: "Em que planície os construtores da torre se estabeleceram?", options: ["Megido", "Sinear", "Judeia", "Hebrom"], correctIndex: 1, explanation: "Eles se estabeleceram numa planície na terra de Sinear (Gênesis 11:2)."),
                TrailQuestion(id: 404, question: "O que significa o nome 'Babel'?", options: ["Exaltação", "Confusão", "Vitória", "Reunião"], correctIndex: 1, explanation: "A cidade foi chamada Babel porque ali Deus confundiu a linguagem de toda a terra (Gênesis 11:9)."),
                TrailQuestion(id: 405, question: "Qual foi a consequência final da construção da torre?", options: ["Os homens ficaram escravos", "Os homens foram dispersos por toda a terra", "A torre foi destruída por raios", "Os homens se converteram a Deus"], correctIndex: 1, explanation: "Deus dispersou os homens por toda a face da terra e eles cessaram de edificar a cidade (Gênesis 11:8)."),
            ],
            status: .locked
        ),

        TrailNodeData(
            id: 5,
            title: "Abraão",
            subtitle: "O pai da fé",
            emoji: "⭐",
            reference: "Gênesis 12–22",
            studyText: """
            Deus chamou Abrão (mais tarde renomeado Abraão) para sair de sua terra e de sua parentela, prometendo-lhe que faria dele uma grande nação, abençoando-o e tornando seu nome grande. Abrão tinha 75 anos quando partiu de Harã. Esse chamado exigiu fé enorme, pois ele não sabia para onde ia.

            Deus fez uma aliança solene com Abraão, prometendo dar a terra de Canaã para seus descendentes e que nele seriam abençoadas todas as famílias da terra. Para confirmar essa aliança, Deus mudou seu nome de Abrão para Abraão — "pai de uma multidão" — e instituiu a circuncisão como sinal da aliança.

            O maior teste de fé de Abraão veio quando Deus ordenou que ele sacrificasse seu filho Isaque, filho da promessa que nasceu milagrosamente de Sara quando ela tinha 90 anos. Abraão obedeceu sem questionar. No momento em que ele ia baixar a faca, o anjo do Senhor o deteve. Deus mesmo providenciou um carneiro para o sacrifício, e Abraão chamou aquele lugar "O Senhor proverá."
            """,
            keyVerses: [
                TrailVerse(text: "Ora o Senhor disse a Abrão: Sai da tua terra, da tua parentela e da casa de teu pai, para a terra que eu te mostrarei. E far-te-ei uma grande nação.", reference: "Gênesis 12:1-2"),
                TrailVerse(text: "Não estendas a tua mão sobre o rapaz, nem lhe faças nenhum mal; porque agora conheço que temes a Deus, pois não me negaste o teu filho, o teu único.", reference: "Gênesis 22:12"),
            ],
            questions: [
                TrailQuestion(id: 501, question: "Para onde Deus chamou Abraão quando saiu de Harã?", options: ["Para o Egito", "Para a terra que Deus mostraria", "Para a Caldeia", "Para Babel"], correctIndex: 1, explanation: "Deus chamou Abrão para sair para a terra que Ele mostraria (Gênesis 12:1)."),
                TrailQuestion(id: 502, question: "Quantos anos tinha Abraão quando saiu de Harã?", options: ["50 anos", "60 anos", "75 anos", "100 anos"], correctIndex: 2, explanation: "Abrão tinha 75 anos quando partiu de Harã (Gênesis 12:4)."),
                TrailQuestion(id: 503, question: "Como se chamava a esposa de Abraão?", options: ["Rebeca", "Raquel", "Sara", "Lia"], correctIndex: 2, explanation: "A esposa de Abraão se chamava Sara (antes Sarai) (Gênesis 17:15)."),
                TrailQuestion(id: 504, question: "Qual foi o maior teste de fé de Abraão?", options: ["Deixar sua terra natal", "Sacrificar seu filho Isaque", "Lutar contra cinco reis", "Viver no deserto 40 anos"], correctIndex: 1, explanation: "Deus ordenou que Abraão sacrificasse seu filho Isaque, o filho da promessa (Gênesis 22:2)."),
                TrailQuestion(id: 505, question: "O que Deus providenciou no lugar de Isaque no sacrifício?", options: ["Uma pomba", "Um bezerro", "Uma cabra", "Um carneiro"], correctIndex: 3, explanation: "Abraão ergueu os olhos e viu um carneiro (em hebraico: 'ayil') preso pelos chifres num matagal, e o ofereceu como holocausto (Gênesis 22:13)."),
            ],
            status: .locked
        ),

        TrailNodeData(
            id: 6,
            title: "Isaque e Jacó",
            subtitle: "As bênçãos e a luta",
            emoji: "👨‍👦",
            reference: "Gênesis 25–35",
            studyText: """
            Isaque, filho de Abraão, casou-se com Rebeca e tiveram gêmeos: Esaú, o mais velho, e Jacó. Mesmo antes de nascerem, Deus revelou que o mais velho serviria ao mais novo — um princípio que se repetiria ao longo de toda a história bíblica.

            Esaú era um hábil caçador e preferido de Isaque, enquanto Jacó era tranquilo e preferido de Rebeca. Um dia, Esaú voltou faminto da caça e vendeu sua primogenitura a Jacó por um prato de lentilhas. Anos depois, com a ajuda de Rebeca, Jacó enganou seu pai idoso Isaque e roubou a bênção que era devida a Esaú.

            Jacó precisou fugir para Harã por causa da ira de Esaú. Na viagem, Deus apareceu a ele num sonho famoso, com uma escada que chegava ao céu. Anos depois, ao retornar para Canaã, Jacó lutou com um homem (entendido como o anjo do Senhor ou o próprio Deus em forma humana) durante uma noite inteira. Jacó não desistiu e recebeu uma bênção, além de um novo nome: Israel, que significa "o que lutou com Deus."
            """,
            keyVerses: [
                TrailVerse(text: "Disse Jacó: Vende-me hoje os teus direitos de primogênito. Respondeu Esaú: Eis que estou a ponto de morrer; e de que me aproveitará o direito de primogênito?", reference: "Gênesis 25:31-32"),
                TrailVerse(text: "Não te chamarás mais Jacó, mas Israel; porque lutaste com Deus e com os homens, e prevaleceste.", reference: "Gênesis 32:28"),
            ],
            questions: [
                TrailQuestion(id: 601, question: "Como se chamavam os filhos gêmeos de Isaque?", options: ["Sem e Cam", "Esaú e Jacó", "Moisés e Arão", "Davi e Salomão"], correctIndex: 1, explanation: "Isaque e Rebeca tiveram gêmeos: Esaú e Jacó (Gênesis 25:24-26)."),
                TrailQuestion(id: 602, question: "O que Esaú vendeu a Jacó por um prato de comida?", options: ["Sua fazenda", "Sua espada", "Seu direito de primogênito", "Seus rebanhos"], correctIndex: 2, explanation: "Esaú desprezou o direito de primogênito e o vendeu a Jacó por pão e lentilhas (Gênesis 25:33-34)."),
                TrailQuestion(id: 603, question: "Com quem Jacó lutou a noite inteira?", options: ["Com Esaú", "Com um homem enviado por Deus", "Com soldados do Faraó", "Com o rei de Canaã"], correctIndex: 1, explanation: "Um homem lutou com Jacó até raiar o dia. Jacó disse que tinha visto Deus face a face (Gênesis 32:24,30)."),
                TrailQuestion(id: 604, question: "Qual novo nome Jacó recebeu depois de lutar?", options: ["Israel", "Abraão", "Simão", "Judá"], correctIndex: 0, explanation: "Jacó recebeu o nome Israel, pois lutou com Deus e com os homens e prevaleceu (Gênesis 32:28)."),
                TrailQuestion(id: 605, question: "Em que cidade Deus apareceu a Jacó num sonho com uma escada ao céu?", options: ["Jericó", "Belém", "Betel", "Hebrom"], correctIndex: 2, explanation: "Jacó dormiu em Luz (que ele chamou de Betel) e sonhou com uma escada que chegava ao céu (Gênesis 28:12,19)."),
            ],
            status: .locked
        ),

        TrailNodeData(
            id: 7,
            title: "José no Egito",
            subtitle: "De escravo a governador",
            emoji: "🏺",
            reference: "Gênesis 37–50",
            studyText: """
            Jacó amava José mais do que todos os seus outros filhos e lhe fez uma túnica de muitas cores. Os irmãos de José ficaram com inveja e passaram a odiá-lo. Para piorar, José contou aos irmãos dois sonhos que teve, onde eles se curvavam diante dele.

            Os irmãos aproveitaram uma oportunidade e venderam José a mercadores ismaelitas por vinte siclos de prata. Ele foi levado ao Egito e vendido como escravo para Potifar, um oficial do Faraó. Mesmo como escravo, José prosperou pois Deus estava com ele. Ele foi falsamente acusado pela esposa de Potifar e jogado na prisão.

            Na prisão, José interpretou os sonhos do copeiro e do padeiro do Faraó. Dois anos depois, o Faraó teve dois sonhos perturbadores que ninguém conseguia interpretar. O copeiro se lembrou de José, que foi chamado e interpretou os sonhos: sete anos de fartura seguidos de sete anos de fome. O Faraó ficou tão impressionado que nomeou José governador de todo o Egito. Durante a fome, os irmãos vieram buscar comida e José, reconhecendo-os, revelou sua identidade com grande emoção, dizendo que Deus havia transformado em bem o que eles tinham planejado para o mal.
            """,
            keyVerses: [
                TrailVerse(text: "E tiraram José da cova e venderam-no aos ismaelitas por vinte siclos de prata.", reference: "Gênesis 37:28"),
                TrailVerse(text: "Vós intentastes o mal contra mim, mas Deus o intentou para o bem, para fazer como se vê hoje, para conservar em vida um povo numeroso.", reference: "Gênesis 50:20"),
            ],
            questions: [
                TrailQuestion(id: 701, question: "O que os irmãos de José fizeram com ele?", options: ["O enviaram ao sacerdote", "O venderam como escravo", "O mandaram embora de casa", "O colocaram na prisão"], correctIndex: 1, explanation: "Os irmãos venderam José a mercadores ismaelitas por vinte siclos de prata (Gênesis 37:28)."),
                TrailQuestion(id: 702, question: "Para quem José foi vendido no Egito?", options: ["Para o Faraó diretamente", "Para Potifar, oficial do Faraó", "Para um sacerdote egípcio", "Para um fazendeiro"], correctIndex: 1, explanation: "Os ismaelitas venderam José a Potifar, oficial do Faraó e capitão da guarda (Gênesis 39:1)."),
                TrailQuestion(id: 703, question: "O que significavam as 7 vacas gordas no sonho do Faraó?", options: ["7 guerras vitoriosas", "7 anos de fartura", "7 pragas sobre o Egito", "7 filhos do Faraó"], correctIndex: 1, explanation: "José interpretou as 7 vacas gordas como 7 anos de grande abundância em toda a terra do Egito (Gênesis 41:26)."),
                TrailQuestion(id: 704, question: "Qual cargo José recebeu no Egito?", options: ["Sacerdote do templo", "General do exército", "Governador sobre todo o Egito", "Mordomo do Faraó"], correctIndex: 2, explanation: "O Faraó constituiu José sobre toda a terra do Egito (Gênesis 41:41)."),
                TrailQuestion(id: 705, question: "Por quantos siclos de prata José foi vendido?", options: ["10 siclos", "20 siclos", "30 siclos", "50 siclos"], correctIndex: 1, explanation: "Os irmãos venderam José por vinte siclos de prata (Gênesis 37:28)."),
            ],
            status: .locked
        ),

        TrailNodeData(
            id: 8,
            title: "Moisés",
            subtitle: "O libertador de Israel",
            emoji: "👶",
            reference: "Êxodo 1–4",
            studyText: """
            Depois da morte de José, um novo rei subiu ao trono do Egito e não conhecia José. Vendo que o povo de Israel crescia muito, o Faraó os tornou escravos e ordenou que todos os meninos hebreus recém-nascidos fossem jogados no rio Nilo.

            Quando Moisés nasceu, sua mãe viu que ele era bonito e o escondeu por três meses. Quando não pôde mais escondê-lo, colocou-o numa cesta de junco no rio. A filha do Faraó encontrou o bebê e o adotou. Ironicamente, a própria mãe de Moisés foi contratada como ama para cuidar dele.

            Quando cresceu, Moisés matou um egípcio que agredia um hebreu e teve que fugir para Midiã. Lá, no monte Horebe, Deus apareceu a ele numa sarça que ardia mas não se consumia. Deus revelou seu nome — "EU SOU O QUE SOU" — e comissionou Moisés para voltar ao Egito e libertar o povo de Israel da escravidão. Moisés hesitou, alegando ser lento de língua, mas Deus prometeu estar com ele e designou Arão como seu porta-voz.
            """,
            keyVerses: [
                TrailVerse(text: "Não podendo mais escondê-lo, tomou uma cesta de junco, e a calafetou com betume e pez, e pôs nela o menino, e a colocou nos juncos à beira do rio.", reference: "Êxodo 2:3"),
                TrailVerse(text: "E disse Deus a Moisés: EU SOU O QUE SOU. Disse mais: Assim dirás aos filhos de Israel: EU SOU me enviou a vós.", reference: "Êxodo 3:14"),
            ],
            questions: [
                TrailQuestion(id: 801, question: "Por que Moisés foi colocado numa cesta no rio?", options: ["Para se esconder de ladrões", "Para escapar da ordem do Faraó de matar bebês hebreus", "Para ser achado pelo Faraó", "Para atravessar o rio Nilo"], correctIndex: 1, explanation: "O Faraó ordenou que todo filho varão hebreu fosse lançado no rio Nilo. A mãe de Moisés o colocou numa cesta para salvar sua vida (Êxodo 1:22, 2:3)."),
                TrailQuestion(id: 802, question: "Quem encontrou Moisés no rio?", options: ["A esposa de Potifar", "A filha do Faraó", "Uma sacerdotisa egípcia", "Uma mulher midianita"], correctIndex: 1, explanation: "A filha do Faraó desceu ao rio, viu a cesta e mandou buscá-la; abriu-a e viu o menino (Êxodo 2:5-6)."),
                TrailQuestion(id: 803, question: "Como Deus apareceu a Moisés no deserto?", options: ["Numa coluna de fumaça", "Numa sarça ardente que não se consumia", "Numa visão noturna", "Numa tempestade"], correctIndex: 1, explanation: "O anjo do Senhor apareceu a Moisés numa chama de fogo, do meio de uma sarça. A sarça ardia mas não se consumia (Êxodo 3:2)."),
                TrailQuestion(id: 804, question: "Para que terra Moisés fugiu depois de matar o egípcio?", options: ["Para Canaã", "Para Midiã", "Para a Arábia", "Para a Síria"], correctIndex: 1, explanation: "Moisés fugiu de diante do Faraó e habitou na terra de Midiã (Êxodo 2:15)."),
                TrailQuestion(id: 805, question: "Quem Deus designou para ser porta-voz de Moisés?", options: ["Josué", "Calebe", "Arão", "Miriam"], correctIndex: 2, explanation: "Deus designou Arão, irmão de Moisés, para ser seu porta-voz perante o Faraó (Êxodo 4:14-16)."),
            ],
            status: .locked
        ),

        TrailNodeData(
            id: 9,
            title: "As Pragas",
            subtitle: "O juízo sobre o Egito",
            emoji: "🐸",
            reference: "Êxodo 7–12",
            studyText: """
            Moisés e Arão foram repetidamente ao Faraó pedindo que libertasse o povo de Israel, mas o Faraó endureceu o coração e recusou. Deus então enviou dez pragas devastadoras sobre o Egito, cada uma delas um julgamento contra os deuses egípcios.

            As pragas foram: água transformada em sangue, rãs, piolhos, moscas, morte do gado, úlceras, granizo, gafanhotos, trevas por três dias, e por fim a morte de todos os primogênitos do Egito. Cada praga que atingia os egípcios poupava a terra de Gósen, onde viviam os israelitas, demonstrando que Deus fazia distinção entre Israel e o Egito.

            Antes da décima praga, Deus institui a Páscoa (Pessach): cada família israelita deveria imolar um cordeiro sem defeito, pintar as ombreiras das portas com seu sangue, e comer a carne assada com pães sem fermento e ervas amargas. O anjo destruidor passaria sobre as casas que tivessem o sangue nas portas, poupando os primogênitos de Israel. Essa festa tornou-se um memorial eterno da libertação de Israel do Egito.
            """,
            keyVerses: [
                TrailVerse(text: "E o sangue será por sinal para vós nas casas onde estiverdes; e verei o sangue, e passarei por cima de vós.", reference: "Êxodo 12:13"),
                TrailVerse(text: "Assim diz o Senhor: Israel é meu filho, o meu primogênito... Deixa ir o meu filho.", reference: "Êxodo 4:22-23"),
            ],
            questions: [
                TrailQuestion(id: 901, question: "Quantas pragas Deus enviou sobre o Egito?", options: ["7", "9", "10", "12"], correctIndex: 2, explanation: "Deus enviou dez pragas sobre o Egito (Êxodo 7-12)."),
                TrailQuestion(id: 902, question: "Qual foi a primeira praga enviada por Deus?", options: ["Rãs por toda parte", "Água transformada em sangue", "Trevas por três dias", "Morte dos primogênitos"], correctIndex: 1, explanation: "A primeira praga foi a água do rio Nilo transformada em sangue (Êxodo 7:20)."),
                TrailQuestion(id: 903, question: "Qual foi a décima e última praga?", options: ["Gafanhotos que destruíram as lavouras", "Três dias de trevas totais", "Morte de todos os primogênitos do Egito", "Granizo misturado com fogo"], correctIndex: 2, explanation: "A décima praga foi a morte de todos os primogênitos do Egito, da pessoa ao animal (Êxodo 12:29)."),
                TrailQuestion(id: 904, question: "O que os israelitas deveriam pintar nas ombreiras das portas na Páscoa?", options: ["Azeite de oliva", "Sangue do cordeiro", "Água do Nilo", "Óleo de palma"], correctIndex: 1, explanation: "O sangue do cordeiro devia ser posto nas ombreiras e na verga das portas para proteção contra o anjo destruidor (Êxodo 12:7)."),
                TrailQuestion(id: 905, question: "Como se chama a festa que comemora a libertação do Egito?", options: ["Pentecostes", "Páscoa (Pessach)", "Tabernáculos", "Primícias"], correctIndex: 1, explanation: "A festa da Páscoa (Pessach) foi instituída por Deus para comemorar a libertação de Israel do Egito (Êxodo 12:14)."),
            ],
            status: .locked
        ),

        TrailNodeData(
            id: 10,
            title: "O Mar Vermelho",
            subtitle: "A grande travessia",
            emoji: "🌊",
            reference: "Êxodo 14",
            studyText: """
            Depois da décima praga, o Faraó finalmente deixou Israel partir. Deus guiou o povo pelo deserto com uma coluna de nuvem durante o dia e uma coluna de fogo à noite. Mas o Faraó se arrependeu de ter deixado os israelitas partirem e saiu em perseguição com seus carros de guerra.

            Com o mar à frente e o exército egípcio atrás, o povo de Israel entrou em pânico. Moisés declarou: "O Senhor pelejará por vós, e vós vos calareis." Por ordem de Deus, Moisés estendeu sua mão sobre o mar, e Deus fez soprar um forte vento leste durante toda a noite, dividindo as águas. Os israelitas atravessaram o mar em terra seca, com as águas formando muros dos dois lados.

            Quando o exército egípcio tentou persegui-los pelo leito seco, Moisés estendeu novamente sua mão e as águas voltaram, cobrindo carros, cavaleiros e todo o exército do Faraó. Não sobrou nem um. Israel viu o grande poder de Deus e o povo temeu ao Senhor e creu nele. Moisés e Miriam entoaram um cântico de louvor a Deus pela gloriosa vitória.
            """,
            keyVerses: [
                TrailVerse(text: "E Moisés estendeu a sua mão sobre o mar; e o Senhor fez retirar o mar por meio de um forte vento leste que soprou toda aquela noite, e tornou o mar em terra seca.", reference: "Êxodo 14:21"),
                TrailVerse(text: "Cantarei ao Senhor, porque se houve gloriosamente; precipitou no mar o cavalo e o seu cavaleiro.", reference: "Êxodo 15:1"),
            ],
            questions: [
                TrailQuestion(id: 1001, question: "Como Deus guiava Israel no deserto?", options: ["Por meio de um profeta que ia à frente", "Com uma coluna de nuvem de dia e de fogo à noite", "Por anjos visíveis em forma humana", "Com a Arca da Aliança na frente"], correctIndex: 1, explanation: "Deus ia diante de Israel numa coluna de nuvem de dia e numa coluna de fogo de noite (Êxodo 13:21)."),
                TrailQuestion(id: 1002, question: "O que Moisés fez para abrir o Mar Vermelho?", options: ["Orou em voz alta por três dias", "Golpeou a água com sua sandália", "Estendeu sua mão sobre o mar", "Lançou sua vara dentro do mar"], correctIndex: 2, explanation: "Por ordem de Deus, Moisés estendeu sua mão sobre o mar (Êxodo 14:21)."),
                TrailQuestion(id: 1003, question: "O que os israelitas viram ao atravessar o mar?", options: ["A costa da terra prometida", "Anjos guerreiros", "Muros de água dos dois lados", "Uma ponte de pedra"], correctIndex: 2, explanation: "As águas se dividiram e os israelitas foram pelo meio do mar em terra seca, com as águas como muro à sua direita e à sua esquerda (Êxodo 14:22)."),
                TrailQuestion(id: 1004, question: "O que aconteceu com o exército egípcio?", options: ["Voltou ao Egito sem lutar", "Foi derrotado por Israel em batalha", "Foi afogado pelo retorno das águas", "Rendeu-se a Moisés"], correctIndex: 2, explanation: "As águas voltaram e cobriram os carros, os cavaleiros e todo o exército do Faraó. Não ficou nem um (Êxodo 14:28)."),
                TrailQuestion(id: 1005, question: "Quem cantou junto com Moisés o cântico de vitória após a travessia?", options: ["Arão e os sacerdotes", "Miriam e as mulheres", "Os anciãos de Israel", "Josué e os guerreiros"], correctIndex: 1, explanation: "Miriam, a profetisa, irmã de Arão, tomou um tamborim, e todas as mulheres saíram após ela com tamborins e danças cantando (Êxodo 15:20)."),
            ],
            status: .locked
        ),

        TrailNodeData(
            id: 11,
            title: "Os 10 Mandamentos",
            subtitle: "A Lei de Deus",
            emoji: "📜",
            reference: "Êxodo 19–20",
            studyText: """
            Três meses depois de saírem do Egito, os israelitas chegaram ao monte Sinai. Deus chamou Moisés ao topo do monte e desceu sobre o Sinai em fogo. A montanha fumegava, havia trovões, relâmpagos e o som de uma trombeta muito forte. O povo ficou com medo e ficou de longe.

            Moisés subiu ao monte e lá recebeu os Dez Mandamentos diretamente de Deus, escritos em duas tábuas de pedra pelo próprio dedo de Deus. Os mandamentos cobrem tanto as obrigações para com Deus (adoração exclusiva, não fazer ídolos, não usar o nome de Deus em vão, guardar o sábado) quanto as obrigações para com o próximo (honrar pai e mãe, não matar, não adulterar, não roubar, não mentir, não cobiçar).

            Moisés ficou no monte quarenta dias e quarenta noites. Enquanto isso, o povo convenceu Arão a fazer um bezerro de ouro para adorar. Quando Moisés desceu e viu o povo dançando em volta do ídolo, ficou tão irado que quebrou as tábuas. Após interceder pelo povo, Deus mandou Moisés subir novamente e lhe deu novas tábuas com os mandamentos.
            """,
            keyVerses: [
                TrailVerse(text: "Não terás outros deuses diante de mim.", reference: "Êxodo 20:3"),
                TrailVerse(text: "Honra teu pai e tua mãe, para que se prolonguem os teus dias na terra que o Senhor teu Deus te dá.", reference: "Êxodo 20:12"),
                TrailVerse(text: "Lembra-te do dia do sábado, para o santificar.", reference: "Êxodo 20:8"),
            ],
            questions: [
                TrailQuestion(id: 1101, question: "Onde Deus deu os Dez Mandamentos a Moisés?", options: ["No deserto do Negueve", "No monte Sinai", "No monte Carmelo", "Em Canaã"], correctIndex: 1, explanation: "Deus desceu sobre o monte Sinai e chamou Moisés ao alto para lhe dar os mandamentos (Êxodo 19:20)."),
                TrailQuestion(id: 1102, question: "Em que material foram escritos os mandamentos?", options: ["Em pergaminho de couro", "Em madeira de cedro", "Em tábuas de pedra", "Em papiro egípcio"], correctIndex: 2, explanation: "As tábuas eram obra de Deus; a escrita era a escrita de Deus, gravada nas tábuas (Êxodo 32:16)."),
                TrailQuestion(id: 1103, question: "O que o povo fez enquanto Moisés estava no monte recebendo a Lei?", options: ["Construiu o tabernáculo", "Fez um bezerro de ouro para adorar", "Descansou e esperou", "Lutou contra inimigos"], correctIndex: 1, explanation: "O povo pediu a Arão que fizesse deuses para guiá-los, e Arão fez um bezerro de ouro (Êxodo 32:1,4)."),
                TrailQuestion(id: 1104, question: "Quantos dias Moisés ficou no monte com Deus?", options: ["7 dias", "20 dias", "30 dias", "40 dias"], correctIndex: 3, explanation: "Moisés estava no monte quarenta dias e quarenta noites (Êxodo 24:18)."),
                TrailQuestion(id: 1105, question: "O que Moisés fez quando desceu do monte e viu o povo adorando o bezerro de ouro?", options: ["Orou em silêncio", "Chamou os sacerdotes para punir o povo", "Quebrou as tábuas da lei no chão", "Fugiu de volta ao deserto"], correctIndex: 2, explanation: "Ardeu a ira de Moisés, e lançou as tábuas das mãos e as quebrou ao pé do monte (Êxodo 32:19)."),
            ],
            status: .locked
        ),

        TrailNodeData(
            id: 12,
            title: "Josué e Canaã",
            subtitle: "A Terra Prometida",
            emoji: "🏹",
            reference: "Josué 1–6",
            studyText: """
            Após a morte de Moisés, Deus chamou Josué para liderar Israel na conquista da Terra Prometida. Deus encorajou Josué três vezes com as mesmas palavras: "Sê forte e corajoso." Prometeu que estaria com ele em todos os lugares para onde fosse, assim como estivera com Moisés.

            O primeiro grande obstáculo foi o Rio Jordão, que estava transbordando na época da colheita. Deus ordenou que os sacerdotes carregando a Arca da Aliança entrassem no rio primeiro. Quando os pés dos sacerdotes tocaram as águas, o rio se dividiu e todo o povo atravessou em terra seca — um milagre semelhante à travessia do Mar Vermelho.

            A primeira cidade a ser conquistada foi Jericó, a cidade mais fortemente murada de Canaã. Deus deu a Josué uma estratégia inusitada: os israelitas marchariam em silêncio ao redor da cidade uma vez por dia durante seis dias. No sétimo dia, marchariam sete vezes, os sacerdotes tocariam as trombetas e todo o povo gritaria. Quando fizeram isso, as muralhas de Jericó desabaram. A vitória pertencia ao Senhor.
            """,
            keyVerses: [
                TrailVerse(text: "Não to mandei eu? Sê forte e corajoso; não temas, nem te espantes, porque o Senhor teu Deus é contigo por onde quer que andares.", reference: "Josué 1:9"),
                TrailVerse(text: "E sucedeu que, ouvindo o povo o som da trombeta, e gritando o povo com grande grito, o muro caiu por terra.", reference: "Josué 6:20"),
            ],
            questions: [
                TrailQuestion(id: 1201, question: "Quem sucedeu Moisés como líder de Israel?", options: ["Calebe", "Arão", "Josué", "Fineias"], correctIndex: 2, explanation: "Após a morte de Moisés, Deus disse a Josué: 'Levanta-te, passa este Jordão, tu e todo este povo' (Josué 1:2)."),
                TrailQuestion(id: 1202, question: "Como os israelitas atravessaram o Rio Jordão?", options: ["Nadaram com os animais", "Usaram balsas de madeira", "As águas se dividiram quando os sacerdotes pisaram", "Esperaram as águas baixarem por 40 dias"], correctIndex: 2, explanation: "As águas que vinham de cima pararam quando os pés dos sacerdotes tocaram o Jordão, e o povo atravessou em terra seca (Josué 3:15-17)."),
                TrailQuestion(id: 1203, question: "Qual foi a primeira cidade conquistada por Josué em Canaã?", options: ["Ai", "Jericó", "Hebrom", "Gabaão"], correctIndex: 1, explanation: "Jericó foi a primeira cidade a ser cercada e conquistada pelo povo de Israel sob Josué (Josué 6)."),
                TrailQuestion(id: 1204, question: "Quantas vezes ao total os israelitas marcharam ao redor de Jericó?", options: ["7 vezes", "10 vezes", "13 vezes", "40 vezes"], correctIndex: 2, explanation: "Eles marcharam uma vez por dia durante 6 dias (= 6 voltas) e no 7º dia marcharam 7 vezes. Total: 6 + 7 = 13 vezes ao redor de Jericó (Josué 6:14-15)."),
                TrailQuestion(id: 1205, question: "Como as muralhas de Jericó caíram?", options: ["Foram derrubadas por aríetes", "Desabaram com trovões e raios", "Caíram quando o povo tocou trombetas e gritou", "Foram minadas por baixo da terra"], correctIndex: 2, explanation: "Quando o povo ouviu o som das trombetas e gritou com grande grito, o muro caiu por terra (Josué 6:20)."),
            ],
            status: .locked
        ),
    ]
}
