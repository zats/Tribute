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
    
    public enum TextEffect {
        case Letterpress
    }
    
    public enum StrokeStyle {
        case StrokeOnly(percent: Float)
        case StrokeAndFill(percent: Float)
    }
    
    public enum GlyphDirection {
        case Vertical
        case Horizontal
    }
    
    public enum Stroke {
        case NotFilled(width: Float)
        case Filled(width: Float)
    }

    public var alignment: NSTextAlignment?
    public var backgroundColor: UIColor?
    public var color: UIColor?
    public var direction: GlyphDirection?
    public var expansion: Float?
    public var font: UIFont?
    public var kern: Float?
    public var leading: Float?
    public var ligature: Bool?
    public var obliqueness: Float?
    public var strikethrough: NSUnderlineStyle?
    public var strikethroughColor: UIColor?
    public var stroke: Stroke?
    public var strokeColor: UIColor?
    public var textEffect: TextEffect?
    public var underline: NSUnderlineStyle?
    public var underlineColor: UIColor?
    public var URL: NSURL?

}

private extension Attributes.TextEffect {
    init?(stringValue: String) {
        if stringValue == NSTextEffectLetterpressStyle {
            self = .Letterpress
        } else {
            return nil
        }
    }
    
    var stringValue: String {
        switch self {
        case .Letterpress:
            return NSTextEffectLetterpressStyle
        }
    }
}

private extension Attributes.Stroke {
    init(floatValue: Float) {
        if floatValue < 0 {
            self = .Filled(width: -floatValue)
        } else {
            self = .NotFilled(width: floatValue)
        }
    }
    
    var floatValue: Float {
        switch self {
        case let .NotFilled(width):
            return width
        case let .Filled(width):
            return -width
        }
    }
}

private extension Attributes.GlyphDirection {
    init?(intValue: Int) {
        switch intValue {
        case 0:
            self = .Horizontal
        case 1:
            self = .Vertical
        default:
            return nil
        }
    }
    
    var intValue: Int {
        switch self {
        case .Horizontal:
            return 0
        case .Vertical:
            return 1
        }
    }
}

extension Attributes {
    init(rawAttributes attributes: RawAttributes) {
        self.backgroundColor = attributes[NSBackgroundColorAttributeName] as? UIColor
        self.color = attributes[NSForegroundColorAttributeName] as? UIColor
        if let direction = attributes[NSVerticalGlyphFormAttributeName] as? Int {
            self.direction = GlyphDirection(intValue: direction)
        }
        self.expansion = attributes[NSExpansionAttributeName] as? Float
        self.font = attributes[NSFontAttributeName] as? UIFont
        if let ligature = attributes[NSLigatureAttributeName] as? Int {
            self.ligature = (ligature == 1)
        }
        self.kern = attributes[NSKernAttributeName] as? Float
        self.obliqueness = attributes[NSObliquenessAttributeName] as? Float
        if let paragraph = attributes[NSParagraphStyleAttributeName] as? NSParagraphStyle {
            let defaultParagraph = NSParagraphStyle.defaultParagraphStyle()
            self.alignment = (paragraph.alignment == defaultParagraph.alignment) ? nil : paragraph.alignment
            self.leading = (paragraph.lineSpacing == defaultParagraph.lineSpacing) ? nil : Float(paragraph.lineSpacing)
        }
        if let strikethrough = attributes[NSStrikethroughStyleAttributeName] as? Int {
            self.strikethrough = NSUnderlineStyle(rawValue: strikethrough)
        }
        self.strikethroughColor = attributes[NSStrikethroughColorAttributeName] as? UIColor
        if let strokeWidth = attributes[NSStrokeWidthAttributeName] as? Float {
            self.stroke = Stroke(floatValue: strokeWidth)
        }
        self.strokeColor = attributes[NSStrokeColorAttributeName] as? UIColor
        if let textEffect = attributes[NSTextEffectAttributeName] as? String {
            self.textEffect = TextEffect(stringValue: textEffect)
        }
        if let underline = attributes[NSUnderlineStyleAttributeName] as? Int {
            self.underline = NSUnderlineStyle(rawValue: underline)
        }
        self.underlineColor = attributes[NSUnderlineColorAttributeName] as? UIColor
        self.URL = attributes[NSLinkAttributeName] as? NSURL
    }
}


extension Attributes {
    mutating public func reset() {
        backgroundColor = nil
        color = nil
        direction = nil
        expansion = nil
        font = nil
        ligature = nil
        kern = nil
        obliqueness = nil
        alignment = nil
        leading = nil
        strikethrough = nil
        strikethroughColor = nil
        stroke = nil
        strokeColor = nil
        textEffect = nil
        underline = nil
        underlineColor = nil
        URL = nil
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
        result[NSBackgroundColorAttributeName] = backgroundColor
        result[NSForegroundColorAttributeName] = color
        result[NSVerticalGlyphFormAttributeName] = direction?.intValue
        result[NSExpansionAttributeName] = expansion
        result[NSFontAttributeName] = font
        result[NSKernAttributeName] = kern
        if let ligature = ligature {
            result[NSLigatureAttributeName] = ligature ? 1 : 0
        }
        if anyNotNil(leading, alignment) {
            let paragraph = NSMutableParagraphStyle()
            if let leading = leading { paragraph.lineSpacing = CGFloat(leading) }
            if let alignment = alignment { paragraph.alignment = alignment }
            result[NSParagraphStyleAttributeName] = paragraph
        }
        result[NSStrikethroughStyleAttributeName] = strikethrough?.rawValue
        result[NSStrikethroughColorAttributeName] = strikethroughColor
        result[NSStrokeWidthAttributeName] = stroke?.floatValue
        result[NSStrokeColorAttributeName] = strokeColor
        result[NSObliquenessAttributeName] = obliqueness
        result[NSTextEffectAttributeName] = textEffect?.stringValue
        result[NSUnderlineStyleAttributeName] = underline?.rawValue
        result[NSUnderlineColorAttributeName] = underlineColor
        result[NSLinkAttributeName] = URL
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
}


public extension NSMutableAttributedString {
    public typealias AttributeSetter = (inout attributes: Attributes) -> Void
    
    public func add(text: String, setter: AttributeSetter? = nil) -> NSMutableAttributedString {
        var attributes: Attributes
        if let runningAttributes = self.runningAttributes {
            attributes = Attributes(rawAttributes: runningAttributes)
        } else {
            attributes = Attributes()
        }
        setter?(attributes: &attributes)
        let attributedString = NSAttributedString(string: text, attributes: attributes.rawAttributes)
        appendAttributedString(attributedString)
        return self
    }
}

public extension NSMutableAttributedString {
    public func addImage(image: UIImage, resetRunningAttributes: Bool = false, setter: AttributeSetter? = nil) -> NSMutableAttributedString {
        return self
    }
}