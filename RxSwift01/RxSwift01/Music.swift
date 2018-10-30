//
//  Music.swift
//  RXSwiftTest1
//
//  Created by Lorwy on 2018/10/28.
//  Copyright © 2018 Lorwy. All rights reserved.
//

import Foundation

struct Music {
    let name: String
    let singer: String
    
    init(name: String, singer: String) {
        self.name = name
        self.singer = singer
    }
}

extension Music: CustomStringConvertible {
    var description: String {
        return "name: \(name) singer: \(singer)"
    }
    
}
