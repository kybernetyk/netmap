//
//  NmapXMLParser.swift
//  NetMap
//
//  Created by kyb on 24/12/15.
//  Copyright © 2015 Suborbital Softworks Ltd. All rights reserved.
//

import Foundation

class NmapXMLParser {
    var nextNodeID: Int = 0
    
    func parseXMLFile(file: String) -> Project? {
        self.nextNodeID = 0

        guard let rootNode = self.makeTree() else {
            return nil
        }
        
        let p = Project(representedFile: file, rootNode: rootNode)
        return p
    }
}

extension NmapXMLParser {
    func makeTree() -> Node? {
        var rootNode = Node(id: self.nextNodeID++, type: .Network)
        rootNode.address = "10.0.0.0/24"
        rootNode.hostname = "Localnet"

        var router = Node(id: self.nextNodeID++, type: .Host)
        router.address = "10.0.0.1"
        router.hostname = "nighthawk.local"


        var rpi = Node(id: self.nextNodeID++, type: .Host)
        rpi.address = "10.0.0.2"
        rpi.hostname = "raspberrypi.local"
        router.appendChild(rpi)

        rootNode.appendChild(router)

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