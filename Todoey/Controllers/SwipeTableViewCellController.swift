//
//  SwipeTableViewCellController.swift
//  Todoey
//
//  Created by Shuihua Zhu on 25/11/18.
//  Copyright © 2018 UMA Mental Arithmetic. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework
class SwipeTableViewCellController<T:Object>: UITableViewController, SwipeTableViewCellDelegate {
    var results:Results<T>!
    var cellIdentifier:String!
    let realm = try! Realm()
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    func selectedAnItem(at indexpath:IndexPath){
        
    }
    func displayACell(cell:UITableViewCell, indexPath:IndexPath)
    {
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedAnItem(at: indexPath)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SwipeTableViewCell
        displayACell(cell: cell, indexPath:indexPath)
        cell.delegate = self
        return cell
    }
    func save(t:T)
    {
        do{
            try realm.write {
                realm.add(t)
            }
        }
        catch{
            print("save \(t) to cordata error:\(error)")
        }
        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        let deleteActon = SwipeAction(style: .destructive, title:"Delete") { (action, indexPath) in
            do{
                try self.realm.write {
                    self.realm.delete(self.results[indexPath.row])
                }
            }
            catch{
                print("Error delete item \(error)")
            }
        }
            deleteActon.image = UIImage(named: "delete-icon")
        return [ deleteActon]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
}
