//
//  ClassesViewController.swift
//  ScholarHighPrototype1
//
//  Created by 広瀬陽一 on 2018/11/13.
//  Copyright © 2018 FRESHNESS. All rights reserved.
//

import UIKit

class ClassesViewController: UIViewController {
    
    var tableView: UITableView!
    var label: UILabel!
    var day: String!
    var thisClasses = [Class]()
    var currentClassIndex = 0
    var maxPeriod = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let tableViewFrame = CGRect(
            x: self.view.bounds.origin.x,
            y: self.view.bounds.origin.y,
            width: self.view.bounds.width,
            height: self.view.bounds.height)
        tableView = UITableView(frame: tableViewFrame)
        tableView.register(UINib(nibName: "ClassCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifier")
        self.view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    func setupClasses(_ i: Int) {
        self.view.tag = i
        self.day = days[i]
        for c in classes {
            if c.day == day {
                thisClasses.append(c)
            }
        }
        
        for c in thisClasses {
            if maxPeriod < c.period {
                maxPeriod = c.period
            }
        }
        
        tableView.isScrollEnabled = maxPeriod <= 6 ? false : true
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}


extension ClassesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return maxPeriod <= 6 ? 6 : maxPeriod
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! ClassCell
        
        cell.setupFontSize()
        
        if currentClassIndex < thisClasses.count, indexPath.row + 1 == thisClasses[currentClassIndex].period {
            cell.classNameLabel.text = thisClasses[currentClassIndex].title
            cell.periodLabel.text = String(thisClasses[currentClassIndex].period)
            cell.startTimeLabel.text = startTimes[indexPath.row]
            cell.endTimeLabel.text = endTimes[indexPath.row]
            cell.teacherNameLabel.text = thisClasses[currentClassIndex].teacherName
            cell.placeLabel.text = thisClasses[currentClassIndex].place
            currentClassIndex += 1
        } else {
            cell.classNameLabel.text = ""
            cell.periodLabel.text = String(indexPath.row + 1)
            cell.startTimeLabel.text = startTimes[indexPath.row]
            cell.endTimeLabel.text = endTimes[indexPath.row]
            cell.teacherNameLabel.text = ""
            cell.placeLabel.text = ""
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        
        // let cell = tableView.cellForRow(at: indexPath) as! ClassCell
        
        let cell = tableView.cellForRow(at: indexPath) as! ClassCell
        let className = cell.classNameLabel.text!
        
        
        if className == "" {
            return
        }
        guard let initialController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()  else {
            return
        }
        
        let tableViewController = initialController as! TableViewController
        for c in classes {
            if c.title == className {
                tableViewController.thisClass = c
                break
            }
        }
        tableViewController.className = className
        
        self.navigationController?.pushViewController(initialController, animated: true)
        
    }
    
}

extension ClassesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.bounds.height / 6
    }
    
   
}

