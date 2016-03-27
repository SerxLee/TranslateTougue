//
//  Preparation.swift
//  TranslateTougue
//
//  Created by Serx on 16/3/27.
//  Copyright © 2016年 serxlee. All rights reserved.
//

import UIKit
import SystemConfiguration
import Social
import Accounts

public class Reachability {
    class func isConnectedToNetwork() -> Bool {
        // Check internet connection
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}

// Show alert to open Settings app
public func openSettingsApp(viewController: UIViewController) {
    let alert = UIAlertController(title: "Unable to connect Internet", message: "Open Settings to enable Internet connection?", preferredStyle: .Alert)
    let openSettings = UIAlertAction(title: "Settings", style: .Default, handler: { (_) -> Void in
        if let settingsUrl = NSURL(string: UIApplicationOpenSettingsURLString) {
            UIApplication.sharedApplication().openURL(settingsUrl)
        }
    })
    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
    alert.addAction(cancelAction)
    alert.addAction(openSettings)
    viewController.presentViewController(alert, animated: true, completion: nil)
}

public func accessTwitterAccount(viewController: UIViewController) -> (access: Bool, account: ACAccount?) {
    var twitterAccount: ACAccount?
    var accessAccount: Bool = false
    let account = ACAccountStore()
    let accountType = account.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
    account.requestAccessToAccountsWithType(accountType, options: nil, completion: { (success: Bool, error: NSError!) -> Void in
        if success {
            let arrayOfAccounts = account.accountsWithAccountType(accountType)
            if arrayOfAccounts.count > 0 {
                accessAccount = true
                twitterAccount = arrayOfAccounts.last as? ACAccount
            }
        } else {
            accessAccount = false
            let alert = UIAlertController(title: "Error", message: "Failed to access Twitter account", preferredStyle: .ActionSheet)
            let cancelAlert = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            alert.addAction(cancelAlert)
            viewController.presentViewController(alert, animated: true, completion: nil)
            debugPrintItem("Failed to access account")
        }
    })
    return (accessAccount, twitterAccount)
}

public func getTweets(url: NSURL, parameters: [String: NSObject], account: ACAccount) -> [AnyObject] {
    let postRequest = SLRequest(
        forServiceType: SLServiceTypeTwitter,
        requestMethod: SLRequestMethod.GET,
        URL: url,
        parameters: parameters
    )
    postRequest.account = account
    var dataSource: [AnyObject] = []
    postRequest.performRequestWithHandler({ (responseData: NSData!, urlResponse: NSHTTPURLResponse!, error: NSError!) -> Void in
        do {
            dataSource =  try NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.MutableLeaves) as! [AnyObject]
        } catch {
            debugPrintItem(error)
        }
    })
    return dataSource
}

public func debugPrintItem(@autoclosure item: () -> Any) {
    #if DEBUG
        debugPrint(item)
    #endif
}
