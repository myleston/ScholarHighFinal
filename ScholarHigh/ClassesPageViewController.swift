//
//  ClassesPageViewController.swift
//  ScholarHighPrototype1
//
//  Created by 広瀬陽一 on 2018/11/13.
//  Copyright © 2018 FRESHNESS. All rights reserved.
//

import UIKit

import UIKit

class ClassesPageViewController: UIPageViewController {
    
    var vcs = [ClassesViewController]()
    var tabViewController: TabViewController!
    var pageTabItemsWidth = CGFloat(0)
    var index = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        dataSource = self
        
        // Do any additional setup after loading the view.
        for i in 0 ..< days.count {
            let vc = ClassesViewController()
            vc.setupClasses(i)
            vcs.append(vc)
        }

        self.setViewControllers([vcs[0]], direction: .forward, animated: true, completion:nil)
        
        for v in self.view.subviews{
            (v as! UIScrollView).delegate = self
        }
 
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


extension ClassesPageViewController: UIPageViewControllerDataSource {
    
    private func nextViewController(_ viewController: UIViewController, after: Bool) -> UIViewController? {
        guard var currentIndex = vcs.firstIndex(of: viewController as! ClassesViewController) else {
            return nil
        }
        
        if after {
            currentIndex = (currentIndex + 1 < 5 ? currentIndex + 1 : currentIndex - 4)
        } else {
            currentIndex = (currentIndex - 1 >= 0 ? currentIndex - 1 : currentIndex + 4)
        }
        
        return vcs[currentIndex] as UIViewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nextViewController(viewController, after: false)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return nextViewController(viewController, after: true)
    }
    
    
    
}

extension ClassesPageViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let move =
            (scrollView.contentOffset.x - self.view.bounds.width) / self.view.bounds.width
        if pageTabItemsWidth == 0 {
            pageTabItemsWidth = floor(tabViewController.collectionView.contentSize.width / 3)
        }
        if move == 0 {
            self.index = self.viewControllers!.first!.view.tag
            
        }
        tabViewController.collectionView.contentOffset.x =
            pageTabItemsWidth - tabViewController.view.bounds.width / 2 + 40 + (CGFloat(move) + CGFloat(index)) * 80
    }

    
}



