//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by FGT MAC on 1/1/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    //Initialize Realm
    let realm = try! Realm()
    
    //Creating array of [Category]()
    var categoryArray: Results<Category>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //change the high of the cells for the icon to show correctly
        tableView.rowHeight = 70.0
        
        //Load current items in DB
        loadCat()
        
        //Remove the separator lines between cells
        tableView.separatorStyle = .none
    }
    
    
    //SET INITIAL NAV BACKGROUND COLOR TO BLUE
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else {
            fatalError("Navigation Controller does not exist")
        }
        
         //Set the background to blue
        navBar.backgroundColor = UIColor(hexString: "1D9BF6")
        
        //Set title letters to white
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        
    }
    
    
    //MARK: - TableView Data source Methods
    
    //Set the number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //Count how many itmes are in the array to create a row for each
        //But since is an optiona it could be nill so if is nil we would return 1
        return categoryArray?.count ?? 1
    }
    
    
    //Create reusable cells with data
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Creating Reusable cell
        //let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categoryArray?[indexPath.row] {
            //iterate through array to Provide text for the cells
            // since categoryArray is optional we will provide a default string if categoryArray is nil
            cell.textLabel?.text = category.name
            
            guard let categoryColor = UIColor(hexString: category.color) else {fatalError("Invalid cat color!")}
            
            //cell background
            cell.backgroundColor = categoryColor
            
            //contras text color in each string cell
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
            
        }
        
        return cell
    }
    
    //MARK: - Add New Category
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //initializing a new text field object
        var textField = UITextField()
        
        //Create pop up alert with a title
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        
        //creating input field inside the popup
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            //initiating a new item
            let newCat = Category()
            
            //get the input text to equal the new cat
            newCat.name = textField.text!
            
            //Creating a random color
            //  newCat.color = UIColor.randomFlat().hexValue()
            newCat.color = UIColor(randomFlatColorOf:.light).hexValue()
            
            //call saveCat to save current context to DB
            self.save(category: newCat)
        }
        
        //call method to add the textfield
        alert.addTextField { (alertTextField) in
            //create placeholder
            alertTextField.placeholder = "Create new Category"
            
            textField = alertTextField
        }
        
        //add the action to the alert
        alert.addAction(action)
        
        //present the alert
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - Data Manipulation Methods
    
    //Saving data from Context to DB
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving contect. \(error)")
        }
        
        //reload table to update content
        tableView.reloadData()
    }
    
    
    func loadCat() {
        
        categoryArray = realm.objects(Category.self)
        
        //reload table to update content
        tableView.reloadData()
    }
    
    //DELETE
    override func updateModel(at indexPath: IndexPath) {
        
        if let item = self.categoryArray?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(item)
                }
            }catch {
                print("Error deleting \(error)")
            }
        }
        
    }
    
    //MARK: - TableView Delegate Methods
    
    //When user click on a cell this will be trigger
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Creating redirect to take user to another view
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    //Here we prepare before display the next view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //getting hold of the destination / next view and downcasted as TodoListViewController
        //because we already known which is the view controller
        //If we would have a few different view then we could do an if statment on what to do on each
        let destinationVC = segue.destination as! TodoListViewController
        
        //identify the current selected row
        if let indexPath = tableView.indexPathForSelectedRow {
            //set a property inside the destinationVC to the selected row
            //the selectedCategory must be created in the corresponding view to get the value
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
           
        }
        
    }
}
