//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Shuihua Zhu on 23/11/18.
//  Copyright © 2018 UMA Mental Arithmetic. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
class CategoryViewController: SwipeTableViewCellController<Category>
{
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        cellIdentifier = "CategoryCell"
        loadCategories()
        if let color = navigationController?.navigationBar.barTintColor
        {
            navigationController?.navigationBar.tintColor = UIColor(contrastingBlackOrWhiteColorOn: color, isFlat: true)
            navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor(contrastingBlackOrWhiteColorOn: color, isFlat: true)]
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor(contrastingBlackOrWhiteColorOn: color, isFlat: true)]
        }
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
            let category = Category()
            category.name = categoryTextField.text!
            category.hextColor = UIColor.randomFlat()?.hexValue()
            self.save(t:category)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertVC.addAction(addAction)
        alertVC.addAction(cancelAction)
        present(alertVC, animated: true, completion: nil)
    }
    override func displayACell(cell: UITableViewCell, indexPath:IndexPath) {
        let oneItem = results[indexPath.row]
        cell.textLabel?.text = oneItem.name
        cell.backgroundColor = UIColor(hexString: oneItem.hextColor)
        cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: cell.backgroundColor!, isFlat: true)
    }
    
    override func selectedAnItem(at indexpath:IndexPath){
         performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if(segue.identifier == "goToItems")
        {
            
            let destination = segue.destination as! ToDoListViewController
            if let indexPath = tableView.indexPathForSelectedRow{
                destination.selectedCategory = results[indexPath.row]
            }
        }
    }
    //MARK: - Data Manipulation Method
    func loadCategories()
    {
        results = realm.objects(Category.self)
        tableView.reloadData()
    }
}
