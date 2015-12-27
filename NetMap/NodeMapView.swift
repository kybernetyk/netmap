//
//  NodeMapView.swift
//  NetMap
//
//  Created by kyb on 24/12/15.
//  Copyright © 2015 Suborbital Softworks Ltd. All rights reserved.
//

import Cocoa

//primitive to be rendered
//on each draw pass we will build a list of these
//and send them down the render "pipeline"
//this prevents iterating the tree multiple times
struct Drawable {
    let node: Node
    let center: NSPoint
    let parentCenter: NSPoint?
}

//this is bad. nodes will overlap. we need something real here soon
//but it should be enough for now
class NodeMapView: NSView {
    var rootNode: Node! {
        didSet {
            self.needsDisplay = true
        }
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.wantsLayer = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        //we can use this to later set sublayer coordinates
        let vec = generateDrawables(self.rootNode)
        self.renderDrawables(vec)
    }
    
    func renderDrawables(vec: [Drawable]) {
        for d in vec {
            self.drawNodeConnection(d)
        }
        for d in vec {
            self.drawNode(d)
        }
    }
    
    func drawNodeConnection(drawable: Drawable) {
        if let pc = drawable.parentCenter {
            let p = NSBezierPath()
            p.moveToPoint(pc)
            p.lineToPoint(drawable.center)
            NSColor.blackColor().set()
            p.stroke()
        }
    }
    
    func drawNode(drawable: Drawable) {
        let centerPoint = drawable.center
        let r = NSMakeRect(centerPoint.x - 35/2, centerPoint.y - 35/2, 35, 35)
        let p = NSBezierPath(roundedRect: r, xRadius: 4, yRadius: 4)
        
        if drawable.node.parentID == nil {
            NSColor.redColor().set()
        } else {
            NSColor.yellowColor().set()
        }
        p.fill()
        
        NSColor.greenColor().set()
        p.stroke()
        
        let s = NSString(string: "\(drawable.node.address)\n\(drawable.node.hostname)")
        s.drawAtPoint(centerPoint, withAttributes: nil)
    }
    
    func generateDrawables(root: Node) -> [Drawable] {
        var vec: [Drawable] = []
        
        if let drawable = makeDrawableFromNode(root) {
            vec.append(drawable)
            for c in root.children {
                let v2 = generateDrawables(c)
                for c2 in v2 {
                    vec.append(c2)
                }
            }
        }
        return vec
    }
    
    func makeDrawableFromNode(node: Node) -> Drawable? {
        if let pid = node.parentID {
            guard let parent = self.findNodeByID(self.rootNode, nodeID: pid) else {
                return nil //a node with a parentID must have a parent node!
            }
            //this call is expensive. unroll this if profiler complains
            guard let parentCenter = makeDrawableFromNode(parent)?.center else {
                return nil //thus it needs to have a parent drawable
            }
            let radius = min(Double(self.bounds.size.width), Double(self.bounds.size.height)) / 3.0
            
            //find out which child# we are
            //and calc our position on the circle around our parent node
            let childCount = parent.children.count
            if let childNum = parent.children.indexOf({$0.id == node.id}) {
                let step = 360.0 / Double(childCount)
                let deg = Double(step * Double(childNum));

                return Drawable(node: node,
                    center: NSMakePoint(parentCenter.x + CGFloat(sin(deg2rad(deg)) * radius), parentCenter.y + CGFloat(cos(deg2rad(deg)) * radius)),
                    parentCenter: parentCenter)
            }
            return nil //we failed
        } else {
            //root node is always in the center
            return Drawable(node: node, center: NSPoint(x: self.bounds.size.width/2.0, y: self.bounds.size.height/2.0),
                parentCenter: nil)
        }
    }
}

//MARK: - help0r
extension NodeMapView {
    func findNodeByID(root: Node, nodeID: Int) -> Node? {
        if root.id == nodeID {
            return root
        }
        return root.childByID(nodeID)
    }
    
    //i'm a sucker for DEG heh
    func deg2rad(deg : Double) -> Double {
        return deg * 0.017453292519943295769236907684886
    }
}