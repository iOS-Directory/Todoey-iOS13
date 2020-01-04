//
//  AppDelegate.swift
//  Destini
//
//  Created by Philipp Muellauer on 01/09/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
//importing Realm which was install using pods
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        //Path to Real files
//        print(Realm.Configuration.defaultConfiguration.fileURL)
        
        //Initializing Realm
        do {
            //Set as _ variable since it will not be use here but is being initialise to catch any potensial errors
            _ = try Realm()
        } catch {
            print("Error initialising new Realm, \(error)")
        }
        
        return true
    }
    
    
}

