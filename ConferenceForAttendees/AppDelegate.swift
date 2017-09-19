//
//  AppDelegate.swift
//  ConferenceForAttendees
//
//  Created by Andriy Herasymyuk on 19.09.17.
//  Copyright © 2017 AndriyHerasymyuk. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Attendee.attendees { (attendees) in
            attendees?.forEach {
                print("\($0.firstName) \($0.lastName) \($0.suitableDates)")
            }
        }
        
        return true
    }

}

