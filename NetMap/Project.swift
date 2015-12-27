//
//  Project.swift
//  NetMap
//
//  Created by kyb on 24/12/15.
//  Copyright © 2015 Suborbital Softworks Ltd. All rights reserved.
//

import Foundation

class Project {
    let representedFile: String
    let rootNode: Node
  
    //later:
    //var filter ...
    
    init(representedFile: String, rootNode: Node) {
        self.representedFile = representedFile
        self.rootNode = rootNode
    }
}

//MARK: - public
extension Project {
    //the root node with our filter applied
    var filteredRoot: Node {
        get {
            return self.filtered(rootNode)
        }
    }
}

//MARK: - filtering
extension Project {
    internal func nodeConformsToFilter(node: Node) -> Bool {
        //nodes with children always are to be included
        if node.children.count > 0 {
            return true
        }
        
        //apply self.filter
//        if node.ports.filter({$0.state == Port.State.Open && [80, 21, 25, 22, 443].contains($0.port)}).count > 0 {
//            return true
//        }
        
        if node.hasOpenPorts() {
            return true
        }
        
        //default: DENIED
        return false
    }
    
    internal func filtered(root: Node) -> Node {
        var node = root
        node.children = node.children.filter({nodeConformsToFilter($0)})
        
        for var i = 0; i < node.children.count; i++ {
            node.children[i] = self.filtered(node.children[i])
        }
        
        return node
    }
}

