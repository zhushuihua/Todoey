//
//  ViewController.swift
//  Todoey
//
//  Created by Shuihua Zhu on 20/11/18.
//  Copyright © 2018 UMA Mental Arithmetic. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    var itemArray = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark
        {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else
        {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
    }
    @IBAction func addItem(_ sender: Any) {
        let alert = UIAlertController(title:"Add New Item", message:"Add your todo item", preferredStyle:.alert)
        alert.addTextField(configurationHandler: {$0.placeholder="New Item"})
        let okAction = UIAlertAction(title: "Add", style: UIAlertAction.Style.default) { action in
            let str = alert.textFields![0].text!
            self.itemArray.append(str)
            self.tableView.reloadData()
        }
        alert.addAction(okAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
}

