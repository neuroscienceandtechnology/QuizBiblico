import Foundation

struct DailyChallenge: Identifiable {
    let id: Int
    let title: String
    let description: String
    let verse: String
    let reference: String
}

let dailyChallenges: [DailyChallenge] = [
    DailyChallenge(id: 1, title: "Gratidão", description: "Escreva 3 coisas pelas quais você é grato a Deus hoje.", verse: "\"Em tudo dai graças, porque esta é a vontade de Deus em Cristo Jesus para convosco.\"", reference: "1 Tessalonicenses 5:18"),
    DailyChallenge(id: 2, title: "Perdão", description: "Pense em alguém que você precisa perdoar e ore por essa pessoa hoje.", verse: "\"Sede bondosos e compassivos uns para com os outros, perdoando-vos mutuamente, assim como Deus vos perdoou em Cristo.\"", reference: "Efésios 4:32"),
    DailyChallenge(id: 3, title: "Bondade", description: "Faça uma ação gentil por alguém hoje sem esperar nada em troca.", verse: "\"Portanto, enquanto temos oportunidade, façamos o bem a todos.\"", reference: "Gálatas 6:10"),
    DailyChallenge(id: 4, title: "Oração", description: "Reserve 10 minutos para orar em silêncio, entregando suas preocupações a Deus.", verse: "\"Não andeis ansiosos de coisa alguma; antes, em tudo, pela oração e pela súplica, com ações de graças, os vossos pedidos sejam conhecidos diante de Deus.\"", reference: "Filipenses 4:6"),
    DailyChallenge(id: 5, title: "Palavra", description: "Leia um capítulo do evangelho de João hoje.", verse: "\"Lâmpada para os meus pés é tua palavra e luz para o meu caminho.\"", reference: "Salmos 119:105"),
    DailyChallenge(id: 6, title: "Amor", description: "Diga a alguém da sua família que você a ama hoje.", verse: "\"Amarás o Senhor, teu Deus, de todo o teu coração... e amarás o teu próximo como a ti mesmo.\"", reference: "Mateus 22:37-39"),
    DailyChallenge(id: 7, title: "Humildade", description: "Reconheça um erro que você cometeu e peça desculpas a quem foi afetado.", verse: "\"Deus resiste aos soberbos, mas dá graça aos humildes.\"", reference: "Tiago 4:6")
]

func todayChallenge() -> DailyChallenge {
    let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
    return dailyChallenges[(dayOfYear - 1) % dailyChallenges.count]
}
