//
//  HomeTableViewController.swift
//  TranslateTougue
//
//  Created by Serx on 16/3/27.
//  Copyright © 2016年 serxlee. All rights reserved.
//

import UIKit
import Social
import Accounts
import AFNetworking
import MJRefresh

public var fanyiString: String = ""

class HomeTableViewController: UITableViewController{

    var limIndexPath: NSIndexPath!
    
    var accessedAccount: Bool = false
    var twitterAccount: ACAccount!
        
    let header = MJRefreshNormalHeader()
    let footer = MJRefreshAutoFooter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initHomeTableView()
        getHomeTimeline()
        //
        header.setRefreshingTarget(self, refreshingAction: Selector("headerRefresh"))
        self.tableView.mj_header = header
        
        //
        footer.setRefreshingTarget(self, refreshingAction: Selector("footerRefresh"))
        self.tableView.mj_footer = footer
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    func refreshTranslate(){
        let alert = UIAlertController(title: "翻译", message: fanyiString, preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel, handler: nil)
        
        alert.addAction(okAction)
        
        alert.showDetailViewController(alert, sender: nil)
    }
    

    func initHomeTableView(){
        self.tableView.estimatedRowHeight = tableView.rowHeight
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }

    
    func headerRefresh(){
        
        NSLog("下拉刷新")
        reloadHomeTableView()
                
        self.tableView.mj_header.endRefreshing()
    }
    
    var index = 0
    func footerRefresh(){
 
        print("上拉刷新")
        self.tableView.mj_footer.endRefreshing()
        
        index = index + 1
        if index > 2 {
            footer.endRefreshingWithNoMoreData()
        }
    }
    
    
    func reloadHomeTableView() {
        if self.dataSource.count != 0 {
            cacheHomeProfileImage()
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
        }
    }
    
    // MARK: Cache profile images at background
    var homeProfileImages = [UIImage]()
    
    func cacheHomeProfileImage() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            for i in 0 ..< self.dataSource.count {
                let singerTweet: NSDictionary! = self.dataSource[i] as! NSDictionary
                var urlString: String! = singerTweet["user"]!["profile_image_url_https"] as! String
                if urlString.rangeOfString("normal.png") != nil {
                    urlString = urlString.stringByReplacingOccurrencesOfString("normal.png", withString: "400x400.png")
                } else if urlString.rangeOfString("normal.jpg") != nil {
                    urlString = urlString.stringByReplacingOccurrencesOfString("normal.jpg", withString: "400x400.jpg")
                } else {
                    urlString = urlString.stringByReplacingOccurrencesOfString("normal.jpeg", withString: "400x400.jpeg")
                }
//                print(urlString)
                let url = NSURL(string: urlString)
                if let imageData = NSData(contentsOfURL: url!) {
                    self.homeProfileImages.append(UIImage(data: imageData)!)
                }
            }
        }
    }
    
    var dataSource = [AnyObject]()
    
    func getHomeTimeline() {
        if accessedAccount {
            let requestURL = NSURL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")
            let parameters = [
                "trim_user": true,
                "count": "50"
            ]
            
            let postRequest = SLRequest(
                forServiceType: SLServiceTypeTwitter,
                requestMethod: SLRequestMethod.GET,
                URL: requestURL,
                parameters: parameters
            )
            
            postRequest.account = self.twitterAccount
            postRequest.performRequestWithHandler({ (responseData: NSData!, urlResponse: NSHTTPURLResponse!, error: NSError!) -> Void in
                do {
                    self.dataSource =  try NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.MutableLeaves) as! [AnyObject]
                } catch {
                    debugPrintItem(error)
                }
            })
        }
    }
    
    
    /*
        set the table view
    */
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataSource.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "homeTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! HomeTableViewCell
        
        let row = indexPath.row
        let tweetContent = self.dataSource[row] as! NSDictionary
        

        cell.homeTweetTextLabel.text = tweetContent["text"] as? String
        
        cell.homeTweetID = tweetContent["id"] as? Int
        
        // Tweet user info
        let userInfo = tweetContent["user"] as? NSDictionary
        
        let screenName = userInfo?["screen_name"] as? String
        cell.homeTweetScreenNameLabel.text = "@" + screenName!
        
        let name = userInfo?["name"] as! String
        cell.homeTweetNameLabel.text = name
        
        if let verify = userInfo?["verified"] as? Int {
            cell.homeTweetAccountVerified = verify == 1 ? true : false
        }
        
        
        // Profile image
        if homeProfileImages.count > row {
            cell.homeTweetProfileImageView.image = homeProfileImages[row]
        }
        if var date = tweetContent["created_at"] as? String {
            date = date.substringFromIndex(date.startIndex.advancedBy(4))
            let cutDate = String(date.characters.prefix(6))
            
            let currentDate = NSDate()
            let formatter = NSDateFormatter()
            formatter.dateStyle = .MediumStyle
            var currentDay = formatter.stringFromDate(currentDate)
            currentDay = String(String(currentDay).characters.prefix(6))
            
            if cutDate == currentDay {
                date = date.substringFromIndex(date.startIndex.advancedBy(7))
                date = String(date.characters.prefix(5))
            } else {
                date = cutDate
            }
            cell.homeTweetDateLabel.text = date
        }
        
        // Retweet and Like
        
        cell.homeTweetRetweetButton.imageView?.image = UIImage(named: "blackRetweet")
        if let retweeted = tweetContent["retweeted"] as? Int {
            if retweeted == 1 {
                cell.homeTweetRetweetButton.imageView?.image = UIImage(named: "blueRetweet")
            }
        }
        
        cell.homeTweetLikeButton.imageView?.image = UIImage(named: "blackHeart")
        if let likeed = tweetContent["favorited"] as? Int {
            if likeed == 1 {
                cell.homeTweetLikeButton.imageView?.image = UIImage(named: "redHeart")
            }
        }
        
        cell.homeTweetRetweetCountLabel.text = ""
        if let retweetCount = tweetContent["retweet_count"] as? Int {
            if retweetCount != 0 {
                cell.homeTweetRetweetCountLabel.text = String(retweetCount)
            }
        }
        cell.homeTweetLikeCountLabel.text = ""
        if let likeCount = tweetContent["favorite_count"] as? Int {
            if likeCount != 0 {
                cell.homeTweetLikeCountLabel.text = String(likeCount)
            }
        }
        return cell

    }
    

    /*
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let content = tableView.cellForRowAtIndexPath(indexPath) as! HomeTableViewCell
        let tweetString = content.homeTweetTextLabel.text!
        
        let translate = Translate()
        translate.startTranslate(tweetString)
        
        let alert = UIAlertController(title: "翻译", message: fanyiString, preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel, handler: nil)
        
        alert.addAction(okAction)
        
        presentViewController(alert, animated: true, completion: nil)

    }

    */
    
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let translateAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "翻译") { (action:UITableViewRowAction, indexPath:NSIndexPath) -> Void in
            let content = tableView.cellForRowAtIndexPath(indexPath) as! HomeTableViewCell
            let tweetString = content.homeTweetTextLabel.text!
            
            self.limIndexPath = indexPath
            
            let translate = Translate()
            translate.startTranslate(tweetString)
            
            let alert = UIAlertController(title: "翻译", message: fanyiString, preferredStyle: UIAlertControllerStyle.Alert)
            
            let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel, handler: nil)
            
            alert.addAction(okAction)
            
            self.presentViewController(alert, animated: true, completion: nil)

//            self.refreshTranslate()
            
        }
        return [translateAction]
    }
    
    

}
