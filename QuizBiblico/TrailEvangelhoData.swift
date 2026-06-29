import Foundation

enum EvangelhoData {
    static let nodes: [TrailNodeData] = [

        TrailNodeData(
            id: 1,
            title: "O Anúncio",
            subtitle: "Gabriel visita Maria",
            emoji: "🕊️",
            reference: "Lucas 1:26–38",
            studyText: """
            No sexto mês da gravidez de Isabel, Deus enviou o anjo Gabriel a Nazaré, cidade da Galileia, a uma virgem chamada Maria, que estava noiva de um homem chamado José, da casa de Davi. Gabriel entrou e disse: "Alegra-te, Maria, tens a graça de Deus. O Senhor está contigo."

            Maria ficou perturbada. O anjo a tranquilizou: "Não temas, pois achaste graça diante de Deus. Conceberás um filho, e lhe porás o nome de Jesus. Ele será grande, e chamar-se-á Filho do Altíssimo." Maria perguntou: "Como se fará isso, visto que não conheço homem?" Gabriel respondeu que o Espírito Santo viria sobre ela e o poder do Altíssimo a cobriria com sua sombra — por isso o Santo que havia de nascer seria chamado Filho de Deus.

            O anjo também revelou que sua prima Isabel, tida como estéril, já estava grávida há seis meses, pois nada é impossível para Deus. Diante disso, Maria respondeu com total confiança e humildade: "Eis aqui a serva do Senhor. Faça-se em mim segundo a tua palavra." E o anjo partiu.
            """,
            keyVerses: [
                TrailVerse(text: "Alegra-te, muito favorecida! O Senhor está contigo.", reference: "Lucas 1:28"),
                TrailVerse(text: "Eis aqui a serva do Senhor. Faça-se em mim segundo a tua palavra.", reference: "Lucas 1:38"),
                TrailVerse(text: "Porque para Deus não há nada impossível.", reference: "Lucas 1:37"),
            ],
            questions: [
                TrailQuestion(id: 2001, question: "Qual anjo foi enviado por Deus a Maria?", options: ["Miguel", "Rafael", "Gabriel", "Uriel"], correctIndex: 2, explanation: "Deus enviou o anjo Gabriel à cidade de Nazaré para anunciar a Maria o nascimento de Jesus (Lucas 1:26)."),
                TrailQuestion(id: 2002, question: "Em que cidade vivia Maria quando Gabriel a visitou?", options: ["Belém", "Jerusalém", "Hebrom", "Nazaré"], correctIndex: 3, explanation: "Gabriel foi enviado a uma cidade da Galileia chamada Nazaré (Lucas 1:26)."),
                TrailQuestion(id: 2003, question: "Com quem Maria estava noiva?", options: ["João", "Levi", "José", "Simeão"], correctIndex: 2, explanation: "Maria era noiva de um homem chamado José, da casa de Davi (Lucas 1:27)."),
                TrailQuestion(id: 2004, question: "O que Maria respondeu ao anúncio do anjo?", options: ["Recusou com medo", "Pediu um sinal primeiro", "Eis aqui a serva do Senhor", "Nada — ficou em silêncio"], correctIndex: 2, explanation: "Maria respondeu com fé: 'Eis aqui a serva do Senhor; faça-se em mim segundo a tua palavra' (Lucas 1:38)."),
                TrailQuestion(id: 2005, question: "Qual outro nascimento milagroso Gabriel mencionou para encorajar Maria?", options: ["O nascimento de Moisés", "O nascimento de Sansão", "O nascimento de Samuel", "O nascimento de João Batista por Isabel"], correctIndex: 3, explanation: "Gabriel revelou que Isabel, prima de Maria, já estava grávida de seis meses, sendo que ela era considerada estéril (Lucas 1:36)."),
            ],
            status: .available
        ),

        TrailNodeData(
            id: 2,
            title: "O Nascimento",
            subtitle: "Jesus nasce em Belém",
            emoji: "🌟",
            reference: "Lucas 2:1–20; Mateus 2:1–12",
            studyText: """
            Por decreto do imperador Augusto, José e Maria viajaram de Nazaré para Belém, cidade de Davi, para o recenseamento. Enquanto estavam lá, chegou o tempo do parto. Maria deu à luz seu filho primogênito, envolveu-o em faixas e o deitou numa manjedoura, pois não havia lugar para eles na hospedaria.

            Naquela mesma noite, nas cercanias de Belém, pastores vigiavam seus rebanhos. O anjo do Senhor apareceu a eles com grande glória, e eles ficaram com muito medo. Mas o anjo disse: "Não temais; eis que vos trago uma boa notícia de grande alegria para todo o povo: hoje nasceu para vós, na cidade de Davi, um Salvador, que é Cristo, o Senhor." Os pastores foram a Belém e encontraram o menino na manjedoura — o primeiro sinal dado pelo anjo. Depois glorificaram a Deus.

            Magos do Oriente também vieram a Belém, guiados por uma estrela. Encontraram Jesus com Maria e prostraram-se diante dele, oferecendo ouro, incenso e mirra. Avisados em sonho a não voltarem a Herodes, partiram por outro caminho. José também foi avisado em sonho e fugiu com Maria e Jesus para o Egito.
            """,
            keyVerses: [
                TrailVerse(text: "Hoje nasceu para vós, na cidade de Davi, um Salvador, que é Cristo, o Senhor.", reference: "Lucas 2:11"),
                TrailVerse(text: "E ela deu à luz o seu filho primogênito e o envolveu em faixas, e o deitou numa manjedoura.", reference: "Lucas 2:7"),
                TrailVerse(text: "Glória a Deus nas alturas, e paz na terra entre os homens de boa vontade.", reference: "Lucas 2:14"),
            ],
            questions: [
                TrailQuestion(id: 2101, question: "Em que cidade Jesus nasceu?", options: ["Nazaré", "Jericó", "Belém", "Jerusalém"], correctIndex: 2, explanation: "Jesus nasceu em Belém da Judeia, na cidade de Davi, conforme o decreto de recenseamento (Lucas 2:4,6–7)."),
                TrailQuestion(id: 2102, question: "Onde o menino Jesus foi deitado logo após o nascimento?", options: ["Num berço de madeira", "Numa manjedoura", "Num tapete de palha", "Num cesto de junco"], correctIndex: 1, explanation: "Maria envolveu Jesus em faixas e o deitou numa manjedoura, pois não havia lugar para eles na hospedaria (Lucas 2:7)."),
                TrailQuestion(id: 2103, question: "Quem foram os primeiros a receber o anúncio do nascimento de Jesus?", options: ["Os magos do Oriente", "Os sacerdotes do templo", "Os pastores nos campos", "Os escribas de Jerusalém"], correctIndex: 2, explanation: "O anjo apareceu aos pastores que vigiavam seus rebanhos nos campos próximos a Belém (Lucas 2:8–10)."),
                TrailQuestion(id: 2104, question: "O que os magos trouxeram de presente ao menino Jesus?", options: ["Pão, vinho e azeite", "Ouro, incenso e mirra", "Linho, especiarias e prata", "Pombas, trigo e mel"], correctIndex: 1, explanation: "Os magos abriram os seus tesouros e ofereceram a Jesus ouro, incenso e mirra (Mateus 2:11)."),
                TrailQuestion(id: 2105, question: "Para onde José e Maria fugiram com Jesus após a visita dos magos?", options: ["Para a Galileia", "Para a Síria", "Para o Egito", "Para a Jordânia"], correctIndex: 2, explanation: "O anjo do Senhor apareceu a José em sonho e lhe ordenou que fugisse para o Egito com o menino e sua mãe (Mateus 2:13)."),
            ],
            status: .locked
        ),

        TrailNodeData(
            id: 3,
            title: "O Batismo",
            subtitle: "Jesus é batizado por João",
            emoji: "💧",
            reference: "Mateus 3:13–17",
            studyText: """
            João Batista pregava no deserto da Judeia, chamando o povo ao arrependimento e batizando no rio Jordão. Ele anunciava: "Arrependei-vos, porque está próximo o reino dos céus." Quando Jesus veio da Galileia ao Jordão para ser batizado por João, João tentou impedi-lo dizendo: "Sou eu que preciso ser batizado por ti, e tu vens a mim?"

            Jesus respondeu: "Deixa por agora, porque assim nos convém cumprir toda a justiça." Então João o batizou. No momento em que Jesus saía da água, os céus se abriram e ele viu o Espírito de Deus descendo sobre ele como uma pomba. E uma voz do céu disse: "Este é o meu Filho amado, em quem me compraço."

            O batismo de Jesus marcou o início público de seu ministério. Ele não foi batizado por precisar de arrependimento — sendo sem pecado — mas para se identificar com a humanidade que veio salvar, para cumprir toda a justiça e para que fosse revelado a Israel como o Messias, o Filho de Deus ungido pelo Espírito Santo.
            """,
            keyVerses: [
                TrailVerse(text: "Este é o meu Filho amado, em quem me compraço.", reference: "Mateus 3:17"),
                TrailVerse(text: "Vi o Espírito descer do céu como pomba e pousar sobre ele.", reference: "João 1:32"),
                TrailVerse(text: "Deixa por agora, porque assim nos convém cumprir toda a justiça.", reference: "Mateus 3:15"),
            ],
            questions: [
                TrailQuestion(id: 2201, question: "Quem batizou Jesus no rio Jordão?", options: ["Pedro", "Elias", "João Batista", "Simeão"], correctIndex: 2, explanation: "Jesus veio da Galileia ao Jordão para ser batizado por João Batista (Mateus 3:13)."),
                TrailQuestion(id: 2202, question: "Como o Espírito Santo se manifestou no batismo de Jesus?", options: ["Como uma chama de fogo", "Como uma pomba descendo", "Como uma voz trovejante", "Como uma nuvem brilhante"], correctIndex: 1, explanation: "O Espírito de Deus desceu sobre Jesus como uma pomba após ele sair da água (Mateus 3:16)."),
                TrailQuestion(id: 2203, question: "O que a voz do céu disse no batismo de Jesus?", options: ["Este é o profeta que devia vir ao mundo", "Este é meu Filho amado, em quem me compraço", "Eis o Cordeiro de Deus que tira o pecado do mundo", "Ele deve crescer e eu devo diminuir"], correctIndex: 1, explanation: "Uma voz dos céus disse: 'Este é o meu Filho amado, em quem me compraço' (Mateus 3:17)."),
                TrailQuestion(id: 2204, question: "Por que João hesitou em batizar Jesus?", options: ["Porque não conhecia Jesus", "Porque Jesus era muito famoso", "Porque João se sentia indigno", "Porque o local era perigoso"], correctIndex: 2, explanation: "João disse que precisava ser batizado por Jesus, e não o contrário — reconhecendo a superioridade de Jesus (Mateus 3:14)."),
                TrailQuestion(id: 2205, question: "O que Jesus respondeu quando João hesitou em batizá-lo?", options: ["Obedeça sem questionar", "Deixa por agora; assim convém cumprir toda a justiça", "João, teu batismo não tem valor para mim", "Faça isso em segredo, sem que ninguém veja"], correctIndex: 1, explanation: "Jesus disse a João: 'Deixa por agora, porque assim nos convém cumprir toda a justiça' (Mateus 3:15)."),
            ],
            status: .locked
        ),

        TrailNodeData(
            id: 4,
            title: "As Tentações",
            subtitle: "Jesus no deserto",
            emoji: "⚔️",
            reference: "Mateus 4:1–11",
            studyText: """
            Logo após o batismo, o Espírito levou Jesus ao deserto para ser tentado pelo diabo. Jesus jejuou quarenta dias e quarenta noites, e depois ficou com fome. O tentador então se aproximou com três tentações específicas.

            A primeira: "Se és Filho de Deus, manda que estas pedras se tornem pão." Jesus respondeu com a Escritura: "Nem só de pão viverá o homem, mas de toda palavra que sai da boca de Deus." A segunda: o diabo levou-o ao pináculo do templo e desafiou-o a se lançar, citando o próprio Salmo 91. Jesus respondeu: "Não tentarás o Senhor teu Deus." A terceira: o diabo levou-o a um monte muito alto, mostrou-lhe todos os reinos do mundo e disse: "Tudo isso te darei, se, prostrado, me adorares." Jesus ordenou: "Arreda, Satanás! Porque está escrito: Ao Senhor teu Deus adorarás e só a ele servirás."

            Derrotado em todas as tentações, o diabo o deixou, e anjos vieram e serviam a Jesus. Essa vitória no deserto revelou que Jesus era o verdadeiro Israel — onde Israel falhou ao longo de quarenta anos no deserto, Jesus triunfou em quarenta dias, dependendo completamente da Palavra de Deus.
            """,
            keyVerses: [
                TrailVerse(text: "Nem só de pão viverá o homem, mas de toda palavra que sai da boca de Deus.", reference: "Mateus 4:4"),
                TrailVerse(text: "Ao Senhor teu Deus adorarás e só a ele servirás.", reference: "Mateus 4:10"),
                TrailVerse(text: "Então o diabo o deixou, e eis que anjos vieram e o serviam.", reference: "Mateus 4:11"),
            ],
            questions: [
                TrailQuestion(id: 2301, question: "Quantos dias Jesus jejuou no deserto antes das tentações?", options: ["7 dias", "21 dias", "30 dias", "40 dias"], correctIndex: 3, explanation: "Jesus jejuou quarenta dias e quarenta noites no deserto (Mateus 4:2)."),
                TrailQuestion(id: 2302, question: "Qual foi a primeira tentação de Satanás?", options: ["Lançar-se do templo", "Adorar Satanás por todos os reinos", "Transformar pedras em pão", "Usar seu poder para escapar do deserto"], correctIndex: 2, explanation: "Satanás disse: 'Se és Filho de Deus, manda que estas pedras se tornem pão' (Mateus 4:3)."),
                TrailQuestion(id: 2303, question: "Para onde Satanás levou Jesus na segunda tentação?", options: ["Para um monte muito alto", "Para o deserto do Negueve", "Para o pináculo do templo", "Para as margens do Mar Morto"], correctIndex: 2, explanation: "O diabo levou Jesus à cidade santa e o colocou no pináculo do templo (Mateus 4:5)."),
                TrailQuestion(id: 2304, question: "O que Satanás prometeu a Jesus na terceira tentação?", options: ["Imortalidade e saúde eterna", "Todos os reinos do mundo e a sua glória", "A ressurreição antecipada de todos os justos", "O poder de fazer qualquer milagre"], correctIndex: 1, explanation: "Satanás mostrou a Jesus todos os reinos do mundo e disse: 'Tudo isso te darei, se, prostrado, me adorares' (Mateus 4:8–9)."),
                TrailQuestion(id: 2305, question: "O que aconteceu depois que o diabo deixou Jesus?", options: ["Jesus voltou imediatamente para Nazaré", "Jesus dormiu por três dias", "Anjos vieram e o serviam", "Uma voz do céu o declarou Filho de Deus"], correctIndex: 2, explanation: "Depois que o diabo partiu, anjos vieram e serviam a Jesus (Mateus 4:11)."),
            ],
            status: .locked
        ),

        TrailNodeData(
            id: 5,
            title: "Sermão da Montanha",
            subtitle: "As Bem-aventuranças",
            emoji: "⛰️",
            reference: "Mateus 5–7",
            studyText: """
            Jesus subiu ao monte e seus discípulos se aproximaram. Ele começou a ensiná-los com as Bem-aventuranças — oito declarações de bênção que descrevem o caráter do cidadão do reino dos céus. Entre elas: "Bem-aventurados os pobres de espírito, porque deles é o reino dos céus" e "Bem-aventurados os pacificadores, porque eles serão chamados filhos de Deus."

            Jesus também ensinou que seus seguidores são sal da terra e luz do mundo. Ele não veio abolir a Lei, mas cumpri-la. Aprofundou vários mandamentos: raiva é como homicídio, olhar com cobiça é adultério no coração. Ensinou a amar os inimigos e a perdoar.

            No mesmo sermão, Jesus deu o Pai Nosso como modelo de oração, ensinou a não acumular tesouros na terra, a não se preocupar com o amanhã ("Buscai primeiro o reino de Deus"), e a não julgar ao próximo. Terminou com a parábola do construtor sábio que edifica sobre a rocha. O povo ficou admirado com seu ensinamento, porque ele ensinava como quem tem autoridade, e não como os escribas.
            """,
            keyVerses: [
                TrailVerse(text: "Bem-aventurados os pobres de espírito, porque deles é o reino dos céus.", reference: "Mateus 5:3"),
                TrailVerse(text: "Buscai, pois, em primeiro lugar o reino de Deus e a sua justiça, e todas estas coisas vos serão acrescentadas.", reference: "Mateus 6:33"),
                TrailVerse(text: "Vós sois a luz do mundo; não se pode esconder uma cidade edificada sobre um monte.", reference: "Mateus 5:14"),
            ],
            questions: [
                TrailQuestion(id: 2401, question: "Com que palavras começa a primeira Bem-aventurança?", options: ["Bem-aventurados os misericordiosos", "Bem-aventurados os que choram", "Bem-aventurados os pobres de espírito", "Bem-aventurados os mansos"], correctIndex: 2, explanation: "A primeira Bem-aventurança é: 'Bem-aventurados os pobres de espírito, porque deles é o reino dos céus' (Mateus 5:3)."),
                TrailQuestion(id: 2402, question: "Como Jesus chamou seus discípulos em relação ao mundo?", options: ["Líderes e governantes", "Sal da terra e luz do mundo", "Soldados e servos", "Filósofos e mestres"], correctIndex: 1, explanation: "Jesus disse: 'Vós sois o sal da terra' e 'Vós sois a luz do mundo' (Mateus 5:13–14)."),
                TrailQuestion(id: 2403, question: "Qual é a primeira petição do Pai Nosso, conforme Mateus 6?", options: ["Dá-nos hoje o nosso pão de cada dia", "Venha o teu reino", "Perdoa-nos as nossas dívidas", "Santificado seja o teu nome"], correctIndex: 3, explanation: "O Pai Nosso começa: 'Pai nosso que estás nos céus, santificado seja o teu nome' (Mateus 6:9)."),
                TrailQuestion(id: 2404, question: "O que Jesus ensinou sobre o julgamento de outros?", options: ["Julgai com sabedoria e moderação", "Não julgueis para que não sejais julgados", "Julgai apenas os que têm poder", "Deixai o julgamento aos sacerdotes"], correctIndex: 1, explanation: "Jesus ensinou: 'Não julgueis, para que não sejais julgados' (Mateus 7:1)."),
                TrailQuestion(id: 2405, question: "Na parábola final do Sermão, sobre o que o sábio construiu sua casa?", options: ["Sobre areia fina", "Sobre madeira resistente", "Sobre a rocha", "Sobre pilares de pedra"], correctIndex: 2, explanation: "O homem sábio edificou a sua casa sobre a rocha; veio a chuva, os rios, os ventos e a casa não caiu (Mateus 7:24–25)."),
            ],
            status: .locked
        ),

        TrailNodeData(
            id: 6,
            title: "Os Milagres",
            subtitle: "Sinais do Reino de Deus",
            emoji: "🙌",
            reference: "João 2; Mateus 14; João 11",
            studyText: """
            O primeiro milagre de Jesus aconteceu num casamento em Caná da Galileia. Quando o vinho acabou, Maria pediu a Jesus que interviesse. Ele mandou encher de água seis talhas de pedra usadas para purificações judaicas. Quando a água foi tirada, tinha se transformado em vinho excelente. Esse foi o primeiro de seus sinais, e seus discípulos creram nele.

            Ao longo de seu ministério, Jesus realizou inúmeros milagres: curou leprosos, paralíticos, cegos e surdos; expulsou demônios; acalmou uma tempestade no Mar da Galileia; e andou sobre as águas. Um dos maiores sinais foi a alimentação de cinco mil homens (além de mulheres e crianças) com apenas cinco pães e dois peixes — sobraram ainda doze cestos cheios.

            O maior de todos os sinais foi a ressurreição de Lázaro, que estava morto há quatro dias. Ao se aproximar do sepulcro, Jesus chorou — a cena mais curta da Bíblia: "Jesus chorou." Então ordenou em voz alta: "Lázaro, vem para fora!" e o morto saiu. Esse milagre levou muitos a crer nele, mas também provocou a decisão dos líderes religiosos de matá-lo.
            """,
            keyVerses: [
                TrailVerse(text: "Este princípio de sinais fez Jesus em Caná da Galileia e manifestou a sua glória; e os seus discípulos creram nele.", reference: "João 2:11"),
                TrailVerse(text: "Jesus chorou.", reference: "João 11:35"),
                TrailVerse(text: "Lázaro, vem para fora!", reference: "João 11:43"),
            ],
            questions: [
                TrailQuestion(id: 2501, question: "Onde ocorreu o primeiro milagre de Jesus?", options: ["No templo de Jerusalém", "Nas margens do Jordão", "Em Caná da Galileia", "Em Cafarnaum"], correctIndex: 2, explanation: "Jesus transformou água em vinho num casamento em Caná da Galileia — seu primeiro sinal (João 2:11)."),
                TrailQuestion(id: 2502, question: "Quantos pães e peixes Jesus usou para alimentar a multidão?", options: ["10 pães e 4 peixes", "7 pães e 3 peixes", "5 pães e 2 peixes", "3 pães e 1 peixe"], correctIndex: 2, explanation: "Jesus pegou cinco pães e dois peixes, olhou para o céu, abençoou e alimentou cerca de cinco mil homens (Mateus 14:17–21)."),
                TrailQuestion(id: 2503, question: "Sobre que água Jesus andou milagrosamente?", options: ["Rio Jordão", "Mar Mediterrâneo", "Mar Morto", "Mar da Galileia"], correctIndex: 3, explanation: "Jesus foi ao encontro dos discípulos andando sobre o Mar da Galileia (Mateus 14:25)."),
                TrailQuestion(id: 2504, question: "Quantos dias Lázaro estava morto quando Jesus chegou?", options: ["1 dia", "2 dias", "3 dias", "4 dias"], correctIndex: 3, explanation: "Quando Jesus chegou, Lázaro estava no sepulcro havia quatro dias (João 11:17)."),
                TrailQuestion(id: 2505, question: "O que Jesus disse antes de ressuscitar Lázaro?", options: ["Levanta-te e anda!", "Em nome de Deus, sai do sepulcro", "Lázaro, vem para fora!", "Pelo poder do Pai, ressuscita!"], correctIndex: 2, explanation: "Jesus clamou em alta voz: 'Lázaro, vem para fora!' e o morto saiu (João 11:43)."),
            ],
            status: .locked
        ),

        TrailNodeData(
            id: 7,
            title: "A Transfiguração",
            subtitle: "A glória revelada",
            emoji: "✨",
            reference: "Mateus 17:1–9",
            studyText: """
            Seis dias após Pedro confessar que Jesus era o Cristo, Jesus tomou Pedro, Tiago e João e os levou a um monte alto, à parte. Lá ele foi transfigurado diante deles: seu rosto resplandeceu como o sol e suas vestes se tornaram brancas como a luz. Dois personagens do Antigo Testamento apareceram falando com ele: Moisés e Elias.

            Pedro, sem saber o que falar, propôs construir três tendas — uma para Jesus, uma para Moisés e uma para Elias. Enquanto ainda falava, uma nuvem luminosa os envolveu e uma voz disse: "Este é o meu Filho amado, em quem me compraço; a ele ouvi." Ao ouvirem isso, os três discípulos caíram com o rosto em terra, cheios de temor. Jesus veio, tocou-os e disse: "Levantai-vos e não temais."

            Quando ergueram os olhos, não viram mais ninguém, senão Jesus sozinho. Descendo o monte, Jesus ordenou que não contassem a ninguém o que tinham visto até que o Filho do Homem ressuscitasse dos mortos. A Transfiguração confirmou a divindade de Jesus, revelando sua glória eterna que estava velada em sua humanidade.
            """,
            keyVerses: [
                TrailVerse(text: "E foi transfigurado diante deles; o seu rosto resplandeceu como o sol, e as suas vestes se tornaram brancas como a luz.", reference: "Mateus 17:2"),
                TrailVerse(text: "Este é o meu Filho amado, em quem me comprazo; a ele ouvi.", reference: "Mateus 17:5"),
                TrailVerse(text: "Levantai-vos e não temais.", reference: "Mateus 17:7"),
            ],
            questions: [
                TrailQuestion(id: 2601, question: "Quais três discípulos subiram com Jesus ao monte da Transfiguração?", options: ["André, Filipe e Bartolomeu", "Pedro, Tiago e João", "Pedro, João e Tomé", "Tiago, João e Judas"], correctIndex: 1, explanation: "Jesus tomou consigo Pedro, Tiago e João e os levou a um monte alto (Mateus 17:1)."),
                TrailQuestion(id: 2602, question: "Como ficou o rosto de Jesus durante a Transfiguração?", options: ["Escondido por uma nuvem", "Resplandeceu como o sol", "Tornou-se invisível", "Ficou pálido como a neve"], correctIndex: 1, explanation: "O rosto de Jesus resplandeceu como o sol e suas vestes se tornaram brancas como a luz (Mateus 17:2)."),
                TrailQuestion(id: 2603, question: "Quais dois personagens do Antigo Testamento apareceram com Jesus?", options: ["Abraão e Davi", "Elias e João Batista", "Moisés e Elias", "Moisés e Enoque"], correctIndex: 2, explanation: "Moisés e Elias apareceram e estavam falando com Jesus (Mateus 17:3)."),
                TrailQuestion(id: 2604, question: "O que Pedro propôs fazer no monte?", options: ["Construir um altar de pedras", "Ficar lá para sempre", "Construir três tendas", "Descer imediatamente e anunciar ao povo"], correctIndex: 2, explanation: "Pedro disse a Jesus: 'Senhor, bom é estarmos aqui; se queres, farei aqui três tendas' (Mateus 17:4)."),
                TrailQuestion(id: 2605, question: "O que a voz da nuvem disse na Transfiguração?", options: ["Este é meu servo escolhido; escutai-o", "Este é o profeta que devia vir", "Este é meu Filho amado, em quem me comprazo; a ele ouvi", "Este é o Cordeiro de Deus que tira o pecado do mundo"], correctIndex: 2, explanation: "Da nuvem luminosa saiu uma voz: 'Este é o meu Filho amado, em quem me comprazo; a ele ouvi' (Mateus 17:5)."),
            ],
            status: .locked
        ),

        TrailNodeData(
            id: 8,
            title: "Entrada em Jerusalém",
            subtitle: "O Domingo de Ramos",
            emoji: "🌿",
            reference: "Mateus 21:1–17",
            studyText: """
            Quando Jesus e seus discípulos se aproximavam de Jerusalém, ele mandou dois discípulos buscar um jumento e seu potro em Betfagé. Disse-lhes que, se alguém perguntasse, deveriam responder: "O Senhor precisa deles." Isso cumpriu a profecia de Zacarias: "Dize à filha de Sião: Eis que o teu Rei vem a ti, manso e montado num jumento."

            Os discípulos estenderam suas vestes sobre o jumento e Jesus montou. Uma grande multidão pôs suas vestes no caminho; outros cortavam ramos de árvores e os espalhavam pela estrada. E a multidão clamava: "Hosana ao Filho de Davi! Bendito o que vem em nome do Senhor! Hosana nas alturas!"

            Ao entrar em Jerusalém, toda a cidade ficou agitada, perguntando quem era ele. Logo após, Jesus entrou no templo e expulsou todos os que vendiam e compravam lá, e derrubou as mesas dos cambistas e as cadeiras dos que vendiam pombas, dizendo: "A minha casa será chamada casa de oração, mas vós a estais transformando em covil de ladrões." Cegos e coxos foram a ele no templo e ele os curou.
            """,
            keyVerses: [
                TrailVerse(text: "Hosana ao Filho de Davi! Bendito o que vem em nome do Senhor!", reference: "Mateus 21:9"),
                TrailVerse(text: "Dize à filha de Sião: Eis que o teu Rei vem a ti, humilde, montado num jumento.", reference: "Mateus 21:5"),
                TrailVerse(text: "A minha casa será chamada casa de oração, mas vós a estais transformando em covil de ladrões.", reference: "Mateus 21:13"),
            ],
            questions: [
                TrailQuestion(id: 2701, question: "Em que animal Jesus entrou em Jerusalém?", options: ["Um cavalo branco", "Um camelo", "Um jumento e seu potro", "Um bezerro"], correctIndex: 2, explanation: "Jesus montou num jumento e seu potro, cumprindo a profecia de Zacarias (Mateus 21:7)."),
                TrailQuestion(id: 2702, question: "O que o povo estendia no caminho ao receber Jesus?", options: ["Flores e incenso", "Suas vestes e ramos de árvores", "Tapetes coloridos e ouro", "Pão e vinho"], correctIndex: 1, explanation: "A multidão estendia suas vestes no caminho; outros cortavam ramos de árvores e os espalhavam (Mateus 21:8)."),
                TrailQuestion(id: 2703, question: "Que aclamação a multidão fez ao ver Jesus entrar em Jerusalém?", options: ["Santo, Santo, Santo é o Senhor!", "Glória nas alturas!", "Hosana ao Filho de Davi!", "Bendito o profeta de Israel!"], correctIndex: 2, explanation: "A multidão clamava: 'Hosana ao Filho de Davi! Bendito o que vem em nome do Senhor!' (Mateus 21:9)."),
                TrailQuestion(id: 2704, question: "Que profeta havia predito a entrada triunfal em Jerusalém?", options: ["Isaías", "Jeremias", "Ezequiel", "Zacarias"], correctIndex: 3, explanation: "A entrada de Jesus cumpriu a profecia de Zacarias: 'Eis que o teu Rei vem a ti, humilde, montado num jumento' (Mateus 21:5; Zacarias 9:9)."),
                TrailQuestion(id: 2705, question: "O que Jesus fez ao chegar ao templo em Jerusalém?", options: ["Ensinou por sete dias seguidos", "Expulsou os vendedores e derrubou as mesas dos cambistas", "Se prostrou em oração diante de todos", "Anunciou o fim do templo"], correctIndex: 1, explanation: "Jesus expulsou os que vendiam e compravam no templo e derrubou as mesas dos cambistas, pois a casa de oração havia se tornado covil de ladrões (Mateus 21:12–13)."),
            ],
            status: .locked
        ),

        TrailNodeData(
            id: 9,
            title: "A Última Ceia",
            subtitle: "A ceia do Senhor",
            emoji: "🍞",
            reference: "Mateus 26:17–75; Lucas 22",
            studyText: """
            Na noite antes de sua crucificação, Jesus reuniu seus doze discípulos para a Páscoa. Durante a ceia, Jesus tomou o pão, abençoou, partiu e deu aos discípulos dizendo: "Tomai, comei; isto é o meu corpo." Depois tomou o cálice, deu graças e o deu a eles, dizendo: "Bebei dele todos; porque isto é o meu sangue do novo pacto, que é derramado em favor de muitos para remissão dos pecados."

            Jesus também revelou que um deles o trairia. Cada um começou a perguntar: "Sou eu, Senhor?" Jesus disse que era aquele que havia molhado a mão no prato com ele. Judas Iscariotes já havia combinado com os líderes religiosos trair Jesus por trinta moedas de prata.

            Após a ceia, Jesus foi ao Jardim de Getsêmani, onde orou em grande angústia: "Pai, se possível, passe de mim este cálice; todavia, não seja como eu quero, mas como tu queres." Sua suor caía como grandes gotas de sangue. Os discípulos dormiam enquanto ele orava. À meia-noite, Judas chegou com uma multidão armada e deu o sinal combinado: um beijo. Jesus foi preso. Pedro o negou três vezes antes de o galo cantar, como Jesus havia predito.
            """,
            keyVerses: [
                TrailVerse(text: "Isto é o meu corpo... Isto é o meu sangue do novo pacto, que é derramado em favor de muitos para remissão dos pecados.", reference: "Mateus 26:26,28"),
                TrailVerse(text: "Pai, se possível, passe de mim este cálice; todavia, não seja como eu quero, mas como tu queres.", reference: "Mateus 26:39"),
                TrailVerse(text: "Fazei isto em memória de mim.", reference: "Lucas 22:19"),
            ],
            questions: [
                TrailQuestion(id: 2801, question: "O que o pão partido na Última Ceia representava?", options: ["A aliança com Abraão", "O corpo de Cristo", "O pão da Páscoa judaica", "O pão do deserto dado a Moisés"], correctIndex: 1, explanation: "Jesus disse: 'Tomai, comei; isto é o meu corpo' ao partir o pão (Mateus 26:26)."),
                TrailQuestion(id: 2802, question: "Por quantas moedas Judas vendeu Jesus aos líderes religiosos?", options: ["10 moedas de ouro", "20 moedas de prata", "30 moedas de prata", "50 moedas de bronze"], correctIndex: 2, explanation: "Os príncipes dos sacerdotes pagaram a Judas trinta moedas de prata para entregar Jesus (Mateus 26:15)."),
                TrailQuestion(id: 2803, question: "Onde Jesus foi orar após a Última Ceia?", options: ["No monte das Oliveiras", "No templo de Jerusalém", "No Jardim de Getsêmani", "Em Betânia"], correctIndex: 2, explanation: "Após a ceia, Jesus foi com seus discípulos ao Jardim de Getsêmani para orar (Mateus 26:36)."),
                TrailQuestion(id: 2804, question: "Qual sinal Judas usou para identificar Jesus aos soldados?", options: ["Apontou para ele com o dedo", "Gritou o nome de Jesus", "Deu-lhe um beijo", "Rasgou suas vestes"], correctIndex: 2, explanation: "Judas combinou com os guardas que aquele a quem ele beijasse era Jesus. Veio e lhe disse: 'Salve, Mestre!' e o beijou (Mateus 26:48–49)."),
                TrailQuestion(id: 2805, question: "Quantas vezes Pedro negou conhecer Jesus naquela noite?", options: ["1 vez", "2 vezes", "3 vezes", "4 vezes"], correctIndex: 2, explanation: "Pedro negou conhecer Jesus três vezes, exatamente como Jesus havia predito — antes de o galo cantar (Mateus 26:75)."),
            ],
            status: .locked
        ),

        TrailNodeData(
            id: 10,
            title: "A Crucificação",
            subtitle: "O sacrifício do Filho de Deus",
            emoji: "✝️",
            reference: "Mateus 27; Lucas 23; João 19",
            studyText: """
            Após ser preso, Jesus foi levado a Pilatos, o governador romano. Pilatos não encontrou nenhuma culpa nele e tentou libertá-lo, mas a multidão, instigada pelos líderes religiosos, gritou: "Crucifica-o!" Pilatos lavou as mãos diante da multidão e entregou Jesus para ser crucificado.

            Os soldados o açoitaram, colocaram-lhe uma coroa de espinhos e uma clâmide escarlate, zombando dele: "Salve, Rei dos judeus!" Depois o levaram ao Gólgota — que significa "o lugar da caveira" — onde foi crucificado entre dois ladrões. A inscrição na cruz dizia: "Jesus, o Rei dos Judeus." Na cruz, Jesus disse ao ladrão arrependido: "Hoje estarás comigo no paraíso." Às três horas da tarde, exclamou em alta voz: "Meu Deus, meu Deus, por que me abandonaste?" e entregou o espírito.

            Naquele momento, o véu do templo se rasgou de alto a baixo, a terra tremeu e as pedras se fenderam. O centurião romano que vigiava a crucificação exclamou: "Verdadeiramente este era Filho de Deus!" José de Arimateia pediu o corpo de Jesus a Pilatos e o sepultou numa tumba nova, cavada na rocha.
            """,
            keyVerses: [
                TrailVerse(text: "Pai, perdoa-lhes, porque não sabem o que fazem.", reference: "Lucas 23:34"),
                TrailVerse(text: "Em verdade te digo que hoje estarás comigo no paraíso.", reference: "Lucas 23:43"),
                TrailVerse(text: "Verdadeiramente, este era Filho de Deus!", reference: "Mateus 27:54"),
            ],
            questions: [
                TrailQuestion(id: 2901, question: "Como se chama o lugar onde Jesus foi crucificado?", options: ["Monte Sião", "Betânia", "Gólgota", "Monte das Oliveiras"], correctIndex: 2, explanation: "Jesus foi levado ao Gólgota, que significa 'o lugar da caveira' (Mateus 27:33)."),
                TrailQuestion(id: 2902, question: "O que os soldados puseram na cabeça de Jesus antes da crucificação?", options: ["Uma faixa de linho", "Uma coroa de espinhos", "Um capacete de bronze", "Um turbante real"], correctIndex: 1, explanation: "Os soldados teceram uma coroa de espinhos e a puseram na cabeça de Jesus, zombando dele (Mateus 27:29)."),
                TrailQuestion(id: 2903, question: "O que aconteceu ao véu do templo quando Jesus morreu?", options: ["Foi queimado por um relâmpago", "Desapareceu misteriosamente", "Rasgou-se de alto a baixo, ao meio", "Ficou intacto"], correctIndex: 2, explanation: "E eis que o véu do templo se rasgou em dois, de alto a baixo, e a terra tremeu (Mateus 27:51)."),
                TrailQuestion(id: 2904, question: "Quem pediu a Pilatos o corpo de Jesus para sepultá-lo?", options: ["Pedro e João", "Maria Madalena", "Nicodemos", "José de Arimateia"], correctIndex: 3, explanation: "José de Arimateia, discípulo secreto de Jesus, foi a Pilatos e pediu o corpo de Jesus (Mateus 27:57–58)."),
                TrailQuestion(id: 2905, question: "O que Jesus disse ao ladrão arrependido que estava na cruz ao lado dele?", options: ["Tua fé te salvou — vai em paz", "Hoje estarás comigo no paraíso", "Teus pecados estão perdoados", "Voltarei para te buscar no terceiro dia"], correctIndex: 1, explanation: "Jesus disse ao ladrão: 'Em verdade te digo que hoje estarás comigo no paraíso' (Lucas 23:43)."),
            ],
            status: .locked
        ),

        TrailNodeData(
            id: 11,
            title: "A Ressurreição",
            subtitle: "Cristo ressuscitou!",
            emoji: "🌅",
            reference: "Mateus 28; João 20",
            studyText: """
            Ao amanhecer do primeiro dia da semana, Maria Madalena e as outras mulheres foram ao sepulcro. Houve um grande terremoto: o anjo do Senhor desceu do céu, removeu a pedra e sentou-se sobre ela. Sua aparência era como um relâmpago e sua roupa branca como a neve. Os guardas ficaram como mortos de medo.

            O anjo disse às mulheres: "Não temais; sei que buscais Jesus, que foi crucificado. Não está aqui; ressuscitou, como disse. Vinde ver o lugar onde ele jazia." Elas saíram com medo e grande alegria para contar aos discípulos. A caminho, Jesus as encontrou e disse: "Salve!" Elas abraçaram seus pés e o adoraram.

            Mais tarde, Jesus apareceu a Maria Madalena no jardim, aos discípulos no aposento alto, aos dois discípulos no caminho de Emaús, e ao incrédulo Tomé, a quem disse: "Porque me viste, creste; bem-aventurados os que não viram e creram." Paulo registra que Jesus apareceu a mais de quinhentos irmãos de uma vez. A ressurreição é o fundamento da fé cristã — como disse Paulo: "Se Cristo não ressuscitou, vã é a nossa fé."
            """,
            keyVerses: [
                TrailVerse(text: "Não está aqui; ressuscitou, como disse. Vinde ver o lugar onde ele jazia.", reference: "Mateus 28:6"),
                TrailVerse(text: "Porque me viste, creste; bem-aventurados os que não viram e creram.", reference: "João 20:29"),
                TrailVerse(text: "Eu sou a ressurreição e a vida; quem crê em mim, ainda que esteja morto, viverá.", reference: "João 11:25"),
            ],
            questions: [
                TrailQuestion(id: 3001, question: "Quem foi ao sepulcro bem cedo no domingo de manhã e o encontrou vazio?", options: ["Pedro e Tiago", "Maria, mãe de Jesus", "Maria Madalena e outras mulheres", "Os onze apóstolos juntos"], correctIndex: 2, explanation: "Maria Madalena e a outra Maria foram ver o sepulcro ao amanhecer do primeiro dia da semana (Mateus 28:1)."),
                TrailQuestion(id: 3002, question: "O que o anjo disse às mulheres no sepulcro?", options: ["Jesus ainda não ressuscitou; voltai amanhã", "Não o procureis entre os vivos; ele foi para o céu", "Não está aqui; ressuscitou, como disse", "Jesus está em Getsêmani; ide encontrá-lo"], correctIndex: 2, explanation: "O anjo disse: 'Não temais; sei que buscais Jesus, o crucificado. Não está aqui; ressuscitou, como disse' (Mateus 28:5–6)."),
                TrailQuestion(id: 3003, question: "Qual apóstolo disse que não acreditaria na ressurreição sem ver e tocar as chagas de Jesus?", options: ["Pedro", "André", "Filipe", "Tomé"], correctIndex: 3, explanation: "Tomé disse: 'Se eu não vir nas suas mãos o sinal dos pregos... não crerei' (João 20:25)."),
                TrailQuestion(id: 3004, question: "O que Jesus disse a Tomé após aparecer a ele ressuscitado?", options: ["Tua fé te salvou; nunca mais duvides", "Porque me viste, creste; bem-aventurados os que não viram e creram", "Vai e conta a todos o que viste", "A tua incredulidade foi maior que a tua fé"], correctIndex: 1, explanation: "Jesus disse a Tomé: 'Porque me viste, creste; bem-aventurados os que não viram e creram' (João 20:29)."),
                TrailQuestion(id: 3005, question: "A quantos irmãos de uma vez Paulo diz que Jesus apareceu após a ressurreição?", options: ["12", "70", "120", "Mais de 500"], correctIndex: 3, explanation: "Paulo escreve que Jesus apareceu a mais de quinhentos irmãos de uma vez, dos quais a maioria ainda vivia (1 Coríntios 15:6)."),
            ],
            status: .locked
        ),

        TrailNodeData(
            id: 12,
            title: "A Grande Comissão",
            subtitle: "Ide e fazei discípulos",
            emoji: "🌍",
            reference: "Mateus 28:18–20; Atos 1",
            studyText: """
            Quarenta dias após a ressurreição, Jesus reuniu seus discípulos e deu-lhes a Grande Comissão — o mandato final e definitivo para a Igreja. Ele declarou: "Toda autoridade me foi dada no céu e na terra." Com essa autoridade, ordenou: "Ide, portanto, e fazei discípulos de todas as nações, batizando-os em nome do Pai, e do Filho, e do Espírito Santo, ensinando-os a guardar todas as coisas que vos tenho mandado."

            E então deu a promessa que sustenta cada geração de crentes: "Eis que estou convosco todos os dias, até a consumação dos séculos." A missão era universal — todas as nações — e permanente — até o fim dos tempos. Antes de ascender, Jesus disse que o Espírito Santo viria sobre eles para que fossem testemunhas em Jerusalém, em toda a Judeia, na Samaria e até nos confins da terra.

            Então, à vista dos discípulos, Jesus foi elevado, e uma nuvem o ocultou dos olhos deles. Dois anjos apareceram e disseram: "Este Jesus, que dentre vós foi recebido no céu, há de vir assim como o vistes subir ao céu." Dez dias depois, veio o Pentecostes: o Espírito Santo desceu como línguas de fogo sobre os reunidos no aposento alto. A Igreja nasceu, e a missão começou.
            """,
            keyVerses: [
                TrailVerse(text: "Ide, portanto, e fazei discípulos de todas as nações, batizando-os em nome do Pai, e do Filho, e do Espírito Santo.", reference: "Mateus 28:19"),
                TrailVerse(text: "Eis que estou convosco todos os dias, até a consumação dos séculos.", reference: "Mateus 28:20"),
                TrailVerse(text: "Recebereis poder, ao descer sobre vós o Espírito Santo, e sereis minhas testemunhas.", reference: "Atos 1:8"),
            ],
            questions: [
                TrailQuestion(id: 3101, question: "O que Jesus declarou ter recebido ao dar a Grande Comissão?", options: ["A chave do templo de Jerusalém", "O poder de ressuscitar os mortos", "Toda autoridade no céu e na terra", "A coroa do reino de Israel"], correctIndex: 2, explanation: "Jesus disse: 'Toda autoridade me foi dada no céu e na terra' antes de ordenar que fossem fazer discípulos (Mateus 28:18)."),
                TrailQuestion(id: 3102, question: "Em nome de quem Jesus mandou batizar os novos discípulos?", options: ["Em nome de Jesus Cristo somente", "Em nome do Espírito Santo", "Em nome do Pai, e do Filho, e do Espírito Santo", "Em nome de Deus e dos apóstolos"], correctIndex: 2, explanation: "Jesus mandou batizar em nome do Pai, e do Filho, e do Espírito Santo (Mateus 28:19)."),
                TrailQuestion(id: 3103, question: "Qual promessa Jesus fez ao final da Grande Comissão?", options: ["Voltarei em menos de cem anos", "Eis que estou convosco todos os dias, até a consumação dos séculos", "Enviarei um anjo para proteger cada discípulo", "O mundo inteiro se converterá antes que eu volte"], correctIndex: 1, explanation: "Jesus prometeu: 'Eis que estou convosco todos os dias, até a consumação dos séculos' (Mateus 28:20)."),
                TrailQuestion(id: 3104, question: "O que Jesus disse que os discípulos receberiam quando o Espírito Santo descesse?", options: ["Riquezas e prosperidade", "A cura de todas as doenças", "Poder para serem suas testemunhas", "O dom de falar todas as línguas"], correctIndex: 2, explanation: "Jesus disse: 'Recebereis poder, ao descer sobre vós o Espírito Santo, e sereis minhas testemunhas' (Atos 1:8)."),
                TrailQuestion(id: 3105, question: "Quantos dias após a ressurreição Jesus ascendeu ao céu?", options: ["3 dias", "7 dias", "33 dias", "40 dias"], correctIndex: 3, explanation: "Jesus apareceu aos apóstolos por quarenta dias falando sobre o reino de Deus, e então ascendeu aos céus (Atos 1:3)."),
            ],
            status: .locked
        ),
    ]
}
