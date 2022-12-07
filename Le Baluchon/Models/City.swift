//
//  City.swift
//  Le Baluchon
//
//  Created by Maxime Point on 25/11/2022.
//

import Foundation

struct City: Decodable {

    var name: String?
    var localNames: LocalNames?
    var lat: Double?
    var lon: Double?
    var country: String?
    var state: String?

    struct LocalNames: Decodable {
        var featureName: String?
        var ascii: String?
        var af: String?
        var al: String?
        var ar: String?
        var az: String?
        var bg: String?
        var ca: String?
        var cz: String?
        var da: String?
        var de: String?
        var el: String?
        var en: String?
        var eu: String?
        var fa: String?
        var fi: String?
        var fr: String?
        var gl: String?
        var he: String?
        var hi: String?
        var hr: String?
        var hu: String?
        var id: String?
        var it: String?
        var ja: String?
        var kr: String?
        var la: String?
        var lt: String?
        var mk: String?
        var no: String?
        var nl: String?
        var pl: String?
        var pt: String?
        var ptBr: String?
        var ro: String?
        var ru: String?
        var sv: String?
        var se: String?
        var sk: String?
        var sl: String?
        var sp: String?
        var es: String?
        var sr: String?
        var th: String?
        var tr: String?
        var ua: String?
        var uk: String?
        var vi: String?
        var zhCn: String?
        var zhTw: String?
        var zu: String?
    }
    
    var stateAndCountryDetails: String {
        if let stateOfTheCity = self.state {
            if let countryOfTheCity = self.country {
                return "\(stateOfTheCity) - \(countryOfTheCity)"
            } else {
                return stateOfTheCity
            }
        } else {
            if let countryOfTheCity = self.country {
                return countryOfTheCity
            } else {
                return ""
            }
        }
    }
    
    func getNameWithStateAndCountry(languageKeys: Languages) -> String {
        let localName = getLocalName(languageKeys: languageKeys)
        
        if let stateOfTheCity = self.state {
            if let countryOfTheCity = self.country {
                return "\(localName) - \(stateOfTheCity) - \(countryOfTheCity)"
            } else {
                return "\(localName) - \(stateOfTheCity)"
            }
        } else {
            if let countryOfTheCity = self.country {
                return "\(localName) - \(countryOfTheCity)"
            } else {
                return localName
            }
        }
    }
    
    // swiftlint:disable cyclomatic_complexity
    
    // TODO: Obliger de faire ça ?
    /// Function that returns the city name based on the user's language.
    /// - Parameter languageKeys: user's language key
    /// - Returns: city name based on the user's language
    func getLocalName(languageKeys: Languages) -> String {
        guard let name = name else { return "City name not specified" }
        var localName: String?
        
        switch languageKeys {
            case .fr: localName = localNames?.fr
            case .af: localName = localNames?.af
            case .al: localName = localNames?.al
            case .ar: localName = localNames?.ar
            case .az: localName = localNames?.az
            case .bg: localName = localNames?.bg
            case .ca: localName = localNames?.ca
            case .cz: localName = localNames?.cz
            case .da: localName = localNames?.de
            case .de: localName = localNames?.de
            case .el: localName = localNames?.el
            case .en: localName = localNames?.en
            case .eu: localName = localNames?.eu
            case .fa: localName = localNames?.fa
            case .fi: localName = localNames?.fi
            case .gl: localName = localNames?.gl
            case .he: localName = localNames?.he
            case .hi: localName = localNames?.hi
            case .hr: localName = localNames?.hr
            case .hu: localName = localNames?.hu
            case .id: localName = localNames?.id
            case .it: localName = localNames?.it
            case .ja: localName = localNames?.ja
            case .kr: localName = localNames?.kr
            case .la: localName = localNames?.la
            case .lt: localName = localNames?.lt
            case .mk: localName = localNames?.mk
            case .no: localName = localNames?.no
            case .nl: localName = localNames?.nl
            case .pl: localName = localNames?.pl
            case .pt: localName = localNames?.pt
            case .pt_br: localName = localNames?.ptBr
            case .ro: localName = localNames?.ro
            case .ru: localName = localNames?.ru
            case .sv: localName = localNames?.sv
            case .se: localName = localNames?.se
            case .sk: localName = localNames?.sk
            case .sl: localName = localNames?.sl
            case .sp: localName = localNames?.sp
            case .es: localName = localNames?.es
            case .sr: localName = localNames?.sr
            case .th: localName = localNames?.th
            case .tr: localName = localNames?.tr
            case .ua: localName = localNames?.ua
            case .uk: localName = localNames?.uk
            case .vi: localName = localNames?.vi
            case .zh_cn: localName = localNames?.zhCn
            case .zh_tw: localName = localNames?.zhTw
            case .zu: localName = localNames?.zu
        }
        
        if let localName = localName { return localName } else { return name }
        
    }
    // swiftlint:enable cyclomatic_complexity
}
