//
//  ViewController.swift
//  getToDo
//
//  Created by Max Grev on 2/26/19.
//  Copyright © 2019 Upstate.Media. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class getToDoViewController: SwipeTableViewController {

    var getToDoItems : Results<Item>?
    
    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
        
    override func viewWillAppear(_ animated: Bool) {
        
        title = selectedCategory?.name
        
        guard let colorHex = selectedCategory?.color else { fatalError() }
        
        updateNavBar(withHexCode: colorHex)
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateNavBar(withHexCode: "1D9BF6")
    }
    
    //MARK: - Nav Bar Setup Methods
    
    func updateNavBar(withHexCode colorHexCode: String) {
        
        guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller does not exist.") }
        
        guard let navBarColor = UIColor(hexString: colorHexCode) else { fatalError() }
        
        navBar.barTintColor = navBarColor
        
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
        
        searchBar.barTintColor = navBarColor
        
    }
    
    
    //MARK: - TableView Datasource Methods
    
    //Declare how many rows (numberOfRowsInSection) do we want in our TableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getToDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = getToDoItems?[indexPath.row] {
        
        cell.textLabel?.text = item.title
            
        if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(getToDoItems!.count)) {
        cell.backgroundColor = color
        cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
        
            
        
        //Ternary operator ==> value = condition ? valueIfTrue : valueIfFalse
        //Set the cell.accessoryType depending on whether the item.done is true, if it is, then set it to .checkmark, and if it's not, then set it to .none
        cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added Yet"
        }
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = getToDoItems?[indexPath.row] {
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
    
    
    //MARK: – Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let itemForDeletion = self.getToDoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(itemForDeletion)
                }
            } catch {
                print("Error deleting an item, \(error)")
            }
        }
    }
    
    //MARK: - Add New Items
    

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Get To Do Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            //what will happen once the user clicks the Add Item button on our Alert
            
            if let currentCategory = self.selectedCategory {
                
                do {
                try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.dateCreated = Date()
                    currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new item \(error)")
                }
            }
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
    
    //MARK: – Model Manipulation Methods
    
    func loadItems() {
     
        getToDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
 
        tableView.reloadData()
    }
 
}

//MARK: - Search bar methods

extension getToDoViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        getToDoItems = getToDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated")
        
        tableView.reloadData()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

