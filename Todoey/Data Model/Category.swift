//
//  Category.swift
//  Todoey
//
//  Created by Shuihua Zhu on 23/11/18.
//  Copyright © 2018 UMA Mental Arithmetic. All rights reserved.
//
import Foundation
import RealmSwift
class Category:Object
{
    @objc dynamic var name:String = ""
    @objc dynamic var hextColor:String?
    let items = List<Item>()
}
