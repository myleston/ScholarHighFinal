//
//  TabViewController.swift
//  ScholarHighPrototype1
//
//  Created by 広瀬陽一 on 2018/11/13.
//  Copyright © 2018 FRESHNESS. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class TabViewController: UICollectionViewController{
    
    var classesPageViewController: ClassesPageViewController!
    var pageTabItemsWidth: CGFloat = 0.0
    var isFirstLayoutSubviews = true
    var index: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        self.collectionView!.register(UINib(nibName: "TabViewCell", bundle: nil), forCellWithReuseIdentifier: "reuseIdentifier")
        // Do any additional setup after loading the view.
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if isFirstLayoutSubviews {
            if pageTabItemsWidth == 0 {
                pageTabItemsWidth = floor(collectionView.contentSize.width / 3)
            }
            collectionView.contentOffset.x = pageTabItemsWidth - self.view.bounds.width / 2 + 40
            isFirstLayoutSubviews = false
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return days.count * 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseIdentifier", for: indexPath) as! TabViewCell
        cell.dayLabel.text = days[indexPath.row % 5] + "."
        
        // Configure the cell
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 didSelectItemAt indexPath: IndexPath) {
      classesPageViewController.setViewControllers([classesPageViewController.vcs[indexPath.row % 5]], direction: .forward, animated: true, completion: nil)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if pageTabItemsWidth == 0 {
            pageTabItemsWidth = floor(scrollView.contentSize.width / 3)
        }
        
        if (scrollView.contentOffset.x <= 0.0) || (scrollView.contentOffset.x > pageTabItemsWidth * 2.0) {
            scrollView.contentOffset.x = pageTabItemsWidth
        }
    }
    
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
}
