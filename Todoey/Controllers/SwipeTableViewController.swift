//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by FGT MAC on 1/4/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //downcast as as! SwipeTableViewCell for the swipe
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        //set self as delegate  for the swipe
        cell.delegate = self
        
        return cell
    }
    
    
    
    //Require method
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            
            //Call the method to delete the selected item
            //the method is empty here but get overwriten inside each view controller
            self.updateModel(at: indexPath)
            
            tableView.reloadData()
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(systemName: "trash")
        
        return [deleteAction]
    }
    
    func collectionView(_ collectionView: UICollectionView, editActionsOptionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
    
    //Custom func to delete
    func updateModel(at indexPath: IndexPath) {
        //update our data model.
        //We create the function here but overwrite it in each view controller
    }
}
