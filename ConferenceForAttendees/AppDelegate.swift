//
//  AppDelegate.swift
//  ConferenceForAttendees
//
//  Created by Andriy Herasymyuk on 19.09.17.
//  Copyright © 2017 AndriyHerasymyuk. All rights reserved.
//

import UIKit
import ObjectMapper

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        if let attendees = Attendee.allAttendees(), let conferences = Conference.conferences(from: attendees) {
            let serializedConferences = Mapper().toJSONString(conferences)!
//            print(serializedConferences)
            let data = serializedConferences.data(using: .utf8)!
            
            let dir = FileManager.default.urls(for: FileManager.SearchPathDirectory.cachesDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first!
            let fileurl =  dir.appendingPathComponent("Conferences.json")
            try! data.write(to: fileurl, options: .atomic)
            print(fileurl)
        }
        
        return true
    }

}

