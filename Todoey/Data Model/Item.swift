//
//  Item.swift
//  Todoey
//
//  Created by Shuihua Zhu on 23/11/18.
//  Copyright © 2018 UMA Mental Arithmetic. All rights reserved.
//

import Foundation
import RealmSwift
class Item:Object{
    @objc dynamic var title:String = ""
    @objc dynamic var done:Bool = false
    @objc dynamic var createDate = Date()
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
