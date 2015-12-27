//
//  NmapXMLParser.swift
//  NetMap
//
//  Created by kyb on 24/12/15.
//  Copyright © 2015 Suborbital Softworks Ltd. All rights reserved.
//

import Foundation
import SWXMLHash

class NmapXMLParser {
    var nextNodeID: Int = 0
    
    enum ParserError : ErrorType {
        case FileOpenError(String)
        case InvalidXMLError(Int)
    }
    
    func parseXMLFile(file: String) throws -> Project {
        guard let xmldata = NSData(contentsOfFile: file) else {
            throw ParserError.FileOpenError(file)
        }
        
        let xml = SWXMLHash.parse(xmldata)
        
        self.nextNodeID = 0
        let rootNode = try self.makeTreeFromXML(xml)
        let p = Project(representedFile: file, rootNode: rootNode)
        return p
    }
}

//combat the pyramid of doom
//this will prevent if let ... getting out of hand by passing a valid default value
//which will be used when the unwrap fails
//(maybe I'm re-inventing the wheel here and Swift has this already built in?)
extension Optional {
    func value_or(val: Wrapped) -> Wrapped {
        if self != nil {
            return self!
        }
        return val
    }
}

extension NmapXMLParser {
    func makeTreeFromXML(xml: XMLIndexer) throws -> Node {
        var rootNode = Node(id: self.nextNodeID++, type: .Network)
        
        //let's just do this here
        let root = try xml.byKey("nmaprun")
        if let hname = root.element?.attributes["startstr"] {
            rootNode.hostname = hname
        } else {
            throw ParserError.InvalidXMLError(1)
        }
        
        if let addr = root.element?.attributes["args"] {
            rootNode.address = addr
        } else {
            throw ParserError.InvalidXMLError(2)
        }
        
        let hosts = root.children.filter({$0.element?.name == "host"})
        for h in hosts {
            let addresses = h.children.filter({$0.element?.name == "address"})
            let hostnames = h.children.filter({$0.element?.name == "hostnames"})
            let ports = h["ports"].children.filter({$0.element?.name == "port"})
            
            var hnode = Node(id: self.nextNodeID++, type: .Host)
            hnode.address = (addresses.first?.element?.attributes["addr"]).value_or("Unknown Address")
            hnode.hostname = (hostnames.first?.element?.attributes["name"]).value_or("Unknown Hostname")
            
            for p in ports {
                if p.element != nil {
                    var port = Port()
                    port.port = Int((p.element?.attributes["portid"]).value_or("0")).value_or(0)
                    port.proto = Port.Proto(string: (p.element?.attributes["protocol"]).value_or("Unknown"))
                    port.state = Port.State(string: (p["state"].element?.attributes["state"]).value_or("Unknown"))
                    
                    hnode.ports.append(port)
                }
            }
            
            rootNode.appendChild(hnode)
        }
        return rootNode;
    }
}