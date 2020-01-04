//
//  Item.swift
//  Todoey
//
//  Created by FGT MAC on 1/3/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    
    //set relationship to category
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items" )
}
