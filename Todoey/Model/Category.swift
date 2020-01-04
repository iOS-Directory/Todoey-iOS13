//
//  Data.swift
//  Todoey
//
//  Created by FGT MAC on 1/3/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

//The type is a Ream object
class Category: Object {
    
    //creating properties
    //include the keywords @objc dynamic to allow Realm to watch for changes
    //@objc = objective C modifyer
    //dynamic = dynamically monitor for changes while app is running 
   @objc dynamic var name: String = ""
    
    //For the relationship between the two table we will initialized an array
    //this array is of type "List" Which comes from Realm and will contain Item
    //objects and end it with "()" to initialized it
    let items = List<Item>()
}
