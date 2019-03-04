//
//  Category.swift
//  getToDo
//
//  Created by Max Grev on 3/4/19.
//  Copyright © 2019 Upstate.Media. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
