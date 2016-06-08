//
//  CityViewController.swift
//  Weather
//
//  Created by Mac Os on 16/6/3.
//  Copyright © 2016年 Mac Os. All rights reserved.
//

import UIKit

class CityViewController: UIViewController,UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,HTTPManageDelegate {
    var weatherdata:NSDictionary?
    var tableView:UITableView?
    var dataArray:NSMutableArray = NSMutableArray()
    let WIDTH = UIScreen.mainScreen().bounds.size.width
    let HEIGHT = UIScreen.mainScreen().bounds.size.height
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = weatherdata!["quName"] as? String
        self.view.backgroundColor = UIColor.whiteColor()
        createTableView()
        QCYHTTPManage.shareInstance.requestWithUrlForGetCityList((weatherdata!["pyName"] as? String)!, target: self)
        // Do any additional setup after loading the view.
    }
    func didGetCityListCallBack(datalist: NSMutableArray?) {
        self.dataArray = datalist!
        self.tableView?.reloadData()
    }
    func createTableView(){
        self.tableView = UITableView(frame: CGRectMake(0, 0, WIDTH, HEIGHT ))
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.tableFooterView = UIView()
        self.view.addSubview(self.tableView!)
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellid = "cellid"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellid)
        if cell == nil{
            cell = UITableViewCell(style:UITableViewCellStyle.Subtitle, reuseIdentifier: cellid)
        }
        let data = self.dataArray[indexPath.row]
        
        let quname:String = (data["cityname"] as? String)!
        
        cell?.textLabel?.text = quname
        
        let detailed:String = (data["stateDetailed"] as? String)!
        let windState:String = (data["windState"] as? String)!
        let tem1:String = (data["tem1"] as? String)!
        let tem2:String = (data["tem2"] as? String)!
        
        
        cell?.detailTextLabel?.text = detailed + windState + "   温度:  "+tem2+"~"+tem1
        cell?.selectionStyle = UITableViewCellSelectionStyle.None
        cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 56
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//         let data1 = self.dataArray[indexPath.row]
//        QCYHTTPManage.shareInstance.requestWithUrlForGetCityInfo((data1["url"] as? String)!, target: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
