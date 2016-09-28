
//
//  ViewController.swift
//  Memo1.0
//
//  Created by Ranjith on 7/9/16.
//  Copyright © 2016 Ranjith. All rights reserved.
//

import UIKit

class MainDispalyViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate{

    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imagePickView: UIImageView!
    @IBOutlet weak var cancelButon: UIBarButtonItem!
    
    var mainImage:UIImage?
    
    // need a variable for our struct in this VC
    var meme: Meme?
    var memeObject: Meme?
    
    // custom textfield attributes
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -3.0
    ]
    
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    //MARK: ViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blackColor()
        
        configurTextfield(topTextField)
        configurTextfield(bottomTextField)
        
        shareButton.enabled = false
        cancelButon.enabled = false
        
        
        

    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        let dataloaded = Record.imageSave
        
        if dataloaded.getData().count > 0 {
            cancelButon.enabled = true
        }
        
        if let imageapper = mainImage {
            imagePickView.image = imageapper
            shareButton.enabled = true
        }
        
        subscribeToKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        unsubscribeFromKeyboardNotifications()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    //MARK: Image Selector Methods
    @IBAction func pickAnImage(sender: UIBarButtonItem) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sender.tag == 1 ? UIImagePickerControllerSourceType.PhotoLibrary:UIImagePickerControllerSourceType.Camera
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
     func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
        imagePickView.image = image
        imagePickView.contentMode = .ScaleAspectFit
        self.dismissViewControllerAnimated(true, completion: nil)
        shareButton.enabled = true
    }
    }
    
    
    //MARK: share Image methods
    func generateMemedImage() -> UIImage {
        // Hide toolbar and navbar
        navigationController?.navigationBarHidden = true
        navigationController?.setToolbarHidden(true, animated: false)
        toolbar.hidden = true
        
        // render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar, again
        navigationController?.navigationBarHidden = false
        navigationController?.setToolbarHidden(false, animated: false)
        toolbar.hidden = false
        
        return memedImage
    }

    // saves the new meme
    func saveMeme() -> Meme{
        // Create the meme, by using the struct variables
        memeObject = Meme(textField1: topTextField.text!, textField2: bottomTextField.text!, image: imagePickView.image!, memedImage: generateMemedImage())
        
        return memeObject!
    }
    func presentVC(controller: UIActivityViewController){
        presentViewController(controller, animated: true, completion: nil)
    }
    
    @IBAction func shareMeme(sender: AnyObject){
        
        // instantiate activity view controller
        let activityViewController = UIActivityViewController.init(activityItems: [generateMemedImage()], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = sender as? UIView
        
        // present the view controller
        presentVC(activityViewController)
        
        // save it in the completionWithItemsHandler closure
        activityViewController.completionWithItemsHandler = {(activityType, completed:Bool, returnedItems:[AnyObject]?, error: NSError?) in
            
            // Return if cancelled
            if (!completed) {
                return
            }
            
            //activity complete
            let saveimage = Record.imageSave
            saveimage.addItem(self.saveMeme())
            //self.saveMeme()
            //self.dismissViewControllerAnimated(true, completion: nil)
            
            var controller:UITabBarController
            
            controller = self.storyboard?.instantiateViewControllerWithIdentifier("tabbarcontroller") as! UITabBarController
            self.presentViewController(controller, animated: true, completion: nil)
            
            
        }

    }
    
    //MARK: UITextField Methods / Keyboard methods
    func configurTextfield(textfield:UITextField){
        textfield.defaultTextAttributes = memeTextAttributes
        textfield.textAlignment = .Center
        textfield.delegate = self
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            self.view.frame.origin.y =  getKeyboardHeight(notification) * -1
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            self.view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    //MARK: TextField Delegation Methods
    func textFieldDidBeginEditing(textField: UITextField) {    //delegate method
        textField.text = nil
        
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        
        return true
    }
    


}

