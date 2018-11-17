//
//  WholeClassesViewController.swift
//  ScholarHighPrototype1
//
//  Created by 広瀬陽一 on 2018/11/13.
//  Copyright © 2018 FRESHNESS. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class WholeClassesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var wholeClassesView: UICollectionView!

    @IBAction func onMonButtonTapped(_ sender: UIButton) {
        day = 0
        performSegue(withIdentifier: "toRoot", sender: nil)
        
    }
    @IBAction func onTueButtonTapped(_ sender: UIButton) {
        day = 1
        performSegue(withIdentifier: "toRoot", sender: nil)
    }
    @IBAction func onWedButtonTapped(_ sender: UIButton) {
        day = 2
        performSegue(withIdentifier: "toRoot", sender: nil)
    }
    @IBAction func onThuButtonTapped(_ sender: UIButton) {
        day = 3
        performSegue(withIdentifier: "toRoot", sender: nil)
    }
    @IBAction func onFriButtonTapped(_ sender: UIButton) {
        day = 4
        performSegue(withIdentifier: "toRoot", sender: nil)
    }
    
    var day: Int = 0;
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        classes.append(Class().initialize(title: "論理回路", day: "Mon", period: 1, teacherName: "", place: "A106", classID: "0"))
        classes.append(Class().initialize(title: "教育学", day: "Mon", period: 3, teacherName: "広瀬陽一", place: "経済102", classID: "0"))
        classes.append(Class().initialize(title: "プログラミング言語", day: "Tue", period: 2, teacherName: "富田", place: "A201", classID: "0"))
        classes.append(Class().initialize(title: "プログラミングの思考と表現", day: "Tue", period: 3, teacherName: "広瀬陽一", place: "情報端末室C, D", classID: "0"))
        classes.append(Class().initialize(title: "ことばと論理", day: "Wed", period: 1, teacherName: "藤田", place: "A201", classID: "0"))
        classes.append(Class().initialize(title: "システムプログラム", day: "Wed", period: 2, teacherName: "広瀬陽一", place: "経済102", classID: "0"))
        classes.append(Class().initialize(title: "プログラミング演習Ⅱ", day: "Wed", period: 3, teacherName: "白川・長谷川", place: "電子情報工学棟3階演習端末室", classID: "0"))
        classes.append(Class().initialize(title: "プログラミング演習Ⅱ", day: "Wed", period: 4, teacherName: "白川・長谷川", place: "電子情報工学棟3階演習端末室", classID: "0"))
        
        classes.append(Class().initialize(title: "計算理論", day: "Thu", period: 1, teacherName: "松本勉", place: "A201", classID: "0"))
        classes.append(Class().initialize(title: "国際政治", day: "Thu", period: 2, teacherName: "広瀬陽一", place: "経済102", classID: "0"))
        classes.append(Class().initialize(title: "情報理論", day: "Thu", period: 3, teacherName: "椎名林檎", place: "A201", classID: "0"))
        classes.append(Class().initialize(title: "気象学", day: "Thu", period: 4, teacherName: "長岡亮介", place: "教育7号館102", classID: "0"))
        classes.append(Class().initialize(title: "アルゴリズムとデータ構造", day: "Fri", period: 1, teacherName: "長尾", place: "C201", classID: "0"))
        classes.append(Class().initialize(title: "マルチメディア処理", day: "Fri", period: 2, teacherName: "富田", place: "A101", classID: "0"))
        classes.append(Class().initialize(title: "情報理論", day: "Fri", period: 5, teacherName: "椎名林檎", place: "A201", classID: "0"))
        classes.append(Class().initialize(title: "計算理論", day: "Fri", period: 7, teacherName: "松本勉", place: "A201", classID: "0"))
        
        // db settings
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        
        
        // Register cell classes
        wholeClassesView!.register(UINib(nibName: "ClassCollectionCell", bundle: nil), forCellWithReuseIdentifier: "reuseIdentifier")
        
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.topItem?.title = "週"
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        if appDelegate?.isFirst ?? false {
            performSegue(withIdentifier: "toRoot", sender: nil)
            appDelegate?.isFirst = false
        }
        wholeClassesView.dataSource = self
        wholeClassesView.delegate = self
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseIdentifier", for: indexPath) as! ClassCollectionCell
        cell.backgroundColor = .darkGray
        var thisClass: Class?
        for c in classes {
            if c.day == days[indexPath.row % 5], c.period == indexPath.row / 5 + 1 {
                thisClass = c
                break
            }
        }
        guard let unwrappedClass = thisClass else {
            return cell
        }
        cell.classNameLabel.adjustsFontSizeToFitWidth = true
        cell.placeLabel.adjustsFontSizeToFitWidth = true
        cell.classNameLabel.text = unwrappedClass.title
        cell.placeLabel.text = unwrappedClass.place
        // Configure the cell
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow:CGFloat = 5
        let spacingBetweenCells:CGFloat = 2
        
        let totalSpacing =  2 + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row

        if let collection = self.wholeClassesView{
            let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
            let height = (collection.bounds.height - 2 * 5) / 6
            return CGSize(width: width, height: height)
        }else{
            return CGSize(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                                 didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! ClassCollectionCell
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toRoot" {
            
            let rootViewController:RootViewController = segue.destination as! RootViewController
            rootViewController.day = day
           
        }
    }

}
