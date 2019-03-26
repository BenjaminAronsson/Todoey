//
//  Category.swift
//  Todoey
//
//  Created by Benjamin on 2019-03-20.
//  Copyright © 2019 se.Benjamin.Aronsson. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name : String = ""
    @objc dynamic var color : String = ""
    let items = List<Item>()
}
