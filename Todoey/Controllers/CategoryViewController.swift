//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Benjamin on 2019-03-17.
//  Copyright © 2019 se.Benjamin.Aronsson. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categories: Results<Category>?
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80
        
        loadCategories()
    }
    
    //MARK: - tableview datasource
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet"
        
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    //MARK: - tableview delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems" , sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodolistViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    
    //MARK: - add item
   

    @IBAction func addButtonPressed(_ sender: Any) {
        
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add new category", style: .default) { (action) in
            //what will happend when button pressed
            
            if (textfield.text?.count)! > 0 {
                
                let newCategory = Category()
                newCategory.name = textfield.text!

                self.save(category: newCategory)
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
    
    //MARK: - delete data from swipe
    
    override func updateModel(at indexpath: IndexPath) {
        if let categoreyForDeletion = self.categories?[indexpath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoreyForDeletion)
                }
            } catch {
                print("error deleting item")
            }
        }
    }
    
    //MARK: - Save data
    func save(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        }
        catch {
            print("Error encoding item array, \(error)")
        }
    }
    
    func delete(category: Category) {
        
        do {
            try realm.write {
                realm.delete(category)
            }
        }
        catch {
            print("Error encoding item array, \(error)")
        }
    }
    
    //MARK: - Load data
    func loadCategories() {

        categories = realm.objects(Category.self)
    
        tableView.reloadData()
    }
}


