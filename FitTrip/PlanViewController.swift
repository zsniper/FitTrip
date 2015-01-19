//
//  PlanViewController.swift
//  WeatherHack2
//
//  Created by zkmb on 2015-01-18.
//  Copyright (c) 2015 zkmb. All rights reserved.
//

import UIKit

class PlanViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var hintView: UIView!
    var wantToSeeArray:[JSON]! = [];
    var resultsArray:[JSON]! = [];
    var tableArray:[JSON]! = [];
    var resultsIndex = 0
    
    var passname:String!
    var passaddress:String!
    var passtime:String!
    var passtags:String!
    var passOriginX:Double!
    var passOriginY:Double!
    var passDestX:Double!
    var passDestY:Double!
    
    var refresh:Bool!
    
    var progressView:SpotifyProgress!

    
    @IBAction func newTrip(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    @IBAction func handlePan(recognizer:UISwipeGestureRecognizer) {
        println("test")
        if (resultsIndex + 1 < resultsArray.count) {
            tableArray = resultsArray[++resultsIndex].arrayValue
        } else {
            tableArray = resultsArray[0].arrayValue
            resultsIndex = 0
        }
        
        tableView.reloadData()
//        let translation = recognizer.translationInView(self.view)
//        recognizer.view!.center = CGPoint(x:recognizer.view!.center.x + translation.x,
//            y:recognizer.view!.center.y + translation.y)
//        recognizer.setTranslation(CGPointZero, inView: self.view)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        applyMediumShadow(hintView)
        
        tableView.tableFooterView = UIView(frame: CGRectMake(0, 0, tableView.bounds.width, 76))
        
        progressView = SpotifyProgress(frame: CGRectMake(0, 0, 150, 150), withPointDiameter: 16, withInterval: 0.25)
        progressView.center = self.view.center;
        self.view.addSubview(progressView)
        
        progressView.hidden = true;
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        println("refresh: \(refresh)")
        if (!refresh) {
            return;
        }
        
        refresh = false;
        
        if (wantToSeeArray == nil) {
            wantToSeeArray = [];
        }
        
        if (wantToSeeArray.count == 0) {
            return;
        }
        
        var place_ids = ""
        
        println("count: \(wantToSeeArray.count)")
        
        for i in 0...(wantToSeeArray.count-1) {
            println("i: \(i)")
            place_ids += wantToSeeArray[i]["place_id"].string!
            if (i+1 < wantToSeeArray.count) {
                place_ids += ","
            }
        }
        
        let url = NSURL(string: "https://weatherhack.herokuapp.com/daytrips?place_id=\(place_ids)&start_time=1300&end_time=2200&day=Sunday")
        
        println(url)
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true;
        progressView.hidden = false;
        
        let request = NSURLRequest(URL: url!)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response, data, error) in
            if (error != nil) {
                return
            }
            
            let json = JSON(data: data)
            println(json.stringValue)
            
            self.resultsArray = json.arrayValue
            self.tableArray = self.resultsArray[0].arrayValue
            self.resultsIndex = 0
            
            self.tableView.reloadData()
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false;
            self.progressView.hidden = true;
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("PlanCell", forIndexPath: indexPath) as PlanTableViewCell
        
        if (tableArray[indexPath.row]["type"].string == "travel") {
            cell.nameLabel?.text = "Drive to next destination"
            cell.ratingLabel?.text = tableArray[indexPath.row]["time"].string
            cell.iconImageView?.image = UIImage(named: "plan-btn2.png")
        } else {
            cell.nameLabel?.text = tableArray[indexPath.row]["name"].string!;
            cell.ratingLabel?.text = tableArray[indexPath.row]["duration"].string! + " | " + tableArray[indexPath.row]["startTime"].string! + " - " + tableArray[indexPath.row]["endTime"].string!
            cell.iconImageView?.image = UIImage(named: "plan-btn1.png")
        }
        
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if (tableArray[indexPath.row]["type"].string == "travel") {
            passname = "Drive to next destination"
            passaddress = ""
            passtime = tableArray[indexPath.row]["time"].string
            passtags = ""
            passOriginX = tableArray[indexPath.row]["origin"][0].doubleValue
            passOriginY = tableArray[indexPath.row]["origin"][1].doubleValue
            passDestX = tableArray[indexPath.row]["destination"][0].doubleValue
            passDestY = tableArray[indexPath.row]["destination"][1].doubleValue
        } else {
            passname = tableArray[indexPath.row]["name"].string!
            passaddress = tableArray[indexPath.row]["address"].string!
            passtime = tableArray[indexPath.row]["duration"].string! + " | " + tableArray[indexPath.row]["startTime"].string! + " - " + tableArray[indexPath.row]["endTime"].string!
            passtags = ""//"Tags: " + tableArray[indexPath.row]["tags"].string!
            passOriginX = 0
            passOriginY = 0
            passDestX = 0
            passDestY = 0
        }
        
        
        self.performSegueWithIdentifier("Details", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "Details") {
            let vc = segue.destinationViewController as DetailViewController
            vc.name = passname
            vc.address = passaddress
            vc.time = passtime
            vc.tags = passtags
            vc.originX = passOriginX
            vc.originY = passOriginY
            vc.destX = passDestX
            vc.destY = passDestY
        }
    }
    
    
    func applyMediumShadow(view: UIView) {
        var layer = view.layer
        
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 2
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

}
