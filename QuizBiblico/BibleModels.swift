import Foundation

struct BibleBook: Identifiable {
    let id: Int
    let name: String
    let apiName: String
    let chapters: Int
    let testament: Testament

    enum Testament { case old, new }
}

struct BibleVerse: Identifiable {
    let id: String
    let chapter: Int
    let verse: Int
    let text: String
}

// MARK: - All 66 Books

let allBibleBooks: [BibleBook] = [
    // Antigo Testamento
    BibleBook(id: 1,  name: "Gênesis",        apiName: "genesis",        chapters: 50, testament: .old),
    BibleBook(id: 2,  name: "Êxodo",          apiName: "exodus",         chapters: 40, testament: .old),
    BibleBook(id: 3,  name: "Levítico",       apiName: "leviticus",      chapters: 27, testament: .old),
    BibleBook(id: 4,  name: "Números",        apiName: "numbers",        chapters: 36, testament: .old),
    BibleBook(id: 5,  name: "Deuteronômio",   apiName: "deuteronomy",    chapters: 34, testament: .old),
    BibleBook(id: 6,  name: "Josué",          apiName: "joshua",         chapters: 24, testament: .old),
    BibleBook(id: 7,  name: "Juízes",         apiName: "judges",         chapters: 21, testament: .old),
    BibleBook(id: 8,  name: "Rute",           apiName: "ruth",           chapters: 4,  testament: .old),
    BibleBook(id: 9,  name: "1 Samuel",       apiName: "1+samuel",       chapters: 31, testament: .old),
    BibleBook(id: 10, name: "2 Samuel",       apiName: "2+samuel",       chapters: 24, testament: .old),
    BibleBook(id: 11, name: "1 Reis",         apiName: "1+kings",        chapters: 22, testament: .old),
    BibleBook(id: 12, name: "2 Reis",         apiName: "2+kings",        chapters: 25, testament: .old),
    BibleBook(id: 13, name: "1 Crônicas",     apiName: "1+chronicles",   chapters: 29, testament: .old),
    BibleBook(id: 14, name: "2 Crônicas",     apiName: "2+chronicles",   chapters: 36, testament: .old),
    BibleBook(id: 15, name: "Esdras",         apiName: "ezra",           chapters: 10, testament: .old),
    BibleBook(id: 16, name: "Neemias",        apiName: "nehemiah",       chapters: 13, testament: .old),
    BibleBook(id: 17, name: "Ester",          apiName: "esther",         chapters: 10, testament: .old),
    BibleBook(id: 18, name: "Jó",             apiName: "job",            chapters: 42, testament: .old),
    BibleBook(id: 19, name: "Salmos",         apiName: "psalms",         chapters: 150,testament: .old),
    BibleBook(id: 20, name: "Provérbios",     apiName: "proverbs",       chapters: 31, testament: .old),
    BibleBook(id: 21, name: "Eclesiastes",    apiName: "ecclesiastes",   chapters: 12, testament: .old),
    BibleBook(id: 22, name: "Cantares",       apiName: "song+of+solomon",chapters: 8,  testament: .old),
    BibleBook(id: 23, name: "Isaías",         apiName: "isaiah",         chapters: 66, testament: .old),
    BibleBook(id: 24, name: "Jeremias",       apiName: "jeremiah",       chapters: 52, testament: .old),
    BibleBook(id: 25, name: "Lamentações",    apiName: "lamentations",   chapters: 5,  testament: .old),
    BibleBook(id: 26, name: "Ezequiel",       apiName: "ezekiel",        chapters: 48, testament: .old),
    BibleBook(id: 27, name: "Daniel",         apiName: "daniel",         chapters: 12, testament: .old),
    BibleBook(id: 28, name: "Oséias",         apiName: "hosea",          chapters: 14, testament: .old),
    BibleBook(id: 29, name: "Joel",           apiName: "joel",           chapters: 3,  testament: .old),
    BibleBook(id: 30, name: "Amós",           apiName: "amos",           chapters: 9,  testament: .old),
    BibleBook(id: 31, name: "Obadias",        apiName: "obadiah",        chapters: 1,  testament: .old),
    BibleBook(id: 32, name: "Jonas",          apiName: "jonah",          chapters: 4,  testament: .old),
    BibleBook(id: 33, name: "Miquéias",       apiName: "micah",          chapters: 7,  testament: .old),
    BibleBook(id: 34, name: "Naum",           apiName: "nahum",          chapters: 3,  testament: .old),
    BibleBook(id: 35, name: "Habacuque",      apiName: "habakkuk",       chapters: 3,  testament: .old),
    BibleBook(id: 36, name: "Sofonias",       apiName: "zephaniah",      chapters: 3,  testament: .old),
    BibleBook(id: 37, name: "Ageu",           apiName: "haggai",         chapters: 2,  testament: .old),
    BibleBook(id: 38, name: "Zacarias",       apiName: "zechariah",      chapters: 14, testament: .old),
    BibleBook(id: 39, name: "Malaquias",      apiName: "malachi",        chapters: 4,  testament: .old),
    // Novo Testamento
    BibleBook(id: 40, name: "Mateus",         apiName: "matthew",        chapters: 28, testament: .new),
    BibleBook(id: 41, name: "Marcos",         apiName: "mark",           chapters: 16, testament: .new),
    BibleBook(id: 42, name: "Lucas",          apiName: "luke",           chapters: 24, testament: .new),
    BibleBook(id: 43, name: "João",           apiName: "john",           chapters: 21, testament: .new),
    BibleBook(id: 44, name: "Atos",           apiName: "acts",           chapters: 28, testament: .new),
    BibleBook(id: 45, name: "Romanos",        apiName: "romans",         chapters: 16, testament: .new),
    BibleBook(id: 46, name: "1 Coríntios",    apiName: "1+corinthians",  chapters: 16, testament: .new),
    BibleBook(id: 47, name: "2 Coríntios",    apiName: "2+corinthians",  chapters: 13, testament: .new),
    BibleBook(id: 48, name: "Gálatas",        apiName: "galatians",      chapters: 6,  testament: .new),
    BibleBook(id: 49, name: "Efésios",        apiName: "ephesians",      chapters: 6,  testament: .new),
    BibleBook(id: 50, name: "Filipenses",     apiName: "philippians",    chapters: 4,  testament: .new),
    BibleBook(id: 51, name: "Colossenses",    apiName: "colossians",     chapters: 4,  testament: .new),
    BibleBook(id: 52, name: "1 Tessalonicenses", apiName: "1+thessalonians", chapters: 5, testament: .new),
    BibleBook(id: 53, name: "2 Tessalonicenses", apiName: "2+thessalonians", chapters: 3, testament: .new),
    BibleBook(id: 54, name: "1 Timóteo",      apiName: "1+timothy",      chapters: 6,  testament: .new),
    BibleBook(id: 55, name: "2 Timóteo",      apiName: "2+timothy",      chapters: 4,  testament: .new),
    BibleBook(id: 56, name: "Tito",           apiName: "titus",          chapters: 3,  testament: .new),
    BibleBook(id: 57, name: "Filemom",        apiName: "philemon",       chapters: 1,  testament: .new),
    BibleBook(id: 58, name: "Hebreus",        apiName: "hebrews",        chapters: 13, testament: .new),
    BibleBook(id: 59, name: "Tiago",          apiName: "james",          chapters: 5,  testament: .new),
    BibleBook(id: 60, name: "1 Pedro",        apiName: "1+peter",        chapters: 5,  testament: .new),
    BibleBook(id: 61, name: "2 Pedro",        apiName: "2+peter",        chapters: 3,  testament: .new),
    BibleBook(id: 62, name: "1 João",         apiName: "1+john",         chapters: 5,  testament: .new),
    BibleBook(id: 63, name: "2 João",         apiName: "2+john",         chapters: 1,  testament: .new),
    BibleBook(id: 64, name: "3 João",         apiName: "3+john",         chapters: 1,  testament: .new),
    BibleBook(id: 65, name: "Judas",          apiName: "jude",           chapters: 1,  testament: .new),
    BibleBook(id: 66, name: "Apocalipse",     apiName: "revelation",     chapters: 22, testament: .new),
]
