//
//  ArrayFromJson.swift
//  Celebook
//
//  Created by Jean Ro on 9/3/18.
//  Copyright © 2018 Jean Ro. All rights reserved.
//

import Foundation

public protocol ArrayFromJson {
    init(results: JSON)
}

public extension ArrayFromJson {
    public static func initialize<T: ArrayFromJson>(json: JSON) -> [T] {
        var array = [T]()
        json.forEach() {
            array.append(T.init(results: $0.1))
        }
        return array
    }
}
