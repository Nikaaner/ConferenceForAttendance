//
//  Attendee.swift
//  ConferenceForAttendees
//
//  Created by Andriy Herasymyuk on 19.09.17.
//  Copyright © 2017 AndriyHerasymyuk. All rights reserved.
//

import Foundation
import ObjectMapper

struct Attendee: Mappable {
    
    typealias AttendeesCompletion = (_ attendees: [Attendee]?) -> ()
    
    // MARK: - Properties
    
    var firstName: String?
    var lastName: String?
    var country: String?
    var email: String?
    var availableDates: [String]?
    
    // MARK: - Mappable
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        firstName <- map["firstName"]
        lastName <- map["lastName"]
        country <- map["country"]
        email <- map["email"]
        availableDates <- map["availableDates"]
    }
    
}

// MARK: - Public

extension Attendee {
    
    static func attendees(completion: @escaping AttendeesCompletion) {
        var attendees: [Attendee]?
        
        defer {
            completion(attendees)
        }
        
        do {
            guard let fileURL = Bundle.main.url(forResource: "Attendees", withExtension: "json") else {
                print("No file")
                return
            }
            
            let data = try Data(contentsOf: fileURL)
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            attendees = Mapper<Attendee>().mapArray(JSONObject: json)
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
