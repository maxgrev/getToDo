//
//  ViewController.swift
//  getToDo
//
//  Created by Max Grev on 2/26/19.
//  Copyright © 2019 Upstate.Media. All rights reserved.
//

import UIKit

class getToDoViewController: UITableViewController {

    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Destroy Demogorgon"
        itemArray.append(newItem)
        
        let newItem3 = Item()
        newItem3.title = "Buy Eggos"
        itemArray.append(newItem)
        
        
        if let items = defaults.array(forKey: "getToDoListArray") as? [Item] {
            itemArray = items
        }
    }
    
    //MARK: - TableView Datasource Methods
    
    //Declare how many rows (numberOfRowsInSection) do we want in our TableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "getToDoItemCell")
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //Ternary operator ==> value = condition ? valueIfTrue : valueIfFalse
        //Set the cell.accessoryType depending on whether the item.done is true, if it is, then set it to .checkmark, and if it's not, then set it to .none
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //set current item in the itemArray to the opposite of what it is right now, if it's false - it becomes true, if it's true - it becomes false
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: - Add New Items
    

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Get To Do Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            //what will happen once the user clicks the Add Item button on our Alert
            
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            
            self.defaults.set(self.itemArray, forKey: "getToDoListArray")
            
            self.tableView.reloadData()
        }
        
        //adding a text field to the action
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
}

