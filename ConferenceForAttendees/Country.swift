//
//  Country.swift
//  ConferenceForAttendees
//
//  Created by Andriy Herasymyuk on 19.09.17.
//  Copyright © 2017 AndriyHerasymyuk. All rights reserved.
//

import Foundation
import ObjectMapper

struct Country: Mappable  {
    
    // MARK: - Properties
    
    var name: String?
    var attendees: [Attendee]?
    
    // MARK: - Lifecycle
    
    init(name: String, attendees: [Attendee]) {
        self.name = name
        self.attendees = attendees
    }
    
    // MARK: - Mappable
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        name <- map["name"]
    }
    
}
