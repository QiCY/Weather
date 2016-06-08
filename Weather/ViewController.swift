//
//  ViewController.swift
//  Weather
//
//  Created by Mac Os on 16/6/2.
//  Copyright © 2016年 Mac Os. All rights reserved.
//

import UIKit
import CoreLocation



class ViewController: UIViewController,CLLocationManagerDelegate,UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,HTTPManageDelegate {
    var tableView:UITableView?
    var dataArray:NSMutableArray = NSMutableArray()
    var currentCity:String?
    var langitudeLab:UILabel?
    var latitudeLab:UILabel?
    var currentLocation:CLLocation?
    var cityLab:UILabel?
    var currentCode:String?
    var currentCityModel:AreaModel?
    let WIDTH = UIScreen.mainScreen().bounds.size.width
    let HEIGHT = UIScreen.mainScreen().bounds.size.height
    let locationManager:CLLocationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        getAreaData()
        startLocation()
       
        

        
        cityLab = UILabel(frame: CGRectMake(0,80,WIDTH ,80))
        cityLab?.textColor = UIColor.redColor()
        cityLab?.textAlignment = NSTextAlignment.Center
        cityLab?.numberOfLines = 2
        cityLab?.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(cityLab!)
        
        let resetButton = UIButton(frame: CGRectMake(0,0,80,44))
        resetButton.setTitle("Reset", forState: UIControlState.Normal)
        resetButton.setTitleColor(UIColor.brownColor(), forState: UIControlState.Normal)
        resetButton.addTarget(self, action: "startLocation", forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: resetButton)
        
        createTableView()
        QCYHTTPManage.shareInstance.requestWithUrlForGet("", target: self)
       
    }

    func didGetCityListCallBack(datalist: NSMutableArray?) {
        self.dataArray = datalist!
         self.tableView?.reloadData()
    }
    func createTableView(){
        self.tableView = UITableView(frame: CGRectMake(0, 160, WIDTH, HEIGHT - 160))
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
        
         let quname:String = (data["quName"] as? String)!
        let cname:String = (data["cityname"] as? String)!
        cell?.textLabel?.text = quname + "   " + cname
        
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
        let cityView = CityViewController()
        let data = self.dataArray[indexPath.row]
        cityView.weatherdata = data as? NSDictionary
        self.navigationController?.pushViewController(cityView, animated: true)
    }
    func getAreaData(){
//        获取地址信息文件路径
        let areaPath = NSBundle.mainBundle().pathForResource("t_area.json", ofType:nil)
        let data = try? NSData(contentsOfFile: areaPath!, options: NSDataReadingOptions.MappedRead)
        let provinceList = try?NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
//        print(provinceList)
        
        let dataList:NSArray = NSArray(array: provinceList as! NSArray)
        
        dataArray = NSMutableArray()
        //        第一层遍历省
        for   province  in dataList{
            let proModel = AreaModel()
            proModel.setData(province["pcode"] as? String, pdata: province["pdata"] as? NSArray, pname: (province["pname"] as? String)!)
            let proModelList:NSMutableArray = NSMutableArray()
            //            第二层遍历市
            for city in proModel.pdata!{
                let cityModel = AreaModel()
                cityModel.setData(city["ccode"] as? String, pdata: city["cdata"] as? NSArray, pname: (city["cname"] as? String)!)
                let cityModelList:NSMutableArray = NSMutableArray()
                //                第三层遍历区
                for area in cityModel.pdata!{
                    let areaModel = AreaModel()
                    areaModel.setData((area["dcode"] as? String), pdata: (area["pdata"] as? NSArray), pname: (area["dname"] as? String)!)
                    cityModelList.addObject(areaModel)
                }
                proModelList.addObject(cityModel)
                cityModel.pdata = cityModelList
            }
            proModel.pdata = proModelList
            dataArray.addObject(proModel)
        }

    }
    
    
    func startLocation(){
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100
        locationManager.requestAlwaysAuthorization()
        if(CLLocationManager.locationServicesEnabled()){
            locationManager.startUpdatingLocation()
            print("start update Location")
        }else{
            
            let alertView = UIAlertController(title: "提示", message: "请允许程序使用定位服务", preferredStyle: UIAlertControllerStyle.Alert)
            let cancelAction = UIAlertAction(title: "暂不设置", style: UIAlertActionStyle.Cancel, handler: { (UIAlertAction) -> Void in
                
            })
            
        
            let setAction = UIAlertAction(title: "设置", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                let url = NSURL(string: UIApplicationOpenSettingsURLString)
                UIApplication .sharedApplication().openURL(url!)
            })
            
            alertView.addAction(cancelAction)
            alertView.addAction(setAction)
            self.presentViewController(alertView, animated: true, completion: nil)
            
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
        
        langitudeLab?.text = "当前径度：\(currentLocation?.coordinate.longitude)"
        latitudeLab?.text = "当前纬度：\(currentLocation?.coordinate.latitude)"
        reverseGeocode()
    }
    func reverseGeocode(){
        let geocode = CLGeocoder()
        geocode.reverseGeocodeLocation(currentLocation!) { (placemarks: [CLPlacemark]?,error: NSError?) -> Void in
            let array = NSArray(object: "zh-hans")
            NSUserDefaults.standardUserDefaults().setObject(array, forKey: "AppletLanguages")
            if error != nil {
                self.cityLab?.text = error?.localizedDescription
                return
            }
            
            if let p = placemarks?[0]{
                self.cityLab?.text = p.name
                print(p.locality)
                
                print(p.subLocality)
                
                print(p.addressDictionary!["State"])
                
                let array1 = NSArray(array: self.dataArray)
                for provice in array1{
                    
                    let proModel = provice as? AreaModel
                    if proModel?.pname == p.addressDictionary!["State"] as? String{
                        print(proModel?.pname)
                        let cityArray = proModel?.pdata
                        for cModel in cityArray!{
                            
                            if (cModel as? AreaModel)!.pname  == p.locality{
//                                let code = (cModel as? AreaModel)!.pcode
                                self.currentCityModel = (cModel as? AreaModel)!
                                self.tableView?.reloadData()
                            }
                           
                        }

                    }
                   
                }
            }else{
                print("NO placemarks")
            }
        }
    }
    
    
//    func getWeatherInfo(code:String?){
//        QCYHTTPManage.shareInstance.requestWithUrlForGet(code!)
//    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

