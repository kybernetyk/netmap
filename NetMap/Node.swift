//
//  Node.swift
//  NetMap
//
//  Created by kyb on 24/12/15.
//  Copyright © 2015 Suborbital Softworks Ltd. All rights reserved.
//

import Foundation

struct Port {
    var port: Int = 0
}


struct Node {
    init(id: Int, type: Type) {
        self.id = id
        self.parentID = nil
        self.type = type
    }
    
    enum Type {
        case Host
        case Network
    }
    
    var id: Int
    var parentID: Int?
    var type: Type
    var address: String = ""
    var hostname: String = ""
    
    var ports: [Port] = []
    
    var children: [Node] = []
}

//MARK: - tree manipulation
extension Node {
    mutating func appendChild(child: Node) {
        var child = child
        child.parentID = self.id
        self.children.append(child)
    }
    
    func childByID(childID: Int) -> Node? {
        for c in self.children {
            if c.id == childID {
                return c
            }
            if let n = c.childByID(childID) {
                return n
            }
        }
        return nil
    }
}

//MARK: - public
extension Node {
    func openPorts() -> [Port] {
        return []
    }
    
    func isLeaf() -> Bool {
        return self.children.count == 0
    }
    
    func hasOpenPorts() -> Bool {
        return self.openPorts().count > 0
    }
}
