//
//  TableViewController.swift
//  ScholarHighPrototype1
//
//  Created by 広瀬陽一 on 2018/10/15.
//  Copyright © 2018年 FRESHNESS. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import RealmSwift
import Realm
import PMAlertController
import ChameleonFramework
import SwipeCellKit


class TableViewController: SwipeTableController {

    @IBOutlet weak var classNameBar: UINavigationItem!
    @IBOutlet weak var classView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    //new02
    var filteredRooms = [Room]()
    var buttonDisplayMode: ButtonDisplayMode = .titleAndImage
    var buttonStyle: ButtonStyle = .backgroundColor
    var defaultOptions = SwipeOptions()
    
    
    
    // new declarations
    let db = Firestore.firestore()
    let realm = try! Realm()
    let schoolName = "ynu"
    var className = ""
    var thisClass = Class()
    var data: [String: Any]?
    var rooms = List<Room>()
    var room: Room?
    var classRef: CollectionReference?
    private var roomListener: ListenerRegistration?
    let user = Auth.auth().currentUser
    
    @IBAction func addNewRoom(_ sender: Any) {
        let alertVC = PMAlertController(title: "A Title", description: "My Description", image: UIImage(named: "img.png"), style: .alert)
        
        alertVC.addAction(PMAlertAction(title: "Cancel", style: .cancel, action: { () -> Void in
            print("Capture action Cancel")
        }))
        
        alertVC.addAction(PMAlertAction(title: "Create Room as question", style: .default, action: { () in
            
            let newRoomNameField = alertVC.textFields[0]
            if let roomName = newRoomNameField.text {
                if roomName == "" {
                    return
                }
                self.classRef!.addDocument(data:  ["title": roomName,"topicType": "question", "latestTime": Timestamp(date: Date())])            }
            
            
            print("Capture action OK")
        }))
        
        alertVC.addAction(PMAlertAction(title: "Create Room as assignment", style: .default, action: { () in
            
            let newRoomNameField = alertVC.textFields[0]
            if let roomName = newRoomNameField.text {
                if roomName == "" {
                    return
                }
                self.classRef!.addDocument(data:  ["title": roomName,"topicType": "assignment", "latestTime": Timestamp(date: Date())])            }
            
            
            print("Capture action OK")
        }))
        
        alertVC.addAction(PMAlertAction(title: "Create Room as assist", style: .default, action: { () in
            
            let newRoomNameField = alertVC.textFields[0]
            if let roomName = newRoomNameField.text {
                if roomName == "" {
                    return
                }
                self.classRef!.addDocument(data:  ["title": roomName,"topicType": "assist", "latestTime": Timestamp(date: Date())])
            }
            
            
            print("Capture action OK")
        }))
        
        alertVC.addTextField { (textField) in
            textField?.placeholder = "Location..."
        }
        
        
        
        
        self.present(alertVC, animated: true, completion: nil)
    }
    
    
    @IBAction func signOut(_ sender: UIBarButtonItem) {
        let ac = UIAlertController(title: nil, message: "アカウントデータは残りません。本当にサインアウトしますか？", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        ac.addAction(UIAlertAction(title: "サインアウト", style: .destructive, handler: { _ in
            do {
                try Auth.auth().signOut()
            } catch {
                print("Error signing out: \(error.localizedDescription)")
            }
            AppDefs.displayName = nil
        }))
        present(ac, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.tableView.register(UINib(nibName: "SwipeTableViewCell", bundle: nil), forCellReuseIdentifier: "room")

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        searchController.searchBar.scopeButtonTitles = ["All", "assist", "assignment", "question"]
        searchController.searchBar.delegate = self
        
        //new-01
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Candies"
        
        
        
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            // Fallback on earlier versions
        }
        definesPresentationContext = true
        
        
        db
            .collection( ["schools", schoolName, "classes"].joined(separator: "/"))
            .whereField("title", isEqualTo: thisClass.title)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    if querySnapshot?.documents == [] {
                        self.addNewClass(self.thisClass)
                        return
                    }
                    for document in querySnapshot!.documents {
                        let data = document.data()
                       
                        self.thisClass.initialize(title: data["title"] as! String, day: data["day"] as! String, period: data["period"] as! Int, teacherName: data["teacherName"] as! String, place: data["place"] as! String, classID: document.documentID)
 
                        self.classRef = self.db
                            .collection( ["schools", self.schoolName, "classes", self.thisClass.classID, "rooms"].joined(separator: "/"))
                        self.roomListener = self.classRef?.addSnapshotListener { querySnapshot, error in
                            guard let snapshot = querySnapshot else {
                                print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
                                return
                            }
                            
                            snapshot.documentChanges.forEach { change in
                                self.handleDocumentChange(change)
                            }
                            
                            
                            try! self.realm.write() {
                                self.realm.add(self.rooms, update: true)
                            }
                        }
                    }
                }
            
                
        }
        
        rooms = realm.objects(Room.self).reduce(List<Room>()) { (list, element) -> List<Room> in
            print(element)
            if element.title == thisClass.title {
                list.append(element)
            }
            return list
        }
      
        


        
        classNameBar.title = thisClass.title
    }
    
    //new04
    // MARK: - Private instance methods
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredRooms = rooms.filter({( room : Room) -> Bool in
            
            let doesCategoryMatch = (scope == "All") || (room.topicType == scope)
            if searchBarIsEmpty() {
                return doesCategoryMatch
            } else {
                return doesCategoryMatch && room.title.lowercased().contains(searchText.lowercased())
            }
        })
        
        tableView.reloadData()
    }
    
    //new05
    func isFiltering() -> Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
    }
    
    
    func addNewClass(_ newClass: Class) {
        let schoolRef = self.db
            .collection( ["schools", self.schoolName, "classes"].joined(separator: "/"))
        schoolRef.addDocument(data: newClass.representation)
        
        self.classRef = self.db
            .collection( ["schools", self.schoolName, "classes", self.thisClass.classID, "rooms"].joined(separator: "/"))
        self.roomListener = self.classRef?.addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
                return
            }
            
            snapshot.documentChanges.forEach { change in
                self.handleDocumentChange(change)
            }
            
            
            try! self.realm.write() {
                self.realm.add(self.rooms, update: true)
            }
        }
    }
    
    private func handleDocumentChange(_ change: DocumentChange) {
        room = Room()
        guard let room = room, room.initialize(document: change.document) else {
            return
        }
        for r in rooms {
            if r == room {
                return
            }
        }
        switch change.type {
        case .added:
            addChannelToTable(room)
            
        case .modified:
            updateChannelInTable(room)
            
        case .removed:
            removeChannelFromTable(room)
        }
    }
    
    private func addChannelToTable(_ room: Room) {
        
       
        rooms.append(room)
        rooms.sort(by: {$0 > $1})
        
        guard let index = rooms.index(of: room) else {
            return
        }
        tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    private func updateChannelInTable(_ room: Room) {
        guard let index = rooms.index(of: room) else {
            return
        }
        
        rooms[index] = room
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    private func removeChannelFromTable(_ room: Room) {
        guard let index = rooms.index(of: room) else {
            return
        }
        
        rooms.remove(at: index)
        tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //new06
        if isFiltering() {
            return filteredRooms.count
        }
        return rooms.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //new07

       //  let cell = tableView.dequeueReusableCell(withIdentifier: "room", for: indexPath)
                let cell = super.tableView(tableView, cellForRowAt: indexPath)

        let room: Room
        if isFiltering() {
            room = filteredRooms[indexPath.row]
        } else {
            room = rooms[indexPath.row]
        }
        
        if(room.topicType == "assist"){
            cell.contentView.backgroundColor = UIColor(gradientStyle: .leftToRight, withFrame: cell.frame, andColors: [.flatPowderBlue, .flatBlue, .flatNavyBlue])
        }else if(room.topicType == "assignment"){
            cell.contentView.backgroundColor = UIColor(gradientStyle: .leftToRight, withFrame: cell.frame, andColors: [.flatPowderBlue, .black, .flatGrayDark])
        }else if(room.topicType == "question"){
            cell.contentView.backgroundColor = UIColor(gradientStyle: .leftToRight, withFrame: cell.frame, andColors: [.flatPowderBlue, .orange, .flatOrange])
        }
        
        cell.textLabel?.text = room.title
        let format = DateFormatter()
        format.dateFormat = "HH:mm"
        cell.detailTextLabel?.text = format.string(from: room.latestTime.dateValue())

        if(room.topicType == "assist"){
        cell.imageView?.image = UIImage(named: "assist")
        }else if(room.topicType == "assignment"){
            cell.imageView?.image = UIImage(named: "assignment")
        }else if(room.topicType == "question"){
            cell.imageView?.image = UIImage(named: "question")
        }
        // Configure the cell...

        return cell
    }
    
    //test run
   // extension TableViewController: SwipeTableViewCellDelegate{
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            
            self.updateModel(at: indexPath)
            
        }
            let room = rooms[indexPath.row]
            guard orientation == .right else { return nil }
        
             let like = SwipeAction(style: .default, title: nil) { (action, indexPath) in
                        let updatedStatus = !room.unliked
                        room.unliked = updatedStatus
                    }
        
                    like.hidesWhenSelected = true
                    like.accessibilityLabel = room.unliked ? "Mark as liked" : "Mark as unliked"//
        
                  let descriptor: ActionDescriptor = room.unliked ? .liked : .unliked
                    configure(action:like, with: descriptor)
        
        
                    let cell = tableView.cellForRow(at: indexPath) as! SwipeTableViewCell
                    let closure: (UIAlertAction) -> Void = { _ in cell.hideSwipe(animated: true) }
        
            let more = SwipeAction(style: .default, title: nil) { action, indexPath in
                        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                        controller.addAction(UIAlertAction(title: "Reply", style: .default, handler: closure))
                        controller.addAction(UIAlertAction(title: "Forward", style: .default, handler: closure))
                        controller.addAction(UIAlertAction(title: "Mark...", style: .default, handler: closure))
                        controller.addAction(UIAlertAction(title: "Notify Me...", style: .default, handler: closure))
                        controller.addAction(UIAlertAction(title: "Move Message...", style: .default, handler: closure))
                        controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: closure))
                        self.present(controller, animated: true, completion: nil)
                    }
                    configure(action: more, with: .more)
        
                    return [like,more]
        // }else {return nil}
    
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    
    //end test run
    override func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        return options
    }
    
func configure(action: SwipeAction, with descriptor: ActionDescriptor) {
    action.title = descriptor.title(forDisplayMode: buttonDisplayMode)
    action.image = descriptor.image(forStyle: buttonStyle, displayMode: buttonDisplayMode)
    
    switch buttonStyle {
    case .backgroundColor:
        action.backgroundColor = descriptor.color
    case .circular:
        action.backgroundColor = .clear
        action.textColor = descriptor.color
        action.font = .systemFont(ofSize: 13)
        action.transitionDelegate = ScaleTransition.default
    }
}
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        room = rooms[indexPath.row]
        self.performSegue(withIdentifier: "toRoom", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRoom" {
            let roomController: RoomController  = segue.destination as! RoomController
            roomController.thisClass = thisClass
      
            roomController.room = room
            roomController.user = user
        }
        
    }
  
}

extension TableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!)
        
    }
}

extension TableViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}


