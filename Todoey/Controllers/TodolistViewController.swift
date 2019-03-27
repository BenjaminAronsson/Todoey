//
//  ViewController.swift
//  Todoey
//
//  Created by Benjamin on 2019-03-17.
//  Copyright © 2019 se.Benjamin.Aronsson. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodolistViewController: SwipeTableViewController {
    
    var todoItems : Results<Item>?
    
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet{
           loadItems()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80
        
        tableView.separatorStyle = .none
    }
    
    @IBOutlet weak var searchBAr: UISearchBar!
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.title = selectedCategory?.name
        guard let colourHex = selectedCategory?.color else {fatalError()}
        
        updateNavbar(withHexCode: colourHex)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateNavbar(withHexCode: "1D9BF6")
    }
    
    
    //MARK: - navbar setup
    
    func updateNavbar(withHexCode colourHexCode : String) {
        
        guard let navbar = navigationController?.navigationBar else {fatalError("Navbar does not exist")}
        
        guard let navbarColour = UIColor(hexString: colourHexCode) else {fatalError()}
        
        navbar.barTintColor = navbarColour
        navbar.tintColor = ContrastColorOf(navbarColour, returnFlat: true)
        
        searchBAr.barTintColor = navbarColour
        
        if #available(iOS 11.0, *) {
            navbar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navbarColour, returnFlat: true) ]
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    
    //MARK: - tableview datasource
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let Item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = Item.title
            
            if let colour : UIColor = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
                    cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
                }
            
            
            
            cell.accessoryType = Item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items added"
        }
        
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    //MARK - tableview delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status \(error)")
            }
        }
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
                
                if let currentCategory = self.selectedCategory {
                    do {
                        try self.realm.write {
                            let newItem = Item()
                            newItem.title = textfield.text!
                            newItem.dateCreated = Date()
                            currentCategory.items.append(newItem )
                        }
                    } catch {
                        print("Error saving item \(error)")
                    }
                }
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
        if let itemForDeletion = self.todoItems?[indexpath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(itemForDeletion)
                }
            } catch {
                print("error deleting item")
            }
        }
    }
    
    //MARK: - Load data
    func loadItems() {

       todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }

}


//MARK: - searchbar
extension TodolistViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar.text?.count)! == 0 {
             loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }
}

