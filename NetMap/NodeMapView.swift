//
//  NodeMapView.swift
//  NetMap
//
//  Created by kyb on 24/12/15.
//  Copyright © 2015 Suborbital Softworks Ltd. All rights reserved.
//

import Cocoa

//struct to store metadata about the nodes
struct MapViewDrawable {
    var nodeID: Int
    var x: Double
    var y: Double
}

class NodeMapView: NSView {
    var drawables: [MapViewDrawable] = []
    
    var rootNode: Node! {
        didSet {
            self.drawables = self.generateDrawables(self.rootNode)
            self.needsDisplay = true
        }
    }

}

//MARK: - rendering
extension NodeMapView {
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        
        NSColor.redColor().set()
        NSRectFill(self.bounds)
        
        self.drawTree(self.rootNode, parent: nil)
        
    }
    
    func drawTree(root: Node, parent: Node?) {
        if let d = self.findDrawableByNodeID(root.id) {
            NSLog("drawing \(d): \(root.hostname), parent: \(parent?.hostname)")
        }
        
        for c in root.children {
            drawTree(c, parent:  root)
        }
        
    }
}

//MARK: - drawable metadata
extension NodeMapView {
    func findDrawableByNodeID(nodeID: Int) -> MapViewDrawable? {
        return self.drawables.filter({ return $0.nodeID == nodeID }).first
    }
    
    func findNodeByID(root: Node, nodeID: Int) -> Node? {
        if root.id == nodeID {
            return root
        }
        return root.childByID(nodeID)
    }

    func flattenTree(root: Node) -> [MapViewDrawable] {
        var vec: [MapViewDrawable] = []
        vec.append(MapViewDrawable(nodeID: root.id, x: 0.0, y: 0.0))
        for c in root.children {
            let v2 = flattenTree(c)
            for c2 in v2 {
                vec.append(c2)
            }
        }
        
        return vec
    }
    
    func generateDrawables(root: Node) -> [MapViewDrawable] {
        let vec = self.flattenTree(root)
        
        var ret: [MapViewDrawable] = []
        
        //now let's order this shit
        for (index, var n) in vec.enumerate() {
            if index == 0 {
                n.x = Double(self.bounds.size.width) / 2.0
                n.y = Double(self.bounds.size.height) / 2.0
            } else {
                n.x = Double(index) * 12.5
                n.y = Double(index) * 12.5
            }
            ret.append(n)
        }
        
        return ret
    }
}