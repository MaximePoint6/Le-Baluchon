//
//  Dictionary.swift
//  Le Baluchon
//
//  Created by Maxime Point on 30/11/2022.
//

import Foundation

extension Dictionary where Value: Equatable {
    func someKey(forValue val: Value) -> Key? {
        return first(where: { $1 == val })?.key
    }
}
