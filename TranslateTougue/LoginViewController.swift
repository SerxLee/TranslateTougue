//
//  ViewController.swift
//  TranslateTougue
//
//  Created by Serx on 16/3/27.
//  Copyright © 2016年 serxlee. All rights reserved.
//

import UIKit
import Accounts
import Social
import AFNetworking
import MJRefresh


class LoginViewController: UIViewController {

    let manager = AFHTTPSessionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        accessUserAccount()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        

    }
    
    // Access Twitter account
    var twitterAccount: ACAccount!
    var accessedAccount: Bool = false
    
    func accessUserAccount() {
        print("yse1")

        let account = ACAccountStore()
        let accountType = account.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        account.requestAccessToAccountsWithType(accountType, options: nil, completion: { (success: Bool, error: NSError!) -> Void in
            if success {
                let arrayOfAccounts = account.accountsWithAccountType(accountType)
                if arrayOfAccounts.count > 0 {
                    self.twitterAccount = arrayOfAccounts.last as! ACAccount
                    self.accessedAccount = true
                    print("yse")
                }
            } else {
                self.accessedAccount = false
                let alert = UIAlertController(title: "Error", message: "Failed to access Twitter account", preferredStyle: .ActionSheet)
                let cancelAlert = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                alert.addAction(cancelAlert)
                self.presentViewController(alert, animated: true, completion: nil)
                debugPrintItem("Failed to access account")
            }
        })
    }
    @IBAction func loginTweet(sender: UIButton) {
        
        NSLog("here")
        performSegueWithIdentifier("turnToHome", sender: nil)
    }
    
    
    //
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        NSLog("in")

        if segue.identifier == "turnToHome"{
            
            let tabBarController = segue.destinationViewController as! UITabBarController
            let destinationViewController = tabBarController.viewControllers![0] as! UINavigationController
//            destinationViewController.twitterAccount = self.twitterAccount
//            destinationViewController.accessedAccount = self.accessedAccount
            
            let nextViewController = destinationViewController.topViewController as! HomeTableViewController
            
            nextViewController.twitterAccount = self.twitterAccount
            nextViewController.accessedAccount = self.accessedAccount
        }
    }
}

