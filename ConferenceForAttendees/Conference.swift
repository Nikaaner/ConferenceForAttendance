//
//  Conference.swift
//  ConferenceForAttendees
//
//  Created by Andriy Herasymyuk on 19.09.17.
//  Copyright © 2017 AndriyHerasymyuk. All rights reserved.
//

import Foundation
import ObjectMapper

struct Conference: Mappable {
    
    // MARK: - Properties
    
    var countryName: String?
    var startingDate: Date?
    var emails: [String]?
    
    fileprivate var country: Country?
    
    // MARK: - Lifecycle
    
    init(country: Country) {
        self.country = country
        
        countryName = country.name
        let theBestDate = calculateStartingDate()
        startingDate = theBestDate?.0
        emails = theBestDate?.1.flatMap { $0.email }
    }
    
    // MARK: - Mappable
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        countryName <- map["country"]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        startingDate <- (map["startingDate"], DateFormatterTransform(dateFormatter: dateFormatter))
        
        emails <- map["emails"]
    }
    
}

// MARK: - Public

extension Conference {
    
    static func conferences(from: [Attendee]) -> [Conference]? {
        guard let attendees = Attendee.attendeesWithSuitableDate() else { return nil }
        
        let countriesNames = Set(attendees.flatMap { $0.country }).sorted()
        
        var countries: [Country] = []
        
        countriesNames.forEach({ (countryName) in
            let attendees = attendees.filter { $0.country == countryName }
            let country = Country(name: countryName, attendees: attendees)
            countries.append(country)
        })
        
        guard !countries.isEmpty else { return nil }
        
        return countries.map { Conference(country: $0) }
    }
    
    func calculateStartingDate() -> (Date, [Attendee])? {
        var datesPopularity: [Date: [Attendee]] = [:]
        
        country?.attendees?.forEach({ (attendee) in
            attendee.suitableDates?.forEach({ (date) in
                var attendees: [Attendee] = datesPopularity[date] ?? []
                attendees.append(attendee)
                datesPopularity[date] = attendees
            })
        })
        
        let theBestDate = datesPopularity.sorted { (first, second) -> Bool in
            if first.value.count == second.value.count {
                return first.key > second.key
            }
            
            return first.value.count > second.value.count
        }.first
        
        return theBestDate
    }
    
}
