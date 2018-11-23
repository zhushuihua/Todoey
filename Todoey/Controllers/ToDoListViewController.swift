//
//  ViewController.swift
//  Todoey
//
//  Created by Shuihua Zhu on 20/11/18.
//  Copyright © 2018 UMA Mental Arithmetic. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
class ToDoListViewController: UITableViewController{
    var itemArray = [Item]()
    var selectedCategory:Category!
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
            item.parentCategory = self.selectedCategory
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
        let query:NSFetchRequest<Item> = Item.fetchRequest()
        queryDatabase(query: query)
    }
    func queryDatabase(query:NSFetchRequest<Item>)
    {
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory.name!)
        print("123")
        if let predicate = query.predicate
        {
            
            query.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
        }
        else{
            query.predicate = categoryPredicate
        }
        do{
            itemArray = try context.fetch(query)
        }
        catch{
            print("Faield to fetch data \(error)")
        }
        var tmp = [Item]()
        for item in itemArray
        {
            if(item.parentCategory == selectedCategory)
            {
                tmp.append(item)
            }
            itemArray = tmp
        }
        tableView.reloadData()
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
//MARK: - Search Bar methods
extension ToDoListViewController:UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let query:NSFetchRequest<Item> = Item.fetchRequest()
        query.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        query.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        queryDatabase(query: query)
        searchBar.resignFirstResponder()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == ""
        {
            loadList()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}
