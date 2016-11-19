//
//  Project.swift
//  NetMap
//
//  Created by kyb on 24/12/15.
//  Copyright © 2015 Suborbital Softworks Ltd. All rights reserved.
//

import Foundation

struct DefaultFilters {
    static func webServices(node: Node) -> Bool {
        return node.ports.filter{ port in
            port.state == .open && [80, 443, 8080, 8000].contains(port.rawValue)
            }.count > 0
    }
    
    static func interestingPorts(node: Node) -> Bool {
        return node.ports.filter{ port in
            port.state == .open && [21, 22, 23, 25, 80].contains(port.rawValue)
            }.count > 0
    }
    
    static func hasOpenPorts(node: Node) -> Bool {
        return node.openPorts().count > 0
    }
}


class Project {
    let representedFile: String
    fileprivate let rootNode: Node
    
    typealias FilterFunc = (Node) -> Bool
    fileprivate var nodeFilter: FilterFunc
  
    init(representedFile: String, rootNode: Node) {
        self.representedFile = representedFile
        self.rootNode = rootNode
        
        self.nodeFilter = DefaultFilters.hasOpenPorts
    }
}


//MARK: - public
extension Project {
    func applyFilter(f: @escaping FilterFunc) {
        self.nodeFilter = f
    }

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

