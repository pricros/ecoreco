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
        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
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

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 6
    }
    
    func collectionView(collectionView : UICollectionView,layout collectionViewLayout:UICollectionViewLayout,sizeForItemAtIndexPath indexPath:NSIndexPath) -> CGSize
    {
        let cellSize:CGSize = CGSizeMake(self.view.frame.width/3, self.view.frame.width/3)
        return cellSize
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)

        var label:UILabel? = cell.contentView.viewWithTag(TAG_CELL_LABEL) as? UILabel
        // Configure the cell
        var imageView:UIImageView? = cell.contentView.viewWithTag(TAG_CELL_IMAGE) as? UIImageView

        if (imageView == nil){
            imageView = UIImageView(frame: CGRectMake(20, 10, self.view.frame.width/4, view.frame.width/4));
            imageView!.tag = TAG_CELL_IMAGE
            cell.contentView.addSubview(imageView!)
        }
        
        if (label == nil){
            label = UILabel(frame: CGRect(x:0, y:self.view.frame.width/4+5, width: self.view.frame.width/3, height: 21))
            label!.tag = TAG_CELL_LABEL
            label!.textColor = UIColor.whiteColor()
            label!.textAlignment = NSTextAlignment.Center
            label!.font = UIFont(name:"VDS", size:16.0)
            cell.contentView.addSubview(label!)
            //add constrains for the label to align center
            let xConstraint = NSLayoutConstraint(item: label!, attribute: .CenterX,
                                                 relatedBy: .Equal, toItem: imageView,
                                                 attribute: .CenterX, multiplier: 1.0,
                                                 constant: 0)

            cell.addConstraint(xConstraint)
        }


        imageView?.image = UIImage(named: imageArray[indexPath.row])

        label!.text = labelArray[indexPath.row]
        
        
        //add by eva
        imageView?.userInteractionEnabled = true
        let tapGestureRecognizer = MyTapGestureRecognizer(target: self, action: #selector(SettingCollectionViewController.tappedSettings(_:)))
        tapGestureRecognizer.index = indexPath.row
        imageView?.addGestureRecognizer(tapGestureRecognizer)

        
        
        return cell
    }
    
    let sectionInsets = UIEdgeInsets(top:10, left: 0, bottom: 10, right: 0)

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets{
        return sectionInsets
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat{
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat
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
    func tappedSettings(gestureRecognizer: MyTapGestureRecognizer)
    {
        print(gestureRecognizer.index)
        
        switch (Int(gestureRecognizer.index!)) {
        case 0://trip
            self.parentViewController!.performSegueWithIdentifier("segueToTrip", sender: nil)
            break
        case 1://ride
            self.parentViewController!.performSegueWithIdentifier("segueToRide", sender: nil)
            break
        case 2://blue tooth
            //self.parentViewController!.performSegueWithIdentifier("segueToBlueTooth", sender: nil)
            break
        case 3://safety
            self.parentViewController!.performSegueWithIdentifier("segueToSafety", sender: nil)
            break
        case 4://security info
            self.parentViewController!.performSegueWithIdentifier("segueToScooterInfo", sender: nil)
            break
        case 5://shop (website)
            self.parentViewController!.performSegueWithIdentifier("segueToShop", sender: nil)
            break
        default:
            break
        }
    }
    

}
