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
        var rootNode = Node(id: self.nextNodeID, type: .Host)
        rootNode.address = "127.0.0.1"
        rootNode.hostname = "Localhorst"
        
        //really, let's remove ++ ... m(
        self.nextNodeID = self.nextNodeID + 1
        return rootNode
    }
}