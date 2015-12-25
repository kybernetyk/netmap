//
//  NodeMapView.swift
//  NetMap
//
//  Created by kyb on 24/12/15.
//  Copyright © 2015 Suborbital Softworks Ltd. All rights reserved.
//

import Cocoa

//struct to store metadata about the nodes
//struct MapViewDrawable {
//    var nodeID: Int
//    
//    var deg: Double
//}

class NodeMapView: NSView {
//    var drawables: [MapViewDrawable] = []
    
    var rootNode: Node! {
        didSet {
//            self.drawables = self.generateDrawables(self.rootNode)
            self.needsDisplay = true
        }
    }
    
}

//MARK: - rendering
extension NodeMapView {
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        
        NSColor.whiteColor().set()
        NSRectFill(self.bounds)
        
        NSColor.darkGrayColor().set()
        NSFrameRect(self.bounds)
    
        self.drawConnectionTree(self.rootNode)
        self.drawTree(self.rootNode)
        
    }
    
    func deg2rad(deg : Double) -> Double {
        return deg * 0.017453292519943295769236907684886
    }
    
    //lol this looks fucking slow but unless we're going to visualize HUGE networks this won't be a problem
    //if we needed to optimize this we can do away with the recursion and the findNodeByID() call...
    func centerPointForNode(node: Node) -> NSPoint? {
        if let pid = node.parentID {
            guard let parent = self.findNodeByID(self.rootNode, nodeID: pid) else {
                    return nil
            }
            guard let center = centerPointForNode(parent) else {
                return nil
            }
            let radius = 100.0;// min(Double(self.bounds.size.width), Double(self.bounds.size.height)) / 3.0
            
            //find out which child# we are
            let childCount = parent.children.count
            if let childNum = parent.children.indexOf({$0.id == node.id}) {
                let step = 360.0 / Double(childCount)
                let deg = Double(step * Double(childNum)) + 35.0
                
                return NSMakePoint(center.x + CGFloat(sin(deg2rad(deg)) * radius), center.y + CGFloat(cos(deg2rad(deg)) * radius))
            }
            return nil
        } else {
            //root node is always in the center
            return NSPoint(x: self.bounds.size.width/2.0, y: self.bounds.size.height/2.0)
        }
    }
    
    func drawConnectionTree(root: Node) {
        self.drawNodeConnections(root)
        
        for c in root.children {
            drawConnectionTree(c)
        }

    }
    
    func drawNodeConnections(node: Node) {
        guard let centerPoint = self.centerPointForNode(node) else {
            return
        }
        if let parentID = node.parentID {
            if let parent = self.findNodeByID(self.rootNode, nodeID: parentID) {
                if let parentCenter = self.centerPointForNode(parent) {
                    let p = NSBezierPath()
                    p.moveToPoint(centerPoint)
                    p.lineToPoint(parentCenter)
                    NSColor.blackColor().set()
                    p.stroke()
                }
            }
            
        }
    }
    
    func drawNode(node: Node) {
        guard let centerPoint = self.centerPointForNode(node) else {
            return
        }
        let r = NSMakeRect(centerPoint.x - 35/2, centerPoint.y - 35/2, 35, 35)
        let p = NSBezierPath(roundedRect: r, xRadius: 4, yRadius: 4)
        
        if node.parentID == nil {
            NSColor.redColor().set()
        } else {
            NSColor.yellowColor().set()
        }
        p.fill()
        
        NSColor.greenColor().set()
        p.stroke()
    }
    
    func drawTree(root: Node) {
        self.drawNode(root)
        
        for c in root.children {
            drawTree(c)
        }
        
    }
}

//MARK: - drawable metadata
extension NodeMapView {
//    func findDrawableByNodeID(nodeID: Int) -> MapViewDrawable? {
//        return self.drawables.filter({ return $0.nodeID == nodeID }).first
//    }
//    
    func findNodeByID(root: Node, nodeID: Int) -> Node? {
        if root.id == nodeID {
            return root
        }
        return root.childByID(nodeID)
    }
    
//    func flattenTree(root: Node) -> [MapViewDrawable] {
//        var vec: [MapViewDrawable] = []
//        vec.append(MapViewDrawable(nodeID: root.id, deg: 0.0))
//        for c in root.children {
//            let v2 = flattenTree(c)
//            for c2 in v2 {
//                vec.append(c2)
//            }
//        }
//        
//        return vec
//    }
//    
//    func generateDrawables(root: Node) -> [MapViewDrawable] {
//        let vec = self.flattenTree(root)
//        
//        let total: Double = Double(vec.count)
//        let step = 360.0 / total
//        
//        let ret: [MapViewDrawable] = vec.enumerate().map {(index, var elm) in
//            if (index == 0) {
//                //                elm.x = Double(self.bounds.size.width) / 2.0
//                //                elm.y = Double(self.bounds.size.height) / 2.0
//            } else {
//                //                elm.x = Double(index) * 12.5
//                //                elm.y = Double(index) * 12.5
//                elm.deg = Double(index - 1) * step
//            }
//            return elm
//        }
//        
//        return ret
//    }
}