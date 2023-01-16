//
//  Errors.swift
//  Le Baluchon
//
//  Created by Maxime Point on 16/12/2022.
//

import Foundation

enum ServiceError: String, Error {
    case urlNotCorrect
    case noData
    case badResponse
    case undecodableJSON
    case noCurrentCity
    case noDestinationCity
    case noCurrentCityCountry
    case noDestinationCityCountry
    case currencyNotFound
    case languageNotfound
}
