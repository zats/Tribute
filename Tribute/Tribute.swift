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
    public var baseline: Float?
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
    
    public var lineBreakMode: NSLineBreakMode?
    public var lineHeightMultiplier: Float?
    public var paragraphSpacingAfter: Float?
    public var paragraphSpacingBefore: Float?
    public var headIndent: Float?
    public var tailIndent: Float?
    public var firstLineHeadIndent: Float?
    public var minimumLineHeight: Float?
    public var maximumLineHeight: Float?
    public var hyphenationFactor: Float?
    public var allowsTighteningForTruncation: Bool?
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
        self.baseline = attributes[NSBaselineOffsetAttributeName] as? Float
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
            self.alignment = paraStyleCompare(paragraph) { $0.alignment }
            self.leading = paraStyleCompare(paragraph) { Float($0.lineSpacing) }
            self.lineHeightMultiplier = paraStyleCompare(paragraph) { Float($0.lineHeightMultiple) }
            self.paragraphSpacingAfter = paraStyleCompare(paragraph) { Float($0.paragraphSpacing) }
            self.paragraphSpacingBefore = paraStyleCompare(paragraph) { Float($0.paragraphSpacingBefore) }
            self.headIndent = paraStyleCompare(paragraph) { Float($0.headIndent) }
            self.tailIndent = paraStyleCompare(paragraph) { Float($0.tailIndent) }
            self.firstLineHeadIndent = paraStyleCompare(paragraph) { Float($0.firstLineHeadIndent) }
            self.minimumLineHeight = paraStyleCompare(paragraph) { Float($0.minimumLineHeight) }
            self.maximumLineHeight = paraStyleCompare(paragraph) { Float($0.maximumLineHeight) }
            self.hyphenationFactor = paraStyleCompare(paragraph) { Float($0.hyphenationFactor) }
            if #available(iOS 9.0, *) {
                self.allowsTighteningForTruncation = paraStyleCompare(paragraph) { $0.allowsDefaultTighteningForTruncation }
            }
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
    
    /// convenience method for comparing attributes on `paragraph` vs `defaultParagrah`
    private func paraStyleCompare<U: Equatable>(paragraph: NSParagraphStyle, trans: NSParagraphStyle -> U) -> U? {
        let x = trans(paragraph)
        let y = trans(NSParagraphStyle.defaultParagraphStyle())
        return (x == y) ? nil : x
    }
}

// MARK: Convenience methods
extension Attributes {
    public var fontSize: Float? {
        set {
            if let newValue = newValue {
                self.font = currentFont.fontWithSize(CGFloat(newValue))
            } else {
                self.font = nil
            }
        }
        get {
            return Float(currentFont.pointSize)
        }
    }
    
    public var bold: Bool {
        set {
            setTrait(.TraitBold, enabled: newValue)
        }
        get {
            return currentFont.fontDescriptor().symbolicTraits.contains(.TraitBold)
        }
    }
    
    public var italic: Bool {
        set {
            setTrait(.TraitItalic, enabled: newValue)
        }
        get {
            return currentFont.fontDescriptor().symbolicTraits.contains(.TraitItalic)
        }
    }
    
    private mutating func setTrait(trait: UIFontDescriptorSymbolicTraits, enabled: Bool) {
        let font = currentFont
        let descriptor = font.fontDescriptor()
        var traits = descriptor.symbolicTraits
        if enabled {
            traits.insert(trait)
        } else {
            traits.remove(trait)
        }
        let newDescriptor = descriptor.fontDescriptorWithSymbolicTraits(traits)
        self.font = UIFont(descriptor: newDescriptor, size: font.pointSize)
    }
    
    private static let defaultFont = UIFont.systemFontOfSize(12)
    private var currentFont: UIFont {
        if let font = self.font {
            return font
        } else {
            return Attributes.defaultFont
        }
    }
}

extension Attributes {
    mutating public func reset() {
        backgroundColor = nil
        baseline = nil
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
        
        lineBreakMode = nil
        lineHeightMultiplier = nil
        paragraphSpacingAfter = nil
        paragraphSpacingBefore = nil
        headIndent = nil
        tailIndent = nil
        firstLineHeadIndent = nil
        minimumLineHeight = nil
        maximumLineHeight = nil
        hyphenationFactor = nil
        allowsTighteningForTruncation = nil
    }
}


extension Attributes {
    var rawAttributes: RawAttributes {
        var result: RawAttributes = [:]
        result[NSBackgroundColorAttributeName] = backgroundColor
        result[NSBaselineOffsetAttributeName] = baseline
        result[NSForegroundColorAttributeName] = color
        result[NSVerticalGlyphFormAttributeName] = direction?.intValue
        result[NSExpansionAttributeName] = expansion
        result[NSFontAttributeName] = font
        result[NSKernAttributeName] = kern
        if let ligature = ligature {
            result[NSLigatureAttributeName] = ligature ? 1 : 0
        }
        if let paragraph = retrieveParagraph() {
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

    private func isAnyNotNil(objects: Any? ...) -> Bool {
        for object in objects {
            if object != nil {
                return true
            }
        }
        return false
    }
    
    
    private func retrieveParagraph() -> NSMutableParagraphStyle? {
        if !isAnyNotNil(leading, alignment, lineBreakMode, lineHeightMultiplier,
            paragraphSpacingAfter, paragraphSpacingBefore, headIndent, tailIndent,
            firstLineHeadIndent, minimumLineHeight, maximumLineHeight, hyphenationFactor,
            allowsTighteningForTruncation) {
                return nil
        }
        let paragraph = NSMutableParagraphStyle()
        
        if let leading = leading { paragraph.lineSpacing = CGFloat(leading) }
        if let leading = leading { paragraph.lineSpacing = CGFloat(leading) }
        if let alignment = alignment { paragraph.alignment = alignment }
        if let lineBreakMode = lineBreakMode { paragraph.lineBreakMode = lineBreakMode }
        if let lineHeightMultiplier = lineHeightMultiplier { paragraph.lineHeightMultiple = CGFloat(lineHeightMultiplier) }
        if let paragraphSpacingAfter = paragraphSpacingAfter { paragraph.paragraphSpacing = CGFloat(paragraphSpacingAfter) }
        if let paragraphSpacingBefore = paragraphSpacingBefore { paragraph.paragraphSpacingBefore = CGFloat(paragraphSpacingBefore) }
        if let headIndent = headIndent { paragraph.headIndent = CGFloat(headIndent) }
        if let tailIndent = tailIndent { paragraph.tailIndent = CGFloat(tailIndent) }
        if let firstLineHeadIndent = firstLineHeadIndent { paragraph.firstLineHeadIndent = CGFloat(firstLineHeadIndent) }
        if let minimumLineHeight = minimumLineHeight { paragraph.minimumLineHeight = CGFloat(minimumLineHeight) }
        if let maximumLineHeight = maximumLineHeight { paragraph.maximumLineHeight = CGFloat(maximumLineHeight) }
        if let hyphenationFactor = hyphenationFactor { paragraph.hyphenationFactor = hyphenationFactor }
        if #available(iOS 9.0, *) {
            if let allowsTighteningForTruncation = allowsTighteningForTruncation { paragraph.allowsDefaultTighteningForTruncation = allowsTighteningForTruncation }
        }
        return paragraph
    }
}


extension NSAttributedString {
    var runningAttributes: [String: AnyObject]? {
        guard length > 0 else {
            return nil
        }
        return attributesAtIndex(length - 1, effectiveRange: nil)
    }
    
    private var fullRange: NSRange {
        return NSRange(location: 0, length: length)
    }
}


public extension NSMutableAttributedString {
    public typealias AttributeSetter = (inout attributes: Attributes) -> Void
    
    public func add(text: String, setter: AttributeSetter? = nil) -> NSMutableAttributedString {
        var attributes = runningOrNewAttributes
        setter?(attributes: &attributes)
        return add(text, attributes: attributes)
    }
    
    var runningOrNewAttributes: Attributes {
        if let runningAttributes = self.runningAttributes {
            return Attributes(rawAttributes: runningAttributes)
        } else {
            return Attributes()
        }
    }
    
    func add(text: String, attributes: Attributes) -> NSMutableAttributedString {
        let attributedString = NSAttributedString(string: text, attributes: attributes.rawAttributes)
        appendAttributedString(attributedString)
        return self
    }
}

public extension NSMutableAttributedString {
    public func add(image: UIImage, bounds: CGRect? = nil, setter: AttributeSetter? = nil) -> NSMutableAttributedString {
        var attributes = runningOrNewAttributes
        setter?(attributes: &attributes)
        let attachment = NSTextAttachment()
        attachment.image = image
        if let bounds = bounds {
            attachment.bounds = bounds
        }
        let string = NSMutableAttributedString(attributedString: NSAttributedString(attachment: attachment))
        string.addAttributes(attributes.rawAttributes, range: string.fullRange)
        appendAttributedString(string)
        return self
    }
}