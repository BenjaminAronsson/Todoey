//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Benjamin on 2019-03-17.
//  Copyright © 2019 se.Benjamin.Aronsson. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
    
    //MARK: - tableview datasource
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        let category = categoryArray[indexPath.row]
        
        cell.textLabel?.text = category.name
        
        //cell.accessoryType = category.done ? .checkmark : .none
        
        
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    //MARK: - tableview delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems" , sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodolistViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    
    //MARK: - add item
   

    @IBAction func addButtonPressed(_ sender: Any) {
        
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add new category", style: .default) { (action) in
            //what will happend when button pressed
            
            if (textfield.text?.count)! > 0 {
                
                let newCategory = Category(context: self.context)
                newCategory.name = textfield.text!
                self.categoryArray.append(newCategory)

                self.saveData()
                self.tableView.reloadData()
            }
            
        }
        
        alert.addAction(action)
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "Create new item"
            textfield = alertTextfield
            
        }
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Save data
    func saveData() {
        
        do {
            try context.save()
        }
        catch {
            print("Error encoding item array, \(error)")
        }
    }
    
    //MARK: - Load data
    func loadData(with request : NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error retrieving item array, \(error)")
        }
        tableView.reloadData()
    }
    
    func removeItem(index: Int) {
        context.delete(categoryArray[index])
        categoryArray.remove(at: index)
        saveData()
    }
}
