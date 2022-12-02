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
    
    func localName(languageKeys: String) -> String {
        guard let name = name else {
            return ""
        }
        if languageKeys == "fr" {
            if let localName = localNames?.fr {
                return localName
            } else {
                return name
            }
        } else {
            return name
        }
    }
}
