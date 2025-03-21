//
//  NotifyViewEventArgs.swift
//  flutter_comscore
//
//  Created by admin on 21/03/25.
//

import Foundation

public class NotifyViewEventArgs: Codable {
    var category: String
    var eventData: [String: String]?
    
    init(category: String, eventData: [String : String]) {
        self.category = category
        self.eventData = eventData
    }
}
