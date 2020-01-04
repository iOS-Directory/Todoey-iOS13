//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: SwipeTableViewController {
    
    //Now we will initiate an array of instances of Item
    //Inside the load method we set the fetch equal to the itemArray
    var todoItems: Results<Item>?
    
    //create a new instance of Realm
    let realm = try! Realm()
    
    //Creating selectedCategory to get the selected row from category VC
    //here as soon as the selectedCategory gets set with a value then
    //the code inside will be trigger
    var selectedCategory: Category? {
        didSet{
            //Call loadItems to get the items from persistant storage
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //change the high of the cells for the icon to show correctly
        tableView.rowHeight = 70.0
    }
    
    //MARK: - TableView Building tables
    
    //Set number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    //Place data in the rows
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //get the cell from the super class
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        
        if let item = todoItems?[indexPath.row] {
            
            //set the cell label to the array
            //set the array and the index is the ammount of rows
            cell.textLabel?.text =  item.title
            
            //CHECKMARK
            //Use tenary operator to add or remove checkmark
            //value = condition ? vauleIfTrue : valueIfFalse
            cell.accessoryType = item.done ? .checkmark : .none
        }else{
            cell.textLabel?.text =  "No Items added."
        }
        return cell
    }
    
    
    //MARK: - TableView delegates
    
    //When a cell is selected it will triggered code
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Accesing delected item to update done status
        //In the todoItems continer accessing the curren index
        if let item = todoItems?[indexPath.row]{
            do {
                try realm.write {
                    //To delete an item
                    //realm.delete(item)
                    //the done property equal the oposite
                    item.done = !item.done
                }
            }catch{
                print("Error while updating \(error)")
            }
        }
        
        //To show tha change we must call reload
        tableView.reloadData()
        
        //on click cell will turn gray and go back to deselect which is white
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK: - Add new items to array
    
    @IBAction func addButtonPRessed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        //creating alert or pop up
        let alert = UIAlertController(title: "Add New Todoey", message: "", preferredStyle: .alert)
        
        //create an action which is the content in the alert
        let action = UIAlertAction(title: "add item", style: .default) { (action) in
            
            //To create new items inside CoreData DB //
            
            
            
            if let currentCat = self.selectedCategory {
                
                //Saving using Realm
                do {
                    try self.realm.write {
                        //2nd to initialize the item we now need to pass the context as a parameter
                        let newItem = Item()
                        
                        //3rd we set the input text to equal a new title in our CoreData DB
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        
                        //adding the item to the current cat
                        currentCat.items.append(newItem)
                        
                        //Add to the DB
                        self.realm.add(newItem)
                    }
                }catch {
                    print("Error saving \(error)")
                }
            }
            self.tableView.reloadData() 
        }
        //call method to add a textfield
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            //All this block is triggered when we start typing
            textField = alertTextField
        }
        //Add the action/content to our alert pop up
        alert.addAction(action)
        
        //This will present/show our alert
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - CRUD Method
    
    //Method to reload items
    func loadItems() {
        
        //we will load all of the items belowning to the current selected cat
        //and will will sort by the title in ascending order
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        //reload to show the new item
        tableView.reloadData()
    }
    
    //Delete data which overwrites method in swipe super class
    override func updateModel(at indexPath: IndexPath) {
        //if the method in the super class would have some code and
        //we want to use it plus add this func here we could added by
        //calling super.updateModel(at: indexPath) but if not call
        //we are overwriting everything and replace it with the code here
        
        
        //handle action by updating model with deletion
        if let item = self.todoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(item)
                }
            } catch {
                print("Error while deleting \(error)")
            }
        }
    }
}


//MARK: - Search Delegate methods

extension TodoListViewController: UISearchBarDelegate {
    
    //Delegate method to check when the search button is pressed
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //format is where we specify the disire query (the [cd] makes the search NOT case sensetive and special characters
        todoItems = todoItems?.filter("title CONTAINS[cd] %@",  searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }
    
    //Delegate method to check for changes in inputField
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        //if the search bar goes from any amount of charaters to zero we call loadItems
        if searchBar.text?.count == 0 {
            //call loadItems to load all items in DB
            loadItems()
            
            //Grab main que to dismmiss keyboard even if there are background task still being completed
            //DispatchQueue is the object that manages the execution of work items
            //and we will request the main threat
            DispatchQueue.main.async {
                //Dismiss keyboard and blinking curser
                searchBar.resignFirstResponder()
            }
        }
    }
}

