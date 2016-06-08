//
//  XmlReader.swift
//  Weather
//
//  Created by Mac Os on 16/6/3.
//  Copyright © 2016年 Mac Os. All rights reserved.
//

import UIKit

class XmlReader: NSObject,NSXMLParserDelegate {
    var currentName:String? = nil
    var level:Int = 0
    var contentString:String?=nil
    var cityList:NSMutableArray = NSMutableArray()
    init(add:String) {
        super.init()
        let url = NSURL(string: add)
        guard let parserXML = NSXMLParser(contentsOfURL: url!) else{
            return
        }
        
        
        parserXML.delegate = self
        parserXML.parse()
    }
    
    init(data:NSData){
        super.init()

        let parserXML = NSXMLParser(data: data)         
        
        parserXML.delegate = self
        parserXML.parse()
    }
    func parserDidStartDocument(parser: NSXMLParser) {
        print("start parser")
        cityList.removeAllObjects()
    }
    func parserDidEndDocument(parser: NSXMLParser) {
        print("end parser")
    }
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        self.currentName = elementName
//        print(attributeDict)
        if elementName == "city"{
           
            cityList.addObject(attributeDict)
        }
        
        self.level++
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        self.currentName = nil
        print(qName)
        self.level--
        print(self.cityList)
    }
    func parser(parser: NSXMLParser, foundCharacters string: String) {
//        self.contentString = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        print(string)
        if string.isEmpty{
            return
        }
    }
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        
    }
}
