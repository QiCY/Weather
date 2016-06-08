//
//  AreaModel.swift
//  Weather
//
//  Created by Mac Os on 16/6/2.
//  Copyright © 2016年 Mac Os. All rights reserved.
//

import UIKit

class AreaModel: NSObject {
    var pcode:String?
    var pdata:NSArray?
    var pname:String?
    func setData(pcode:String?, pdata:NSArray?,  pname:String){
        self.pcode = pcode
        self.pdata = pdata
        self.pname = pname
    }
}

class CityWeatherModel:NSObject {
    var cityname:String?
    var pyname:String?
    var state1:Int?
    var state2:Int?
    var statedetailed:String?
    var tem1:Int?
    var tem2:Int?
    var winstate:String?
    
     init(cityname:String?, pyname:String?, state1:Int?, state2:Int?, statedetailed:String?, tem1:Int?, tem2:Int?, winstate:String?){
        
        super.init()
        self.cityname = cityname
        self.pyname = pyname
        self.state1 = state1
        self.state2 = state2
        self.statedetailed = statedetailed
        self.winstate = winstate
        self.tem1 = tem1
        self.tem2 = tem2
    }
}