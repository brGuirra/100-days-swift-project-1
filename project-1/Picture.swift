//
//  Picture.swift
//  project-1
//
//  Created by Bruno Guirra on 04/03/22.
//

import Foundation

struct Picture: Codable, Comparable {
    static func < (lhs: Picture, rhs: Picture) -> Bool {
        if lhs.name != rhs.name {
            return lhs.name < rhs.name
        } else {
            return lhs.name > rhs.name
        }
    }
    
    let name: String
    var views = 0
}
