//
//  Tribute.swift
//  Tribute
//
//  Created by Sash Zats on 11/26/15.
//  Copyright © 2015 Sash Zats. All rights reserved.
//

import Foundation


public struct Attributes {
    typealias RawAttributes = [String: AnyObject]
    
    public var font: UIFont?
    public var color: UIColor?
    public var backgroundColor: UIColor?
    
    public var ligature: Bool?
    public var kern: Float?
    
    public var strikethrough: NSUnderlineStyle?
    public var underline: NSUnderlineStyle?
    
    public var strokeColor: UIColor?
    public var strokeWidth: Float?
    
    // NSParagraphStyle
    public var alignment: NSTextAlignment?
    public var leading: Float?
}


extension Attributes {
    init(rawAttributes attributes: RawAttributes) {
        self.font = attributes[NSFontAttributeName] as? UIFont
        self.color = attributes[NSForegroundColorAttributeName] as? UIColor
        self.backgroundColor = attributes[NSBackgroundColorAttributeName] as? UIColor
        if let ligatures = attributes[NSLigatureAttributeName] as? Int {
            self.ligature = (ligatures == 1)
        }
        self.kern = attributes[NSKernAttributeName] as? Float
        self.strikethrough = attributes[NSStrikethroughStyleAttributeName] as? NSUnderlineStyle
        self.underline = attributes[NSUnderlineStyleAttributeName] as? NSUnderlineStyle
        self.strokeColor = attributes[NSStrokeColorAttributeName] as? UIColor
        if let strokeWidth = attributes[NSStrokeWidthAttributeName] as? Float {
            self.strokeWidth = abs(strokeWidth)
        }
        if let paragraph = attributes[NSParagraphStyleAttributeName] as? NSParagraphStyle {
            let defaultParagraph = NSParagraphStyle.defaultParagraphStyle()
            self.alignment = (paragraph.alignment == defaultParagraph.alignment) ? nil : paragraph.alignment
            self.leading = (paragraph.lineSpacing == defaultParagraph.lineSpacing) ? nil : Float(paragraph.lineSpacing)
        }
    }
}


extension Attributes {
    private func anyNotNil(objects: Any? ...) -> Bool {
        for object in objects {
            if object != nil {
                return true
            }
        }
        return false
    }
    
    var rawAttributes: RawAttributes {
        var result: RawAttributes = [:]
        result[NSFontAttributeName] = font
        result[NSForegroundColorAttributeName] = color
        result[NSBackgroundColorAttributeName] = backgroundColor
        if let ligature = ligature {
            result[NSLigatureAttributeName] = ligature ? 1 : 0
        }
        result[NSKernAttributeName] = kern
        result[NSStrikethroughStyleAttributeName] = strikethrough?.rawValue
        result[NSUnderlineStyleAttributeName] = underline?.rawValue
        result[NSStrokeColorAttributeName] = strokeColor
        result[NSStrokeWidthAttributeName] = strokeWidth
        if let strokeWidth = strokeWidth {
            result[NSStrokeWidthAttributeName] = -strokeWidth
        }
        if anyNotNil(leading, alignment) {
            let paragraph = NSMutableParagraphStyle()
            if let leading = leading { paragraph.lineSpacing = CGFloat(leading) }
            if let alignment = alignment { paragraph.alignment = alignment }
            result[NSParagraphStyleAttributeName] = paragraph
        }
        return result
    }
}


extension NSAttributedString {
    var runningAttributes: [String: AnyObject]? {
        guard length > 0 else {
            return nil
        }
        return attributesAtIndex(length - 1, effectiveRange: nil)
    }
    
    var fullRange: NSRange {
        return NSRange(location: 0, length: length)
    }
}


public extension NSMutableAttributedString {
    public typealias AttributeSetter = (inout attributes: Attributes) -> Void
    
    public func add(text: String, resetRunningAttributes: Bool = false, setter: AttributeSetter? = nil) -> NSMutableAttributedString {
        var newAttrtibutes: Attributes
        if resetRunningAttributes {
            newAttrtibutes = Attributes()
        } else {
            let existentAttributes: Attributes
            if let runningAttributes = self.runningAttributes {
                existentAttributes = Attributes(rawAttributes: runningAttributes)
            } else {
                existentAttributes = Attributes()
            }
            newAttrtibutes = existentAttributes
        }
        setter?(attributes: &newAttrtibutes)
        let attributedString = NSAttributedString(string: text, attributes: newAttrtibutes.rawAttributes)
        appendAttributedString(attributedString)
        return self
    }
}

