//
//  Lang.swift
//  Le Baluchon
//
//  Created by Maxime Point on 25/11/2022.
//

import Foundation

enum Languages: String, CaseIterable {
    case af
    case al
    case ar
    case az
    case bg
    case ca
    case cz
    case da
    case de
    case el
    case en
    case eu
    case fa
    case fi
    case fr
    case gl
    case he
    case hi
    case hr
    case hu
    case id
    case it
    case ja
    case kr
    case la
    case lt
    case mk
    case no
    case nl
    case pl
    case pt
    case pt_br
    case ro
    case ru
    case sv
    case se
    case sk
    case sl
    case sp
    case es
    case sr
    case th
    case tr
    case ua
    case uk
    case vi
    case zh_cn
    case zh_tw
    case zu
    
    var description: String {
        switch self {
            case .af: return "Afrikaans"
            case .al: return "Albanian"
            case .ar: return "Arabic"
            case .az: return "Azerbaijani"
            case .bg: return "Bulgarian"
            case .ca: return "Catalan"
            case .cz: return "Czech"
            case .da: return "Danish"
            case .de: return "German"
            case .el: return "Greek"
            case .en: return "English"
            case .eu: return "Basque"
            case .fa: return "Persian (Farsi)"
            case .fi: return "Finnish"
            case .fr: return "French"
            case .gl: return "Galician"
            case .he: return "Hebrew"
            case .hi: return "Hindi"
            case .hr: return "Croatian"
            case .hu: return "Hungarian"
            case .id: return "Indonesian"
            case .it: return "Italian"
            case .ja: return "Japanese"
            case .kr: return "Korean"
            case .la: return "Latvian"
            case .lt: return "Lithuanian"
            case .mk: return "Macedonian"
            case .no: return "Norwegian"
            case .nl: return "Dutch"
            case .pl: return "Polish"
            case .pt: return "Portuguese"
            case .pt_br: return "Português Brasil"
            case .ro: return "Romanian"
            case .ru: return "Russian"
            case .sv: return "Swedish"
            case .se: return "Swedish "
            case .sk: return "Slovak"
            case .sl: return "Slovenian"
            case .sp: return "Spanish"
            case .es: return "Spanish "
            case .sr: return "Serbian"
            case .th: return "Thai"
            case .tr: return "Turkish"
            case .ua: return "Ukrainian"
            case .uk: return "Ukrainian "
            case .vi: return "Vietnamese"
            case .zh_cn: return "Chinese Simplified"
            case .zh_tw: return "Chinese Traditional"
            case .zu: return "Zulu"
        }
    }
}
