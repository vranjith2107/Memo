//
//  MainCollectionViewController.swift
//  Memo1.0
//
//  Created by Ranjith on 7/17/16.
//  Copyright © 2016 Ranjith. All rights reserved.
//

import UIKit

class MainCollectionViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    let dataloaded = Record.imageSave
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataloaded.getData());
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.hidden = false
    }

    //MARK: CollectionView Delegate and DataSource Methods
     func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataloaded.getData().count
    }
    
    //3
     func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CustomMemeCell", forIndexPath: indexPath)
        let meme = dataloaded.getData()[indexPath.row]
        //cell.setText(meme.top, bottomString: meme.bottom)
        let imageView = UIImageView(image: meme.image)
        cell.backgroundView = imageView
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        // Grab the DetailVC from Storyboard
        let object: AnyObject = self.storyboard!.instantiateViewControllerWithIdentifier("detailView")
        let detailVC = object as! detailViewController
        
        //Populate view controller with data from the selected item
        detailVC.memeobject = dataloaded.getData()[indexPath.row]
        
        // Present the view controller using navigation
        navigationController!.pushViewController(detailVC, animated: true)
    }
}
