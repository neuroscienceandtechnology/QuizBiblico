import Foundation

// MARK: - Faith Comes By Hearing / Bible.is API
// Para obter sua chave gratuita:
// 1. Acesse: https://www.faithcomesbyhearing.com/bible-brain/developer-documentation
// 2. Registre-se como desenvolvedor (gratuito)
// 3. Cole sua chave no app em Configurações → Áudio

struct AudioBibleConfig {

    // Chave da API FCBH (pode ser inserida no app — não precisa recompilar)
    static var apiKey: String {
        UserDefaults.standard.string(forKey: "fcbh_api_key") ?? ""
    }

    static var isConfigured: Bool { !apiKey.isEmpty }

    // IDs dos filesets para Bíblia Dramatizada em Português (NVI)
    // Para descobrir outros filesets disponíveis, consulte:
    //   GET /api/bibles?media=audio_drama&language_code=por&v=4&key={key}
    static let otFilesetId = "PORTBSLBO2DA"   // Antigo Testamento Dramatizado
    static let ntFilesetId = "PORTBSLBN2DA"   // Novo Testamento Dramatizado

    static let baseURL = "https://4.dbt.io/api"

    static func fileset(for testament: BibleBook.Testament) -> String {
        testament == .old ? otFilesetId : ntFilesetId
    }

    // Mapeamento livro → código FCBH (padrão OSIS)
    static let fcbhBookCode: [Int: String] = [
        1:"GEN", 2:"EXO", 3:"LEV", 4:"NUM", 5:"DEU",
        6:"JOS", 7:"JDG", 8:"RUT", 9:"1SA", 10:"2SA",
        11:"1KI", 12:"2KI", 13:"1CH", 14:"2CH", 15:"EZR",
        16:"NEH", 17:"EST", 18:"JOB", 19:"PSA", 20:"PRO",
        21:"ECC", 22:"SNG", 23:"ISA", 24:"JER", 25:"LAM",
        26:"EZK", 27:"DAN", 28:"HOS", 29:"JOL", 30:"AMO",
        31:"OBA", 32:"JON", 33:"MIC", 34:"NAH", 35:"HAB",
        36:"ZEP", 37:"HAG", 38:"ZEC", 39:"MAL",
        40:"MAT", 41:"MRK", 42:"LUK", 43:"JHN", 44:"ACT",
        45:"ROM", 46:"1CO", 47:"2CO", 48:"GAL", 49:"EPH",
        50:"PHP", 51:"COL", 52:"1TH", 53:"2TH", 54:"1TI",
        55:"2TI", 56:"TIT", 57:"PHM", 58:"HEB", 59:"JAS",
        60:"1PE", 61:"2PE", 62:"1JN", 63:"2JN", 64:"3JN",
        65:"JUD", 66:"REV",
    ]
}
