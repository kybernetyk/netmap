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
    fileprivate let rootNode: Node
    
    fileprivate var nodeFilter: (Node) -> Bool = { node in
//        return node.hasOpenPorts()
        
//        return node.openPorts().contains {$0.port == 22}
        
        return node.ports.filter{ port in
            port.state == .open && [80, 443, 8080, 8000].contains(port.rawValue)
        }.count > 0
    }
  
    //later:
    //var filter ...
    
    init(representedFile: String, rootNode: Node) {
        self.representedFile = representedFile
        self.rootNode = rootNode
    }
}

//MARK: - public
extension Project {
    //TODO: user supplied filter
    //func applyFilter(func<Node -> Bool>) { ... }
    
    //the root node with our filter applied
    var filteredRoot: Node {
        get {
            return self.filtered(rootNode)
        }
    }
    
    //all nodes unfiltered
    var unfilteredRoot: Node {
        get {
            return self.rootNode
        }
    }
}

//MARK: - filtering
extension Project {
    private func nodeConformsToFilter(_ node: Node) -> Bool {
        //nodes with children always are to be included
        if node.children.count > 0 {
            return true
        }
        
        return self.nodeFilter(node)
//        
//        //apply self.filter
//        if node.ports.filter({$0.state == Port.State.open && [21, 22, 23, 25, 80, ].contains($0.port)}).count > 0 {
//            return true
//        }
//        
//        if node.hasOpenPorts() {
//            return true
//        }
//        
//        //default: DENIED
//        return false
    }
    
    fileprivate func filtered(_ root: Node) -> Node {
        var node = root
        node.children = node.children.filter({nodeConformsToFilter($0)})
        
        for i in 0 ..< node.children.count {
            node.children[i] = self.filtered(node.children[i])
        }
        
        return node
    }
}

