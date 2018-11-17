//
//  RootViewController.swift
//  ScholarHighPrototype1
//
//  Created by 広瀬陽一 on 2018/11/13.
//  Copyright © 2018 FRESHNESS. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    var classesPageViewController: ClassesPageViewController!
    var tabViewController: TabViewController!
    var day: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        classesPageViewController = self.children[0] as! ClassesPageViewController
        tabViewController = self.children[1] as! TabViewController
        classesPageViewController.tabViewController = tabViewController
        tabViewController.classesPageViewController = classesPageViewController

        
        // set pageView
        guard let vc = classesPageViewController else {
            return
        }
        vc.setViewControllers([vc.vcs[day]], direction: .forward, animated: true, completion: nil)
        
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
