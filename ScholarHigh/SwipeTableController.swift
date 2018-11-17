//
//  SwipeTableController.swift
//  ScholarHighPrototype1
//
//  Created by 広瀬陽一 on 2018/11/15.
//  Copyright © 2018 FRESHNESS. All rights reserved.
//

import Foundation
import UIKit
import SwipeCellKit

class SwipeTableController: UITableViewController, SwipeTableViewCellDelegate {
    
    var cell: UITableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80.0
        
    }
    
    
    
    //TableView Datasource Methods
    //XXX for future swipe functions may be used
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "room", for: indexPath) as! SwipeTableViewCell
        
        let cell: SwipeTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "room") as! SwipeTableViewCell

        cell.delegate = self
        
        return cell
    }
    
   func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
    
    
//        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
//            // handle action by updating model with deletion
//
//            self.updateModel(at: indexPath)
//
//        }
//    let room = rooms[indexPath.row]
//    guard orientation == .right else { return nil }
//
//     let like = SwipeAction(style: .default, title: nil) { (action, indexPath) in
//                let updatedStatus = !room.unliked
//                room.unliked = updatedStatus
//            }
//
//            like.hidesWhenSelected = true
//            like.accessibilityLabel = room.unliked ? "Mark as liked" : "Mark as unliked"//
//
//          let descriptor: ActionDescriptor = room.unliked ? .liked : .unliked
//            configure(action:like, with: descriptor)
//
//
//            let cell = tableView.cellForRow(at: indexPath) as! SwipeTableViewCell
//            let closure: (UIAlertAction) -> Void = { _ in cell.hideSwipe(animated: true) }
//
//    let more = SwipeAction(style: .default, title: nil) { action, indexPath in
//                let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//                controller.addAction(UIAlertAction(title: "Reply", style: .default, handler: closure))
//                controller.addAction(UIAlertAction(title: "Forward", style: .default, handler: closure))
//                controller.addAction(UIAlertAction(title: "Mark...", style: .default, handler: closure))
//                controller.addAction(UIAlertAction(title: "Notify Me...", style: .default, handler: closure))
//                controller.addAction(UIAlertAction(title: "Move Message...", style: .default, handler: closure))
//                controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: closure))
//                self.present(controller, animated: true, completion: nil)
//            }
//            configure(action: more, with: .more)
//
//            return [like,more]
       // }else {return nil}
    
    
        // customize the action appearance
//        deleteAction.image = UIImage(named: "delete-icon")
//
//        return [deleteAction]
    return nil
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    func updateModel(at indexPath: IndexPath) {
        // Update our data model.
        
        print("Item deleted from superclass")
    }
    
}


