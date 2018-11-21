//
//  ViewController.swift
//  Todoey
//
//  Created by Shuihua Zhu on 20/11/18.
//  Copyright © 2018 UMA Mental Arithmetic. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    var itemArray = [Item]()
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        if let items = defaults.array(forKey: "toDoListArray") as? [Item]
        {
            itemArray = items
        }
        tableView.reloadData()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        let item = itemArray[indexPath.row]
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = itemArray[indexPath.row]
        item.done = !item.done
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.cellForRow(at: indexPath)?.accessoryType = item.done ? .checkmark : .none
    }
    @IBAction func addItemButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title:"Add New Item", message:"Add your todo item", preferredStyle:.alert)
        alert.addTextField(configurationHandler: {$0.placeholder="New Item"})
        let okAction = UIAlertAction(title: "Add", style: UIAlertAction.Style.default) { action in
            let str = alert.textFields![0].text!
            let item = Item()
            item.title = str
            self.itemArray.append(item)
            //self.defaults.setValue(self.itemArray, forKey: "toDoListArray")
            self.tableView.reloadData()
        }
        alert.addAction(okAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
}

