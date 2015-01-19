//
//  ChooseViewController.swift
//  WeatherHack2
//
//  Created by zkmb on 2015-01-17.
//  Copyright (c) 2015 zkmb. All rights reserved.
//

import UIKit
import QuartzCore

class ChooseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var hintView: UIView!
    
    var cityName:String!
    var locationsArray:[JSON]! = []
    var wantToSeeArray:[JSON]! = []
    var imageCache = Dictionary<String, UIImage>()
    
    var refresh:Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        applyMediumShadow(hintView)
        
        tableView.tableFooterView = UIView(frame: CGRectMake(0, 0, tableView.bounds.width, 76))
        
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target:nil, action:nil);
    }
    
    override func viewWillAppear(animated: Bool) {
        
//        
//        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
//        tableView.contentInset = UIEdgeInsetsMake(-49, 0, 0, 0)
//        tableView.tableHeaderView = UIView(frame: CGRectMake(0, 0, tableView.bounds.width, 49))
        
        if (!refresh) {
            return;
        }
        
        refresh = false;
        
        if (cityName == nil) {
            cityName = "detroit" // set one by default
        }
        
        println(cityName)
        
        let cityNameA:String = String(format: "https://weatherhack.herokuapp.com/api/places.json?city=%@", cityName).stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true;
        
        println("asdasd: \(cityNameA)");
        
        let url = NSURL(string: cityNameA)
        println(url)
        
        let request = NSURLRequest(URL: url!)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response, data, error) in
            if (data == nil) {
                return
            }
            
            let json = JSON(data: data)
            
            self.locationsArray = json.arrayValue
            
            for i in 0...2 {
                if (i < self.locationsArray.count) {
                    self.wantToSeeArray.append(self.locationsArray.removeAtIndex(i))
                }
            }
            
            self.tableView.reloadData()
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false;
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var view = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 48))
        view.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        
        var title = UILabel(frame: CGRectMake(15, 8, 320, 40))
        title.font = UIFont(name: "HelveticaNeue-Light", size: 22)
        
//        var subheading = UILabel(frame: CGRectMake(tableView.frame.size.width - 15 - 160, 8, 160, 16))
//        subheading.font = UIFont.systemFontOfSize(15)
//        subheading.textAlignment = NSTextAlignment.Right
        
        if (section == 0) {
//            subheading.text = "Tap an item to remove"
            title.text = "Want to see"
//            view.backgroundColor = UIColor(red: 65/255, green: 255/255, blue: 35/255, alpha: 0.3)
        } else if (section == 1) {
//            subheading.text = "Tap an item to add"
            title.text = "Do not want to see"
//            view.backgroundColor = UIColor(red: 255/255, green: 163/255, blue: 175/255, alpha: 0.3)
        }
        
        //        view.addSubview(visualEffectView)
        view.addSubview(title)
//        view.addSubview(subheading)
        
        return view
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return wantToSeeArray.count
        } else if (section == 1) {
            return locationsArray.count
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("ChooseCell", forIndexPath: indexPath) as ChooseTableViewCell
        applyPlainShadow(cell.cardView)
        
        var imageUrl:String = ""
        
        if (indexPath.section == 0) {
            cell.nameLabel?.text = wantToSeeArray[indexPath.row]["name"].string
            cell.ratingLabel?.text = NSString(format: "Rating: %.1f Stars", wantToSeeArray[indexPath.row]["rating"].floatValue)
            
            imageUrl = wantToSeeArray[indexPath.row]["icon_url"].string!
        } else if (indexPath.section == 1) {
            cell.nameLabel?.text = locationsArray[indexPath.row]["name"].string
            cell.ratingLabel?.text = NSString(format: "Rating: %.1f Stars", locationsArray[indexPath.row]["rating"].floatValue)
            
            imageUrl = locationsArray[indexPath.row]["icon_url"].string!
        }
        
        println(locationsArray[indexPath.row]["icon_url"].string!)
        
        if (UIImage(named: imageUrl) != nil) {
            cell.imageView?.image = UIImage(named: imageUrl)
            return cell
        }
        
//        var fileName = "generic_business-71.png"
//        
//        if (imageUrl == "http://maps.gstatic.com/mapfiles/place_api/icons/aquarium-71.png") {
//            fileName = "aquarium-71.png"
//        } else if (imageUrl == "http://maps.gstatic.com/mapfiles/place_api/icons/art_gallery-71.png") {
//            fileName = "art_gallery-71.png"
//        } else if (imageUrl == "http://maps.gstatic.com/mapfiles/place_api/icons/generic_business-71.png") {
//            fileName = "generic_business-71.png"
//        } else if (imageUrl == "http://maps.gstatic.com/mapfiles/place_api/icons/movies-71.png") {
//            fileName = "movies-71.png"
//        } else if (imageUrl == "http://maps.gstatic.com/mapfiles/place_api/icons/museum-71.png") {
//            fileName = "museum-71.png"
//        } else if (imageUrl == "http://maps.gstatic.com/mapfiles/place_api/icons/stadium-71.png") {
//            fileName = "stadium-71.png"
//        } else if (imageUrl == "http://maps.gstatic.com/mapfiles/place_api/icons/worship_general-71.png") {
//            fileName = "worship_general-71.png"
//        }
//        
//        cell.imageView?.image = UIImage(named: fileName)
        
        
        
        
        if ((imageCache[imageUrl]) != nil) {
            cell.imageView?.image = imageCache[imageUrl]
        } else {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true;
            let priority = DISPATCH_QUEUE_PRIORITY_HIGH
            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                var image = UIImage(data: NSData(contentsOfURL: NSURL(string: imageUrl)!)!)
                self.imageCache[imageUrl] = image
                
                dispatch_sync(dispatch_get_main_queue()) {
//                    cell.imageView?.contentMode = .ScaleAspectFill
//                    cell.imageView?.clipsToBounds = true
//                    cell.imageView?.bounds = CGRectMake(0, 0, 78, 78)
                    cell.imageView?.image = image
                    cell.setNeedsLayout()
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false;
                }
            }
        }
        
        return cell;
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section == 0) {
            locationsArray.insert(wantToSeeArray.removeAtIndex(indexPath.row), atIndex: 0)
            tableView.moveRowAtIndexPath(indexPath, toIndexPath: NSIndexPath(forRow: 0, inSection: 1))
            tableView.deselectRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1), animated: true)
        } else if (indexPath.section == 1){
            wantToSeeArray.insert(locationsArray.removeAtIndex(indexPath.row), atIndex: 0)
            tableView.moveRowAtIndexPath(indexPath, toIndexPath: NSIndexPath(forRow: 0, inSection: 0))
            tableView.deselectRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), animated: true)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    func applyPlainShadow(view: UIView) {
        var layer = view.layer
        
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 1
    }
    
    func applyMediumShadow(view: UIView) {
        var layer = view.layer
        
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 2
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "PlanSegue") {
            let vc = segue.destinationViewController as PlanViewController
            vc.wantToSeeArray = self.wantToSeeArray
            vc.refresh = true
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }


}

