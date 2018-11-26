//
//  ViewController.swift
//  Todoey
//
//  Created by Shuihua Zhu on 20/11/18.
//  Copyright © 2018 UMA Mental Arithmetic. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework
class ToDoListViewController: SwipeTableViewCellController<Item>{
    var selectedCategory:Category!
    var barOriginalColor:UIColor?
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        cellIdentifier = "toDoItemCell"
        title = selectedCategory.name
        loadList()
    }
    override func viewWillAppear(_ animated: Bool) {
        barOriginalColor = navigationController?.navigationBar.barTintColor
       let color = UIColor(hexString: selectedCategory.hextColor!)
            searchBar.barTintColor = color!
        updateNavColor(color: color!)
    }
    override func viewWillDisappear(_ animated: Bool) {
        if let color = barOriginalColor
        {
            updateNavColor(color: color)
        }
    }
    func updateNavColor(color:UIColor)
    {
        navigationController?.navigationBar.barTintColor = color
        navigationController?.navigationBar.tintColor = UIColor(contrastingBlackOrWhiteColorOn: color, isFlat: true)
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor(contrastingBlackOrWhiteColorOn: color, isFlat: true)]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor(contrastingBlackOrWhiteColorOn: color, isFlat: true)]

    }
    @IBAction func addItemButtonPressed(_ sender: Any) {
        var entry:UITextField!
        let alert = UIAlertController(title:"Add New Item", message:"Add your todo item", preferredStyle:.alert)
            alert.addTextField(configurationHandler: {
            $0.placeholder="New Item"
            entry = $0
        })
        let okAction = UIAlertAction(title: "Add", style: UIAlertAction.Style.default) { action in
            let item = Item()
            item.title = entry.text!
            do{
               try self.realm.write {
                    self.selectedCategory.items.append(item)
                }
            }
            catch
            {
                print("Failedto add item to items\(error)")
            }
            self.save(t: item)
            self.tableView.reloadData()
        }
        alert.addAction(okAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    override func displayACell(cell: UITableViewCell, indexPath: IndexPath) {
        let item = results[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        let darkentFactor = CGFloat(indexPath.row) / CGFloat(results.count);
        if let color = UIColor(hexString: selectedCategory.hextColor!)
        {
            cell.backgroundColor = color.darken(byPercentage: darkentFactor)
            cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: cell.backgroundColor, isFlat: true)
        }
    }
    override func selectedAnItem(at indexpath: IndexPath) {
        let cell = tableView.cellForRow(at: indexpath)
        let item = results[indexpath.row]
        do{
            try realm.write {
                item.done = !item.done
            }
        }
        catch
        {
            print("done saving failed \(error)")
        }
        cell?.accessoryType = item.done ? .checkmark : .none
        tableView.deselectRow(at:indexpath, animated: true)
    }
    func loadList()
   {
        results = selectedCategory.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
}
//MARK: - Search Bar methods
