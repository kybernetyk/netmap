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
    
    enum State {
        case unknown
        case open
        case closed
        case filtered

        init(string: String) {
            self = .unknown
            if string.lowercased() == "open" {
                self = .open
            }
            if string.lowercased() == "closed" {
                self = .closed
            }
            if string.lowercased() == "filtered" {
                self = .filtered
            }
        }
    }
    
    enum Proto {
        case unknown
        case tcp
        case udp
        
        init(string: String) {
            self = .unknown
            if string.lowercased() == "tcp" {
                self = .tcp
            }
            if string.lowercased() == "udp" {
                self = .udp
            }
        }
    }
    
    var state: State = .unknown
    var proto: Proto = .unknown
}


struct Node {
    init(id: Int, kind: Kind) {
        self.id = id
        self.parentID = nil
        self.kind = kind
    }
    
    enum Kind {
        case host
        case network
    }
    
    var id: Int
    var parentID: Int?
    var kind: Kind
    var address: String = ""
    var hostname: String? = nil
    
    var ports: [Port] = []
    
    var children: [Node] = []
}

//MARK: - tree manipulation
extension Node {
    mutating func appendChild(_ child: Node) {
        var child = child
        child.parentID = self.id
        self.children.append(child)
    }
    
    func childByID(_ childID: Int) -> Node? {
        //the low hanging fruit first mkay?
        for c in self.children {
            if c.id == childID {
                return c
            }
        }
        
        //now the expensive stuff
        for c in self.children {
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
        return self.ports.filter({$0.state == .open})
    }
    
    func isLeaf() -> Bool {
        return self.children.count == 0
    }
    
    func hasOpenPorts() -> Bool {
        return self.openPorts().count > 0
    }
}
