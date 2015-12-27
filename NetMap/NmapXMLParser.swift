//
//  NmapXMLParser.swift
//  NetMap
//
//  Created by kyb on 24/12/15.
//  Copyright © 2015 Suborbital Softworks Ltd. All rights reserved.
//

import Foundation

class NmapXMLParser : NSObject, NSXMLParserDelegate {
    var nextNodeID: Int = 0
    
    enum ParserError : ErrorType {
        case FileOpenError(String)
        case InvalidXMLError
    }
    
    func parseXMLFile(file: String) throws -> Project {
        guard let xmldata = NSData(contentsOfFile: file) else {
            throw ParserError.FileOpenError(file)
        }
        let parser = NSXMLParser(data: xmldata)
        parser.delegate = self
        
        self.nextNodeID = 0
        let rootNode = try self.makeTree()
        let p = Project(representedFile: file, rootNode: rootNode)
        return p
    }
}

//MARK: - nsxmlparser delegate
extension NmapXMLParser {
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        NSLog("start: \(elementName)")
    }
}

extension NmapXMLParser {
    func makeTree() throws -> Node {
        
        var rootNode = Node(id: self.nextNodeID++, type: .Network)
        rootNode.address = "10.0.0.0/24"
        rootNode.hostname = "Localnet"
        
        var router = Node(id: self.nextNodeID++, type: .Host)
        router.address = "10.0.0.1"
        router.hostname = "nighthawk.local"
        rootNode.appendChild(router)
        
        
        var rpi = Node(id: self.nextNodeID++, type: .Host)
        rpi.address = "10.0.0.2"
        rpi.hostname = "raspberrypi.local"
        rootNode.appendChild(rpi)
        
        var hans = Node(id: self.nextNodeID++, type: .Host)
        hans.address = "10.0.0.4"
        hans.hostname = "hans.local"
        rootNode.appendChild(hans)
        
        var franz = Node(id: self.nextNodeID++, type: .Host)
        franz.address = "10.0.0.6"
        franz.hostname = "franz.local"
        rootNode.appendChild(franz)
        
        var macbook = Node(id: self.nextNodeID++, type: .Host)
        macbook.address = "10.0.0.11"
        macbook.hostname = "ducks-macbook.local"
        rootNode.appendChild(macbook)
        
        var weles = Node(id: self.nextNodeID++, type: .Host)
        weles.address = "10.0.0.23"
        weles.hostname = "weles.celestialmachines.com"
        rootNode.appendChild(weles)
        
        return rootNode
    }
}