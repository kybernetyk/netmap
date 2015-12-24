//
//  NodeMapView.swift
//  NetMap
//
//  Created by kyb on 24/12/15.
//  Copyright © 2015 Suborbital Softworks Ltd. All rights reserved.
//

import Cocoa

struct MapViewDrawable {
    var sourceNode: Node
    
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
        
        self.drawNodes(self.drawables)
    }
    
    func drawNodes(nodes: [MapViewDrawable]) {
        let _ = nodes.map(self.drawNode)
    }
    
    func drawNode(node: MapViewDrawable) {
        NSLog("drawing \(node)")
    }
}

//MARK: - helper
extension NodeMapView {
    func flattenTree(root: Node) -> [MapViewDrawable] {
        if root.isLeaf() {
            return [MapViewDrawable(sourceNode: root, x: 0.0, y: 0.0)]
        }
        return flattenTree(root)
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