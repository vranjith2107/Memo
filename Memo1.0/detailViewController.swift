//
//  detailViewController.swift
//  Memo1.0
//
//  Created by Ranjith on 7/17/16.
//  Copyright © 2016 Ranjith. All rights reserved.
//

import UIKit

class detailViewController: UIViewController {

    var memeobject:Meme?
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blackColor()
        
        if let memeobjectData = memeobject {
            imageView.image = memeobjectData.memedImage
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.hidden = true
    }

    @IBAction func editButtonPressed(sender: AnyObject) {
        
        // Grab the DetailVC from Storyboard
        let object: AnyObject = self.storyboard!.instantiateViewControllerWithIdentifier("naviccontroller")
        let detailDisplay = object as! UINavigationController
        
        let mainview = detailDisplay.viewControllers[0] as! MainDispalyViewController
        
        //Populate view controller with data from the selected item
        if let memeobjectData = memeobject {
            mainview.mainImage = memeobjectData.image
        }
        
        
        // Present the view controller using navigation
        //navigationController!.pushViewController(detailVC, animated: true)
        presentViewController(detailDisplay, animated: true, completion: nil)
        
    }
}
