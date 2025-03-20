//
//  StartComscoreArgs.swift
//  flutter_comscore
//
//  Created by admin on 20/03/25.
//

import Foundation

public class StartComscoreArgs: Codable {
    var userConsent: Int?
    var isChildDirected: Bool = false
    var debug: Bool = false
    
    init(userConsent: Int, isChildSirected: Bool, debug: Bool) {
        self.userConsent = userConsent
        self.debug = debug
        self.isChildDirected = isChildSirected
    }
}
