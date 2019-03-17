//
//  ViewController.swift
//  Todoey
//
//  Created by Benjamin on 2019-03-17.
//  Copyright © 2019 se.Benjamin.Aronsson. All rights reserved.
//

import UIKit

class TodolistViewController: UITableViewController {
    
    var itemArray = [Item]()
    let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
   

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
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
           
            let newItem = Item()
            
            if (textfield.text?.count)!  > 0 {
                newItem.title = textfield.text!
            self.itemArray.append(newItem)
                
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
        
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: filePath!)
            
        }
        catch {
            print("Error encoding item array, \(error)")
        }
    }
    
    //MARK: - Load data
    func loadData() {
        
        if let data = try? Data(contentsOf: filePath!) {
            let decoder = PropertyListDecoder()
            do {
                try itemArray = decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding items \(error)")
            }
        }
    }
    
}

