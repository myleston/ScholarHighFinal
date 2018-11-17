//
//  SwipeCellDefs.swift
//  ScholarHighPrototype1
//
//  Created by Myleston Law on 2018/11/17.
//  Copyright © 2018 FRESHNESS. All rights reserved.
//

import Foundation
import UIKit



enum ActionDescriptor {
    case liked, unliked, more
    
    func title(forDisplayMode displayMode: ButtonDisplayMode) -> String? {
        guard displayMode != .imageOnly else { return nil }
        
        switch self {
        case .liked: return "liked"
        case .unliked: return "unliked"
        case .more: return "More"
        }
    }
    
    func image(forStyle style: ButtonStyle, displayMode: ButtonDisplayMode) -> UIImage? {
        guard displayMode != .titleOnly else { return nil }
        
        let name: String
        switch self {
        case .liked: name = "liked"
        case .unliked: name = "unliked"
        case .more: name = "More"
        }
        
        return UIImage(named: style == .backgroundColor ? name : name + "-circle")
    }
    
    var color: UIColor {
        switch self {
        case .liked: return #colorLiteral(red: 0, green: 0.4577052593, blue: 1, alpha: 1)
        case .more: return #colorLiteral(red: 0.7803494334, green: 0.7761332393, blue: 0.7967314124, alpha: 1)
        case .unliked: return #colorLiteral(red: 1, green: 0.5803921569, blue: 0, alpha: 1)
            
        }
    }
}
enum ButtonDisplayMode {
    case titleAndImage, titleOnly, imageOnly
}

enum ButtonStyle {
    case backgroundColor, circular
}

class IndicatorView: UIView {
    var color = UIColor.clear {
        didSet { setNeedsDisplay() }
    }
    
    override func draw(_ rect: CGRect) {
        color.set()
        UIBezierPath(ovalIn: rect).fill()
    }
}
