//
//  Errors.swift
//  Le Baluchon
//
//  Created by Maxime Point on 16/12/2022.
//

import Foundation

enum ServiceError: String, Error {
    case urlNotCorrect = "URL not correct"
    case noData = "No data retrieved"
    case badResponse = "The request returned a bad response"
    case undecodableJSON = "Unexpected data"
    case noCurrentCity = "No current city provided"
    case noDestinationCity = "No destination city provided"
}
