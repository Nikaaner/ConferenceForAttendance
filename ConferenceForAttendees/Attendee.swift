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
    
    var suitableDates: [Date]? {
        guard let availableUnicalDates = availableUnicalDates else { return nil }
        var suitableDates: [Date] = []
        for index in 0..<availableUnicalDates.count {
            guard index < availableUnicalDates.count - 1 else { break }
            let date = availableUnicalDates[index]
            let nextDate = availableUnicalDates[index + 1]
            
            let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
            let nextDay = calendar.date(byAdding: .day, value: 1, to: date, options: [])!
            
            if nextDay == nextDate {
                suitableDates.append(nextDate)
            }
        }
        return suitableDates.isEmpty ? nil : suitableDates
    }
    
    private var availableDates: [Date]?
    
    private var availableUnicalDates: [Date]? {
        guard let availableDates = availableDates else { return nil }
        return Set(availableDates).sorted()
    }    
    
    // MARK: - Mappable
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        firstName <- map["firstName"]
        lastName <- map["lastName"]
        country <- map["country"]
        email <- map["email"]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        availableDates <- (map["availableDates"], DateFormatterTransform(dateFormatter: dateFormatter))
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
