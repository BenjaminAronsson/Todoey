//
//  Item.swift
//  Todoey
//
//  Created by Benjamin on 2019-03-20.
//  Copyright © 2019 se.Benjamin.Aronsson. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
