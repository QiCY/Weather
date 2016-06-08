//
//  QCYHTTPManage.swift
//  Weather
//
//  Created by Mac Os on 16/6/2.
//  Copyright © 2016年 Mac Os. All rights reserved.
//

import UIKit

@objc protocol HTTPManageDelegate:NSObjectProtocol{
  
    optional  func didGetCityListCallBack(datalist:NSMutableArray?)->Void
    optional  func didGetCityInfoCallBack(datalist:NSMutableArray?)->Void
}




class QCYHTTPManage: NSObject {
    
    var delegate:HTTPManageDelegate?
    static let shareInstance = QCYHTTPManage()
    let WEATHER_URL:String = "http://flash.weather.com.cn/wmaps/xml/china.xml"
    let WEATHER_CITY:String = "http://flash.weather.com.cn/wmaps/xml/"
    let WEATHER_IMG:String = "http://m.weather.com.cn/img/"
    let WEATHER_INFO:String = "http://m.weather.com.cn/data/cityinfo/"
//    let WEATHER_URL:String = "http://www.baidu.com/"
    private override init() {
        
    }
    
    func requestWithUrlForGet(urlString:String, target:HTTPManageDelegate?){
        self.delegate = target
        let url:NSURL = NSURL(string: WEATHER_URL)!
        let request:NSURLRequest = NSURLRequest(URL: url)
        let session:NSURLSession = NSURLSession.sharedSession()
        let array = NSMutableArray()

        let dataTask = session.dataTaskWithRequest(request) { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            
            if data != nil{
            let praser =  XmlReader(data: data!)
                print(praser.cityList)
               array.removeAllObjects()
                array.addObjectsFromArray(praser.cityList as [AnyObject])
            }else{
                print(error?.description)
                
            }
            if self.delegate != nil{
                self.delegate?.didGetCityListCallBack!(array)
            }

            
        }
        dataTask.resume()
       
    }
    
    func requestWithUrlForGetCityList(urlString:String, target:HTTPManageDelegate?){
        self.delegate = target
        let url:NSURL = NSURL(string: WEATHER_CITY+urlString+".xml")!
        let request:NSURLRequest = NSURLRequest(URL: url)
        let session:NSURLSession = NSURLSession.sharedSession()
        let array = NSMutableArray()
        
        let dataTask = session.dataTaskWithRequest(request) { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            
            if data != nil{
                let praser =  XmlReader(data: data!)
                print(praser.cityList)
                array.removeAllObjects()
                array.addObjectsFromArray(praser.cityList as [AnyObject])
            }else{
                print(error?.description)
                
            }
            if self.delegate != nil{
                self.delegate?.didGetCityListCallBack!(array)
            }
            
            
        }
        dataTask.resume()
        
    }

    func requestWithUrlForGetCityInfo(urlString:String, target:HTTPManageDelegate?){
        self.delegate = target
        let url:NSURL = NSURL(string: WEATHER_INFO+urlString+".html")!
        let request:NSURLRequest = NSURLRequest(URL: url)
        let session:NSURLSession = NSURLSession.sharedSession()
        let array = NSMutableArray()
        
        let dataTask = session.dataTaskWithRequest(request) { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            
            if data != nil{
                let dataInfo = try?NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                
                
//                array.addObjectsFromArray(praser.cityList as [AnyObject])
            }else{
                print(error?.description)
                
            }
            if self.delegate != nil {
                if (self.delegate?.respondsToSelector("didGetCityInfoCallBack:") == true){
                    self.delegate?.didGetCityInfoCallBack!(array)
                }
                
            }
            
            
        }
        dataTask.resume()
        
    }

}
