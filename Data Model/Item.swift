//
//  Item.swift
//  getToDo
//
//  Created by Max Grev on 3/4/19.
//  Copyright © 2019 Upstate.Media. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
