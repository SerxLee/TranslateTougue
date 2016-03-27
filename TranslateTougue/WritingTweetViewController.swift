//
//  WritingTweetViewController.swift
//  TranslateTougue
//
//  Created by Serx on 16/3/27.
//  Copyright © 2016年 serxlee. All rights reserved.
//

import UIKit
import Social
import Accounts
import QuartzCore
import Photos

class WritingTweetViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var homeTweetingTextView: RoundedRectangleTextView!
    @IBOutlet weak var homeTweetingCountLabel: RoundedRectangleLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeTweetingTextView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func cancleWritingTween(sender: UIBarButtonItem) {
        
        homeTweetingCountLabel.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        homeTweetingTextView.textColor = UIColor.darkTextColor()
        homeTweetingTextView.text.removeAll()
        return true
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if textView == homeTweetingTextView {
            if textView.text != nil {
                let charNumber = textView.text.utf16.count + text.utf16.count - range.length
                homeTweetingCountLabel.text = "\(140 - charNumber)"
            }
        }
        return true
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        homeTweetingTextView.resignFirstResponder()
    }
    
    @IBAction func writingCamera(sender: UIBarButtonItem) {
        
        homeTweetingTextView.resignFirstResponder()
        
        let picker = UIImagePickerController()
        let camera = UIImagePickerControllerSourceType.Camera
        
        if UIImagePickerController.isSourceTypeAvailable(camera){
            picker.sourceType = camera
            
            let frontCamera = UIImagePickerControllerCameraDevice.Front
            let rearCamera = UIImagePickerControllerCameraDevice.Rear
            
            if UIImagePickerController.isCameraDeviceAvailable(rearCamera){
                picker.cameraDevice = rearCamera
            }else{
                picker.cameraDevice = frontCamera
            }
            picker.delegate = self
            presentViewController(picker, animated: true, completion: nil)
        }
    }
    
    
    
}
