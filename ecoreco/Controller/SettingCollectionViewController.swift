//
//  SettingCollectionViewController.swift
//  ecoreco
//
//  Created by admin on 2016/8/18.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

private let reuseIdentifier = "cell"


//add by eva
class MyTapGestureRecognizer: UITapGestureRecognizer {
    var index: Int?
}


class SettingCollectionViewController:

    UICollectionViewController {

    let TAG_CELL_IMAGE:Int = 100
    let TAG_CELL_LABEL:Int = 200

    var labelArray = ["TRIP","RIDE","BLUETOOTH","SAFETY","SCOOTER INFO","SHOP"]

    var imageArray = ["trip-w@3","ride-w@3","bluetooth-w@3","safety-w@3","restcombo-w@3","shop-w@3"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
// show font family name
//        for fontFamilyName in UIFont.familyNames() {
//            print("-- \(fontFamilyName) --")
//            
//            for fontName in UIFont.fontNamesForFamilyName(fontFamilyName as String) {
//                print(fontName)
//            }
//            
//            print(" ")
//        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 6
    }
    
    func collectionView(_ collectionView : UICollectionView,layout collectionViewLayout:UICollectionViewLayout,sizeForItemAtIndexPath indexPath:IndexPath) -> CGSize
    {
        let cellSize:CGSize = CGSize(width: self.view.frame.width/3, height: self.view.frame.width/3)
        return cellSize
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)

        var label:UILabel? = cell.contentView.viewWithTag(TAG_CELL_LABEL) as? UILabel
        // Configure the cell
        var imageView:UIImageView? = cell.contentView.viewWithTag(TAG_CELL_IMAGE) as? UIImageView

        if (imageView == nil){
            imageView = UIImageView(frame: CGRect(x: 20, y: 10, width: self.view.frame.width/4, height: view.frame.width/4));
            imageView!.tag = TAG_CELL_IMAGE
            cell.contentView.addSubview(imageView!)
        }
        
        if (label == nil){
            label = UILabel(frame: CGRect(x:0, y:self.view.frame.width/4+5, width: self.view.frame.width/3, height: 21))
            label!.tag = TAG_CELL_LABEL
            label!.textColor = UIColor.white
            label!.textAlignment = NSTextAlignment.center
            label!.font = UIFont(name:"VDS", size:16.0)
            cell.contentView.addSubview(label!)
            //add constrains for the label to align center
            let xConstraint = NSLayoutConstraint(item: label!, attribute: .centerX,
                                                 relatedBy: .equal, toItem: imageView,
                                                 attribute: .centerX, multiplier: 1.0,
                                                 constant: 0)

            cell.addConstraint(xConstraint)
        }


        imageView?.image = UIImage(named: imageArray[indexPath.row])

        label!.text = labelArray[indexPath.row]
        
        
        //add by eva
        imageView?.isUserInteractionEnabled = true
        let tapGestureRecognizer = MyTapGestureRecognizer(target: self, action: #selector(SettingCollectionViewController.tappedSettings(_:)))
        tapGestureRecognizer.index = indexPath.row
        imageView?.addGestureRecognizer(tapGestureRecognizer)

        
        
        return cell
    }
    
    let sectionInsets = UIEdgeInsets(top:10, left: 0, bottom: 10, right: 0)

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets{
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat{
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat
    {
        return 0
    }
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
    
    
    
    //add by eva
    func tappedSettings(_ gestureRecognizer: MyTapGestureRecognizer)
    {
        print(gestureRecognizer.index)
        
        switch (Int(gestureRecognizer.index!)) {
        case 0://trip
            self.parent!.performSegue(withIdentifier: "segueToTrip", sender: nil)
            break
        case 1://ride
            self.parent!.performSegue(withIdentifier: "segueToRide", sender: nil)
            break
        case 2://blue tooth
            //self.parentViewController!.performSegueWithIdentifier("segueToBlueTooth", sender: nil)
            break
        case 3://safety
            self.parent!.performSegue(withIdentifier: "segueToSafety", sender: nil)
            break
        case 4://security info
            self.parent!.performSegue(withIdentifier: "segueToScooterInfo", sender: nil)
            break
        case 5://shop (website)
            self.parent!.performSegue(withIdentifier: "segueToShop", sender: nil)
            break
        default:
            break
        }
    }
    

}
