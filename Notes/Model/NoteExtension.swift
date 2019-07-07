//
//  NoteExtension.swift
//  Notes
//
//  Created by bagrusss on 30/06/2019.
//  Copyright © 2019 bagrusss. All rights reserved.
//

import Foundation
import UIKit

extension Note {
    
    var json: [String: Any] {
        get {
            var jsonDict = [String: Any]()
            jsonDict["uid"] = self.uid
            jsonDict["title"] = self.title
            jsonDict["content"] = self.content
            if color != .white {
                jsonDict["color"] = self.color.toHex()
            }
            if let selfDestructionDate = self.selfDestructionDate {
                jsonDict["selfDestructionDate"] = Int(selfDestructionDate.timeIntervalSince1970)
            }
            if (importance != .ordinary) {
                jsonDict["importance"] = importance.rawValue
            }
            
            return jsonDict
        }
    }
    
    static func parse(json: [String: Any]) -> Note? {
        guard
            let title = json["title"] as? String,
            let content = json["content"] as? String,
            let uid = json["uid"] as? String
            else {
                return nil
        }
        
        let importance = json["importance"] as? Int
        let importanceEnum = Note.Importance(rawValue: importance ?? 0) ?? Note.Importance.ordinary
        
        var uiColor: UIColor
        if let color = json["color"] as? Int {
            uiColor = color.toUIColor()
        } else {
            uiColor = UIColor.white
        }
        
        let selfDestructionDate: Date?
        if let date = json["selfDestructionDate"] as? Double {
            selfDestructionDate = Date(timeIntervalSince1970: date)
        } else {
            selfDestructionDate = nil
        }
        
        return Note(
            uid: uid,
            title: title,
            content: content,
            color: uiColor,
            importance: importanceEnum,
            selfDestructionDate: selfDestructionDate
        )
    }
}

extension UIColor {
    
    func toHex() -> Int {
        var fRed : CGFloat = 0
        var fGreen : CGFloat = 0
        var fBlue : CGFloat = 0
        var fAlpha: CGFloat = 0
        
        self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha)
        let red = Int(fRed * 255.0)
        let green = Int(fGreen * 255.0)
        let blue = Int(fBlue * 255.0)
        let alpha = Int(fAlpha * 255.0)
        
        let rgb = (alpha << 24) + (red << 16) + (green << 8) + blue
        return rgb
    }
    
}

extension Int {
    
    func toUIColor() -> UIColor {
        let red   = CGFloat((self & 0xFF0000) >> 16)
        let green = CGFloat((self & 0x00FF00) >> 8)
        let blue  = CGFloat(self & 0x0000FF)
        let alpha = CGFloat((self & 0xFF000000) >> 24) / 0xFF
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
}
