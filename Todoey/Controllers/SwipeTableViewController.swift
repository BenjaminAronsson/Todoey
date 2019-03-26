//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Benjamin on 2019-03-26.
//  Copyright © 2019 se.Benjamin.Aronsson. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    var cell : UITableViewCell?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //tableviewcell datasource method
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
       
        cell.delegate = self
        
        
        return cell
    }
    
    
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete")
            { (action, IndexPath) in
            
            self.updateModel(at: IndexPath)
                
            }

        //customize action appearence
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    func updateModel(at indexpath: IndexPath) {
        //update datamodel
    }
}

