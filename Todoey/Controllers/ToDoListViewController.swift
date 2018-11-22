//
//  ViewController.swift
//  Todoey
//
//  Created by Shuihua Zhu on 20/11/18.
//  Copyright © 2018 UMA Mental Arithmetic. All rights reserved.
//

import UIKit
import CoreData
class ToDoListViewController: UITableViewController {
    var itemArray = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        loadList()
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(path)
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
//        context.delete(item)
//        itemArray.remove(at: indexPath.row)
//        tableView.reloadData()
        item.done = !item.done
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.cellForRow(at: indexPath)?.accessoryType = item.done ? .checkmark : .none
        saveList()
    }
    @IBAction func addItemButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title:"Add New Item", message:"Add your todo item", preferredStyle:.alert)
        alert.addTextField(configurationHandler: {$0.placeholder="New Item"})
        let okAction = UIAlertAction(title: "Add", style: UIAlertAction.Style.default) { action in
            let str = alert.textFields![0].text!
            let item = Item(context: self.context)
            item.title = str
            item.done = false
            self.itemArray.append(item)
            self.saveList()
            self.tableView.reloadData()
        }
        alert.addAction(okAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    func loadList()
    {
        let request:NSFetchRequest<Item> = Item.fetchRequest()
        do{
            itemArray = try context.fetch(request)
        }
        catch{
            print("Faield to fetch data \(error)")
        }
    }
    func saveList()
    {
        do {
            try context.save()
        }
        catch{
            print("save data failed")
        }
    }
}

