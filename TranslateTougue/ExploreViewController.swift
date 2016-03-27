//
//  ExploreViewController.swift
//  TranslateTougue
//
//  Created by Serx on 16/3/27.
//  Copyright © 2016年 serxlee. All rights reserved.
//

import UIKit
import Accounts
import Social

class ExploreViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        initExploreTableView()
        refreshExplore(refreshControl!)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initExploreTableView() {
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        accessUserAccount()
    }
    
    @IBAction func refreshExplore(sender: UIRefreshControl) {
        let connected  = Reachability.isConnectedToNetwork()
        if connected {
            sender.beginRefreshing()
            getExploreTweets()
            reloadExploreTableView()
            sender.endRefreshing()
        } else {
            openSettingsApp(self)
        }
    }
    
    // Access Twitter account
    var twitterAccount: ACAccount!
    var accessedAccount: Bool = false
    
    func accessUserAccount() {
        let account = ACAccountStore()
        let accountType = account.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        account.requestAccessToAccountsWithType(accountType, options: nil, completion: { (success: Bool, error: NSError!) -> Void in
            if success {
                let arrayOfAccounts = account.accountsWithAccountType(accountType)
                if arrayOfAccounts.count > 0 {
                    self.twitterAccount = arrayOfAccounts.last as! ACAccount
                    self.accessedAccount = true
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
    
    var dataSource: NSDictionary?
    var dataAsArrays: [AnyObject] = []
    func getExploreTweets() {
        if accessedAccount {
            let keyWords: [String] = [
                "love", "cute", "sweet", "beauty", "hot",
                "amazing", "great", "awesome", "baby", "lol",
                "iPad"
            ]
            let random: Int = Int(arc4random_uniform(10)) + 1
            
            let searchText: String = keyWords[random]
            
            let searchUrl = NSURL(string: "https://api.twitter.com/1.1/search/tweets.json")
            
            let parameters = [
                "q": searchText,
                "result_type": "recent",
                "count": "30"
            ]
            
            let postRequest = SLRequest(
                forServiceType: SLServiceTypeTwitter,
                requestMethod: SLRequestMethod.GET,
                URL: searchUrl,
                parameters: parameters
            )
            
            postRequest.account = self.twitterAccount
            
            postRequest.performRequestWithHandler({ (responseData: NSData!, urlResponse: NSHTTPURLResponse!, error: NSError!) -> Void in
                do {
                    self.dataSource =  try NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.MutableLeaves) as? NSDictionary
                    self.dataAsArrays = self.dataSource!["statuses"] as! [AnyObject]
                } catch {
                    debugPrint(error)
                }
            })
        }
    }
    
    func reloadExploreTableView() {
        if self.dataAsArrays.count != 0 {
            cacheSearchProfileImage()
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        }
    }
    
    var exploreProfileImages = [UIImage]()
    func cacheSearchProfileImage() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            for number in 0 ..< self.dataAsArrays.count {
                let singerTweet: NSDictionary! = self.dataAsArrays[number] as! NSDictionary
                var urlString: String! = singerTweet["user"]!["profile_image_url_https"] as! String
                if urlString.rangeOfString("normal.png") != nil {
                    urlString = urlString.stringByReplacingOccurrencesOfString("normal.png", withString: "400x400.png")
                } else if urlString.rangeOfString("normal.jpg") != nil {
                    urlString = urlString.stringByReplacingOccurrencesOfString("normal.jpg", withString: "400x400.jpg")
                } else {
                    urlString = urlString.stringByReplacingOccurrencesOfString("normal.jpeg", withString: "400x400.jpeg")
                }
                let url = NSURL(string: urlString)
                if let imageData = NSData(contentsOfURL: url!) {
                    self.exploreProfileImages.append(UIImage(data: imageData)!)
                }
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataAsArrays.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "homeTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! HomeTableViewCell
        
        let row = indexPath.row
        let tweetContent = self.dataAsArrays[row] as! NSDictionary
        
        let userInfo = tweetContent["user"] as! NSDictionary
        cell.homeTweetNameLabel.text = userInfo["name"] as? String
        
        let screenName = userInfo["screen_name"] as! String
        cell.homeTweetScreenNameLabel.text = "@" + screenName
        
        if let verify = userInfo["verified"] as? Int {
            cell.homeTweetAccountVerified = verify == 1 ? true : false
        }
        
        if exploreProfileImages.count > row {
            cell.homeTweetProfileImageView.image = exploreProfileImages[row]
        }
        
        cell.homeTweetTextLabel.text = tweetContent["text"] as? String
        
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
}
