//
//  ViewController.swift
//  Todoey
//
//  Created by Benjamin on 2019-03-17.
//  Copyright © 2019 se.Benjamin.Aronsson. All rights reserved.
//

import UIKit
import CoreData

class TodolistViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet{
           // loadData()
        }
    }
    
    let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    
   

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    //MARK: - tableview datasource
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let Item = itemArray[indexPath.row]
        
        cell.textLabel?.text = Item.title
        
        cell.accessoryType = Item.done ? .checkmark : .none
        
        
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //MARK - tableview delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //check item in tableview
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveData()
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - add new item

    @IBAction func addItemButtonPressed(_ sender: Any) {
        
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add new item", style: .default) { (action) in
            //what will happend when button pressed
            
            if (textfield.text?.count)!  > 0 {
                
//                let newItem = Item()
//                newItem.done = false
//                newItem.title = textfield.text!
//                newItem.parentCategory = self.selectedCategory
//                self.itemArray.append(newItem)
//                
//                self.saveData()
//                self.tableView.reloadData()
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
//    func loadData(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
//
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//
//        if let _ = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate!])
//        }
//        else {
//            request.predicate = categoryPredicate
//        }
//
//        do {
//        itemArray = try context.fetch(request)
//        } catch {
//             print("Error retrieving item array, \(error)")
//        }
//        tableView.reloadData()
//    }
//
//    func removeItem(index: Int) {
//        context.delete(itemArray[index])
//        itemArray.remove(at: index)
//        saveData()
//    }
}


//MARK: - searchbar
//extension TodolistViewController: UISearchBarDelegate {
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//       loadData(with: request, predicate: predicate)
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if (searchBar.text?.count)! == 0 {
//             loadData()
//
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//
//        }
//    }
//}

