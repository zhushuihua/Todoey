//
//  ViewController.swift
//  Todoey
//
//  Created by Shuihua Zhu on 20/11/18.
//  Copyright © 2018 UMA Mental Arithmetic. All rights reserved.
//

import UIKit
import RealmSwift
class ToDoListViewController: UITableViewController{
    var itemArray:Results<Item>!
    let realm = try! Realm()
    var selectedCategory:Category!
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
        do{
            try realm.write {
                item.done = !item.done
                tableView.reloadData()
            }
        }catch
        {
            print("deletion failed \(error)")
        }
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.cellForRow(at: indexPath)?.accessoryType = item.done ? .checkmark : .none
    }
    @IBAction func addItemButtonPressed(_ sender: Any) {
        var entry:UITextField!
        let alert = UIAlertController(title:"Add New Item", message:"Add your todo item", preferredStyle:.alert)
            alert.addTextField(configurationHandler: {
            $0.placeholder="New Item"
            entry = $0
        })
        let okAction = UIAlertAction(title: "Add", style: UIAlertAction.Style.default) { action in
            do{
               try  self.realm.write {
                    let item = Item()
                    item.title = entry.text!
                    self.selectedCategory.items.append(item)
                }
                self.tableView.reloadData()
        }
        catch{
            print("error save new item \(error)")
        }
        }
        alert.addAction(okAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func loadList()
   {
        itemArray = selectedCategory.items.sorted(byKeyPath: "title", ascending: true)
    
        tableView.reloadData()
    }
}
//MARK: - Search Bar methods
extension ToDoListViewController:UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        itemArray = itemArray.filter(NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)).sorted(byKeyPath: "createDate", ascending: false)
        tableView.reloadData()
        searchBar.resignFirstResponder()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText.isEmpty)
        {
            loadList()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
