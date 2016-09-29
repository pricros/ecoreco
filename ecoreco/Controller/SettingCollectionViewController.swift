//
//  SettingCollectionViewController.swift
//  ecoreco
//
//  Created by admin on 2016/8/18.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

private let reuseIdentifier = "cell"

class SettingCollectionViewController: UICollectionViewController {

    let TAG_CELL_IMAGE:Int = 100
    let TAG_CELL_LABEL:Int = 200

    var labelArray = ["RIDE","SECURITY","SAFETY","BLUETOOTH","MAINTENANCE","SHOP"]

    var imageArray = ["sns_icon_24","sns_icon_24","sns_icon_24","sns_icon_24","sns_icon_24","sns_icon_24"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

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

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)

        var label:UILabel? = cell.contentView.viewWithTag(TAG_CELL_LABEL) as? UILabel
        // Configure the cell
        var imageView:UIImageView? = cell.contentView.viewWithTag(TAG_CELL_IMAGE) as? UIImageView

        if (label == nil){
            label = UILabel(frame: CGRect(x:29, y:71, width: 84, height: 21))
            label!.tag = TAG_CELL_LABEL
            cell.contentView.addSubview(label!)
        }

        if (imageView == nil){
            imageView = UIImageView(frame: CGRectMake(20, 10, 60, 60));
            imageView!.tag = TAG_CELL_IMAGE
            cell.contentView.addSubview(imageView!)
        }

        imageView?.image = UIImage(named: imageArray[indexPath.row])

        label!.text = labelArray[indexPath.row]
        return cell
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

}
