//
//  ViewController.swift
//  Checklists
//
//  Created by Kathleen Hang on 3/28/18.
//  Copyright © 2018 Kathleen Hang. All rights reserved.
//

import UIKit


class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {
    var checklist: Checklist!
    
    // set title to be name of checklist name property
    override func viewDidLoad() {
        super.viewDidLoad()
        title = checklist.name
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // number of rows in section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklist.items.count
    }
    
    // reuse cell?? change cell text, toggle checkmark
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        
        let item = checklist.items[indexPath.row]
        
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        return cell
    }
    
    
    
    // deselect the row, toggle the checkmark
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = checklist.items[indexPath.row]
            item.toggleChecked()
            configureCheckmark(for: cell, with: item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // check or uncheck
    func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
        let label = cell.viewWithTag(1001) as! UILabel
        
        if item.checked {
            label.text = "√"
        } else {
            label.text = ""
        }
        
        label.textColor = view.tintColor
    }
    
    // delete a certain row
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        checklist.items.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    //set up label and text inside
    func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
        //  label.text = "\(item.itemID): \(item.text)"
    }
    // user pressed cancel button
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        dismiss(animated: true, completion: nil)
    }
    // tell table view you have a new row for it, add item, and then close the Add Items screen
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
        // get next index location
        let newRowIndex = checklist.items.count
        // add item to checklist objects items array
        checklist.items.append(item)
        // make index path be of the new row index
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        // make array of type index path
        let indexPaths = [indexPath]
        // put new index path array in row
        tableView.insertRows(at: indexPaths, with: .automatic)
        dismiss(animated: true, completion: nil)
    }

    // tell it to update its label for checklist item because of edit
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
        // must find row number for this checklist item, in order to find index path
        // possible you use index of on object that is not actually in the array
        if let index = checklist.items.index(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        dismiss(animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // make sure you refer to correct segue
        if segue.identifier == "AddItem" {
            // get hold of the navigation controller that embeds add item view controller
            let navigationController = segue.destination as! UINavigationController
            // get the add item view controller
            let controller = navigationController.topViewController as! ItemDetailViewController
            // tell add item view controller that checklist view controller is now its delegate
            controller.delegate = self
        } else if segue.identifier == "EditItem" {
            // get navigation controller
            let navigationController = segue.destination as! UINavigationController
            // get ItemDetailViewController
            let controller = navigationController.topViewController as! ItemDetailViewController
            // set vc delegate property so we are notified when user taps cancel or done
            controller.delegate = self
            // find the row index by checking event sender. return type is IndexPath? this is why we use if let
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = checklist.items[indexPath.row]
                // with the row number , we can obtain the checklist item object to edit. and we can assign this to ItemDetailViewControllers itemToEdit property
            }
        }
    }   
}

