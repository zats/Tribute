//
//  Tribute.swift
//  Tribute
//
//  Created by Sash Zats on 11/26/15.
//  Copyright © 2015 Sash Zats. All rights reserved.
// https://github.com/zats/Tribute

import Foundation
import UIKit

public struct Attributes {
    typealias RawAttributes = [NSAttributedString.Key: Any]
    
    public enum TextEffect {
        case Letterpress
    }
    
    public enum GlyphDirection {
        case Vertical
        case Horizontal
    }
    
    public enum Stroke {
        case NotFilled(width: CGFloat)
        case Filled(width: CGFloat)
    }
    
    public var alignment: NSTextAlignment?
    public var backgroundColor: UIColor?
    public var baseline: CGFloat?
    public var color: UIColor?
    public var direction: GlyphDirection?
    public var expansion: CGFloat?
    public var font: UIFont?
    public var kern: CGFloat?
    public var leading: CGFloat?
    public var ligature: Bool?
    public var obliqueness: CGFloat?
    public var strikethrough: NSUnderlineStyle?
    public var strikethroughColor: UIColor?
    public var stroke: Stroke?
    public var strokeColor: UIColor?
    public var textEffect: TextEffect?
    public var underline: NSUnderlineStyle?
    public var underlineColor: UIColor?
    public var URL: URL?
    
    public var lineBreakMode: NSLineBreakMode?
    public var lineHeightMultiplier: CGFloat?
    public var paragraphSpacingAfter: CGFloat?
    public var paragraphSpacingBefore: CGFloat?
    public var headIndent: CGFloat?
    public var tailIndent: CGFloat?
    public var firstLineHeadIndent: CGFloat?
    public var minimumLineHeight: CGFloat?
    public var maximumLineHeight: CGFloat?
    public var hyphenationFactor: Float?
    public var allowsTighteningForTruncation: Bool?
}

private extension Attributes.TextEffect {
    init?(stringValue: String) {
        if stringValue == NSAttributedString.TextEffectStyle.letterpressStyle.rawValue {
            self = .Letterpress
        } else {
            return nil
        }
    }
    
    var stringValue: String {
        switch self {
        case .Letterpress:
            return NSAttributedString.TextEffectStyle.letterpressStyle.rawValue
        }
    }
}

private extension Attributes.Stroke {
    init(floatValue: CGFloat) {
        if floatValue < 0 {
            self = .Filled(width: -floatValue)
        } else {
            self = .NotFilled(width: floatValue)
        }
    }
    
    var floatValue: CGFloat {
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
        self.backgroundColor = attributes[NSAttributedString.Key.backgroundColor] as? UIColor
        self.baseline = attributes[NSAttributedString.Key.baselineOffset] as? CGFloat
        self.color = attributes[NSAttributedString.Key.foregroundColor] as? UIColor
        if let direction = attributes[NSAttributedString.Key.verticalGlyphForm] as? Int {
            self.direction = GlyphDirection(intValue: direction)
        }
        self.expansion = attributes[NSAttributedString.Key.expansion] as? CGFloat
        self.font = attributes[NSAttributedString.Key.font] as? UIFont
        if let ligature = attributes[NSAttributedString.Key.ligature] as? Int {
            self.ligature = (ligature == 1)
        }
        self.kern = attributes[NSAttributedString.Key.kern] as? CGFloat
        self.obliqueness = attributes[NSAttributedString.Key.obliqueness] as? CGFloat
        
        if let paragraph = attributes[NSAttributedString.Key.paragraphStyle] as? NSParagraphStyle {
            self.alignment = paraStyleCompare(paragraph: paragraph) { $0.alignment }
            self.leading = paraStyleCompare(paragraph: paragraph) { CGFloat($0.lineSpacing) }
            self.lineHeightMultiplier = paraStyleCompare(paragraph: paragraph) { CGFloat($0.lineHeightMultiple) }
            self.paragraphSpacingAfter = paraStyleCompare(paragraph: paragraph) { CGFloat($0.paragraphSpacing) }
            self.paragraphSpacingBefore = paraStyleCompare(paragraph: paragraph) { CGFloat($0.paragraphSpacingBefore) }
            self.headIndent = paraStyleCompare(paragraph: paragraph) { CGFloat($0.headIndent) }
            self.tailIndent = paraStyleCompare(paragraph: paragraph) { CGFloat($0.tailIndent) }
            self.firstLineHeadIndent = paraStyleCompare(paragraph: paragraph) { CGFloat($0.firstLineHeadIndent) }
            self.minimumLineHeight = paraStyleCompare(paragraph: paragraph) { CGFloat($0.minimumLineHeight) }
            self.maximumLineHeight = paraStyleCompare(paragraph: paragraph) { CGFloat($0.maximumLineHeight) }
            self.hyphenationFactor = paraStyleCompare(paragraph: paragraph) { $0.hyphenationFactor }
            if #available(iOS 9.0, *) {
                self.allowsTighteningForTruncation = paraStyleCompare(paragraph: paragraph) { $0.allowsDefaultTighteningForTruncation }
            }
        }
        
        if let strikethrough = attributes[NSAttributedString.Key.strikethroughStyle] as? Int {
            self.strikethrough = NSUnderlineStyle(rawValue: strikethrough)
        }
        self.strikethroughColor = attributes[NSAttributedString.Key.strikethroughColor] as? UIColor
        if let strokeWidth = attributes[NSAttributedString.Key.strokeWidth] as? CGFloat {
            self.stroke = Stroke(floatValue: strokeWidth)
        }
        self.strokeColor = attributes[NSAttributedString.Key.strokeColor] as? UIColor
        if let textEffect = attributes[NSAttributedString.Key.textEffect] as? String {
            self.textEffect = TextEffect(stringValue: textEffect)
        }
        if let underline = attributes[NSAttributedString.Key.underlineStyle] as? Int {
            self.underline = NSUnderlineStyle(rawValue: underline)
        }
        self.underlineColor = attributes[NSAttributedString.Key.underlineColor] as? UIColor
        self.URL = attributes[NSAttributedString.Key.link] as? URL
    }
    
    /// convenience method for comparing attributes on `paragraph` vs `defaultParagrah`
    private func paraStyleCompare<U: Equatable>(paragraph: NSParagraphStyle, trans: (NSParagraphStyle) -> U) -> U? {
        let x = trans(paragraph)
        let y = trans(NSParagraphStyle.default)
        return (x == y) ? nil : x
    }
}

// MARK: Convenience methods
extension Attributes {
    public var fontSize: CGFloat? {
        set {
            if let newValue = newValue {
                self.font = currentFont.withSize(CGFloat(newValue))
            } else {
                self.font = nil
            }
        }
        get {
            return CGFloat(currentFont.pointSize)
        }
    }
    
    public var bold: Bool {
        set {
            setTrait(trait: .traitBold, enabled: newValue)
        }
        get {
            return currentFont.fontDescriptor.symbolicTraits.contains(.traitBold)
        }
    }
    
    public var italic: Bool {
        set {
            setTrait(trait: .traitItalic, enabled: newValue)
        }
        get {
            return currentFont.fontDescriptor.symbolicTraits.contains(.traitItalic)
        }
    }
    
    private mutating func setTrait(trait: UIFontDescriptor.SymbolicTraits, enabled: Bool) {
        let font = currentFont
        let descriptor = font.fontDescriptor
        var traits = descriptor.symbolicTraits
        if enabled {
            traits.insert(trait)
        } else {
            traits.remove(trait)
        }
        guard let newDescriptor = descriptor.withSymbolicTraits(traits) else { return }
        self.font = UIFont(descriptor: newDescriptor, size: font.pointSize)
    }
    
    private static let defaultFont = UIFont.systemFont(ofSize: 12)
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
        result[NSAttributedString.Key.backgroundColor] = backgroundColor
        result[NSAttributedString.Key.baselineOffset] = baseline
        result[NSAttributedString.Key.foregroundColor] = color
        result[NSAttributedString.Key.verticalGlyphForm] = direction?.intValue
        result[NSAttributedString.Key.expansion] = expansion
        result[NSAttributedString.Key.font] = font
        result[NSAttributedString.Key.kern] = kern
        if let ligature = ligature {
            result[NSAttributedString.Key.ligature] = (ligature ? 1 : 0)
        }
        if let paragraph = retrieveParagraph() {
            result[NSAttributedString.Key.paragraphStyle] = paragraph
        }
        
        result[NSAttributedString.Key.strikethroughStyle] = strikethrough
        result[NSAttributedString.Key.strikethroughColor] = strikethroughColor
        result[NSAttributedString.Key.strokeWidth] = stroke?.floatValue
        result[NSAttributedString.Key.strokeColor] = strokeColor
        result[NSAttributedString.Key.obliqueness] = obliqueness
        result[NSAttributedString.Key.textEffect] = textEffect?.stringValue
        result[NSAttributedString.Key.underlineStyle] = underline
        result[NSAttributedString.Key.underlineColor] = underlineColor
        result[NSAttributedString.Key.link] = URL
        
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
        if !isAnyNotNil(objects: leading, alignment, lineBreakMode, lineHeightMultiplier,
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
    var runningAttributes: [NSAttributedString.Key: Any]? {
        guard length > 0 else {
            return nil
        }
        return attributes(at: length - 1, effectiveRange: nil)
    }
    
    var fullRange: NSRange {
        return NSRange(location: 0, length: length)
    }
}


public extension NSMutableAttributedString {
    typealias AttributeSetter = ( _ attributes: inout Attributes) -> Void
    
    func add(text: String, setter: AttributeSetter? = nil) -> NSMutableAttributedString {
        var attributes = runningOrNewAttributes
        setter?(&attributes)
        return add(text: text, attributes: attributes)
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
        append(attributedString)
        return self
    }
}

public extension NSMutableAttributedString {
    func add(image: UIImage, bounds: CGRect? = nil, setter: AttributeSetter? = nil) -> NSMutableAttributedString {
        var attributes = runningOrNewAttributes
        setter?(&attributes)
        let attachment = NSTextAttachment()
        attachment.image = image
        if let bounds = bounds {
            attachment.bounds = bounds
        }
        let string = NSMutableAttributedString(attributedString: NSAttributedString(attachment: attachment))
        string.addAttributes(attributes.rawAttributes, range: string.fullRange)
        append(string)
        return self
    }
}
