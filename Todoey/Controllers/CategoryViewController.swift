//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Shuihua Zhu on 23/11/18.
//  Copyright © 2018 UMA Mental Arithmetic. All rights reserved.
//

import UIKit
import CoreData
class CategoryViewController: UITableViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categories:[Category] = [Category]()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var categoryTextField:UITextField!
        let alertVC = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        alertVC.addTextField { (textField) in
            categoryTextField = textField
            textField.placeholder = "New Category"
        }
        let addAction = UIAlertAction(title: "Add", style: .default) {
            action in
            let category = Category(context: self.context)
            category.name = categoryTextField.text!
            self.categories.append(category)
            self.saveCategories()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertVC.addAction(addAction)
        alertVC.addAction(cancelAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    //MARK: - TableView DataSoruce Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }
    //MARK: - TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     //   tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if(segue.identifier == "goToItems")
        {
            
            let destination = segue.destination as! ToDoListViewController
            if let indexPath = tableView.indexPathForSelectedRow{
                destination.selectedCategory = categories[indexPath.row]
            }
        }
    }
    //MARK: - Data Manipulation Method
    func saveCategories()
    {
        do{
            try context.save()
        }
        catch{
            print("save category to cordata error:\(error)")
        }
        tableView.reloadData()
    }
    func loadCategories(request:NSFetchRequest<Category> = Category.fetchRequest())
    {
        do{
            categories = try context.fetch(request)
        }
        catch{
            print("Loading Categories Error:\(error)")
        }
        tableView.reloadData()
    }
}
