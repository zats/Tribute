//
//  TributeTests.swift
//  TributeTests
//
//  Created by Sash Zats on 11/26/15.
//  Copyright © 2015 Sash Zats. All rights reserved.
//

import Quick
import Nimble
@testable import Tribute


class TributeSpec: QuickSpec {
    override func spec() {
        var string: NSMutableAttributedString!
        
        beforeEach{
            string = NSMutableAttributedString()
        }
        
        context("internals") {
            // we are testing implementation details only to use internal methods as a part of the test flow
            describe("runningAttributes") {
                it("should report nil if string is empty") {
                    expect(string.runningAttributes).to(beNil())
                }
                
                it("should report last attributes if string is not empty") {
                    let attributes: [String: NSObject] = [
                        NSFontAttributeName: UIFont.boldSystemFontOfSize(12),
                        NSForegroundColorAttributeName: UIColor.redColor()
                    ]
                    string.appendAttributedString(NSAttributedString(string: "persimmon", attributes: attributes))
                    expect(string.runningAttributes).to(haveCount(attributes.count))
                    for (key, value) in attributes {
                        expect(string.runningAttributes?[key] as? NSObject).to(equal(value))
                    }
                }
            }
        }

        context("sanity") {
            describe("empty string") {
                it("produces no attributes") {
                    string.add("картошка")
                    expect(string.attributesAtIndex(0, effectiveRange: nil)).to(haveCount(0))
                }
                
                it("keeps existent attributes") {
                    string.appendAttributedString(NSAttributedString(string: "תפוח", attributes: [
                        NSForegroundColorAttributeName: UIColor.redColor()
                    ]))
                    string.add(" אדמה")
                    guard let attributes = string.runningAttributes else {
                        fail("No attributes found")
                        return
                    }
                    expect(attributes).to(haveCount(1))
                    expect(attributes[NSForegroundColorAttributeName] as? UIColor).to(equal(UIColor.redColor()))
                }
                
                it("resets attributes") {
                    string.appendAttributedString(NSAttributedString(string: "apple", attributes: [
                        NSForegroundColorAttributeName: UIColor.redColor()
                    ]))
                    string.add("pineapple") { (inout a: Attributes) in
                        a.reset()
                    }
                    expect(string.runningAttributes!).to(haveCount(0))
                }
            }
            
            describe("simple manipulations") {
                it("should keep running attributes") {
                    string.add("Hello ") { (inout a: Attributes) in
                        a.color = .redColor()
                    }
                    string.add("world") { _ in
                    }
                    let attributes = string.runningAttributes
                    expect(attributes).to(haveCount(1))
                    expect(attributes![NSForegroundColorAttributeName] as? UIColor).to(equal(UIColor.redColor()))
                }
            }
        }
        
        context("properties") {
            describe("alignment") {
                it("sets new value") {
                    string.add("potato") { (inout a: Attributes) in
                        a.alignment = .Center
                    }
                    expect(string.runningAttributes).to(haveCount(1))
                    let paragraph = string.runningAttributes![NSParagraphStyleAttributeName] as? NSParagraphStyle
                    expect(paragraph?.alignment).to(equal(NSTextAlignment.Center))
                }
                
                it("sets new value equal to default") {
                    string.add("potato") { (inout a: Attributes) in
                        a.alignment = NSParagraphStyle.defaultParagraphStyle().alignment
                    }
                    expect(string.runningAttributes).to(haveCount(1))
                    let paragraph = string.runningAttributes![NSParagraphStyleAttributeName] as? NSParagraphStyle
                    expect(paragraph?.alignment).to(equal(NSParagraphStyle.defaultParagraphStyle().alignment))
                }
                
                it("overrides existent value with a new one") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.alignment = .Center
                    }
                    string.add("potato") { (inout a: Attributes) in
                        expect(string.runningAttributes).to(haveCount(1))
                        let paragraph = string.runningAttributes![NSParagraphStyleAttributeName] as? NSParagraphStyle
                        expect(paragraph?.alignment).to(equal(NSTextAlignment.Center))
                        
                        a.alignment = .Justified
                    }
                    expect(string.runningAttributes).to(haveCount(1))
                    
                    let paragraph = string.runningAttributes![NSParagraphStyleAttributeName] as? NSParagraphStyle
                    expect(paragraph?.alignment).to(equal(NSTextAlignment.Justified))
                }
                
                it("overrides existent value equal to the default with a new one") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.alignment = NSParagraphStyle.defaultParagraphStyle().alignment
                    }
                    string.add("potato") { (inout a: Attributes) in
                        a.alignment = .Justified
                    }
                    expect(string.runningAttributes).to(haveCount(1))
                    
                    let paragraph = string.runningAttributes![NSParagraphStyleAttributeName] as? NSParagraphStyle
                    expect(paragraph?.alignment).to(equal(NSTextAlignment.Justified))
                }
                
                it("overrides existent value with a new one equal to the default") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.alignment = .Center
                    }
                    string.add("potato") { (inout a: Attributes) in
                        a.alignment = NSParagraphStyle.defaultParagraphStyle().alignment
                    }
                    expect(string.runningAttributes).to(haveCount(1))
                    
                    let paragraph = string.runningAttributes![NSParagraphStyleAttributeName] as? NSParagraphStyle
                    expect(paragraph?.alignment).to(equal(NSParagraphStyle.defaultParagraphStyle().alignment))
                }
                
                
                it("removes existent value when set to nil") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.alignment = .Center
                    }
                    string.add("potato") { (inout a: Attributes) in
                        a.alignment = nil
                    }
                    expect(string.runningAttributes).to(haveCount(0))
                }
            }

            describe("backgroundColor") {
                it("sets new value") {
                    string.add("potato") { (inout a: Attributes) in
                        a.backgroundColor = .redColor()
                    }
                    expect(string.runningAttributes).to(haveCount(1))
                    expect(string.runningAttributes![NSBackgroundColorAttributeName] as? UIColor).to(equal(UIColor.redColor()))
                }
                
                it("overrides existent value with a new one") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.backgroundColor = .redColor()
                    }
                    string.add("potato") { (inout a: Attributes) in
                        expect(string.runningAttributes).to(haveCount(1))
                        expect(string.runningAttributes![NSBackgroundColorAttributeName] as? UIColor).to(equal(UIColor.redColor()))
                        a.backgroundColor = .blueColor()
                    }
                    expect(string.runningAttributes).to(haveCount(1))
                    expect(string.runningAttributes?[NSBackgroundColorAttributeName] as? UIColor).to(equal(UIColor.blueColor()))
                }
                
                it("removes existent value when set to nil") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.backgroundColor = .redColor()
                    }
                    string.add("potato") { (inout a: Attributes) in
                        a.backgroundColor = nil
                    }
                    expect(string.runningAttributes).to(haveCount(0))
                }
            }

            describe("baseline") {
                it("sets new value") {
                    string.add("potato") { (inout a: Attributes) in
                        a.baseline = 13
                    }
                    expect(string.runningAttributes).to(haveCount(1))
                    expect(string.runningAttributes![NSBaselineOffsetAttributeName] as? Float).to(equal(13))
                }
                
                it("overrides existent value with a new one") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.baseline = 13
                    }
                    string.add("potato") { (inout a: Attributes) in
                        expect(string.runningAttributes).to(haveCount(1))
                        expect(string.runningAttributes![NSBaselineOffsetAttributeName] as? Float).to(equal(13))
                        a.baseline = -7
                    }
                    expect(string.runningAttributes).to(haveCount(1))
                    expect(string.runningAttributes?[NSBaselineOffsetAttributeName] as? Float).to(equal(-7))
                }
                
                it("removes existent value when set to nil") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.baseline = 7
                    }
                    string.add("potato") { (inout a: Attributes) in
                        a.baseline = nil
                    }
                    expect(string.runningAttributes).to(haveCount(0))
                }
            }

            describe("color") {
                it("sets new value") {
                    string.add("potato") { (inout a: Attributes) in
                        a.color = .redColor()
                    }
                    expect(string.runningAttributes).to(haveCount(1))
                    expect(string.runningAttributes![NSForegroundColorAttributeName] as? UIColor).to(equal(UIColor.redColor()))
                }
                
                it("overrides existent value with a new one") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.color = .redColor()
                    }
                    string.add("potato") { (inout a: Attributes) in
                        expect(string.runningAttributes).to(haveCount(1))
                        expect(string.runningAttributes![NSForegroundColorAttributeName] as? UIColor).to(equal(UIColor.redColor()))
                        a.color = .blueColor()
                    }
                    expect(string.runningAttributes).to(haveCount(1))
                    expect(string.runningAttributes?[NSForegroundColorAttributeName] as? UIColor).to(equal(UIColor.blueColor()))
                }
                
                it("removes existent value when set to nil") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.color = .redColor()
                    }
                    string.add("potato") { (inout a: Attributes) in
                        a.color = nil
                    }
                    expect(string.runningAttributes).to(haveCount(0))
                }
            }

            describe("direction") {
                it("sets new value") {
                    string.add("potato") { (inout a: Attributes) in
                        a.direction = .Vertical
                    }
                    expect(string.runningAttributes!).to(haveCount(1))
                    expect(string.runningAttributes![NSVerticalGlyphFormAttributeName] as? Int).to(equal(1))
                }

                it("ignores incorrect values") {
                    string.appendAttributedString(NSAttributedString(string: "invalid direciton", attributes: [
                        NSVerticalGlyphFormAttributeName: 13
                    ]))
                    string.add("potato") { (inout a: Attributes) in
                        expect(a.direction).to(beNil())
                    }
                }

                it("overrides existent value with a new one") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.direction = .Vertical
                    }
                    string.add("potato") { (inout a: Attributes) in
                        expect(string.runningAttributes!).to(haveCount(1))
                        expect(string.runningAttributes![NSVerticalGlyphFormAttributeName] as? Int).to(equal(1))
                        
                        a.direction = .Horizontal
                    }
                    expect(string.runningAttributes!).to(haveCount(1))
                    expect(string.runningAttributes![NSVerticalGlyphFormAttributeName] as? Int).to(equal(0))
                }
                
                it("removes existent value when set to nil") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.direction = .Horizontal
                    }
                    string.add("potato") { (inout a: Attributes) in
                        a.direction = nil
                    }
                    expect(string.runningAttributes).to(haveCount(0))
                }
                
                it("unknown glyph direction won't affect direction") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.direction = .Horizontal
                    }
                    string.add("potato") { (inout a: Attributes) in
                        a.direction = nil
                    }
                    expect(string.runningAttributes).to(haveCount(0))
                }
            }

            describe("expansion") {
                it("sets new value") {
                    string.add("potato") { (inout a: Attributes) in
                        a.expansion = 3
                    }
                    expect(string.runningAttributes!).to(haveCount(1))
                    expect(string.runningAttributes![NSExpansionAttributeName] as? Float).to(equal(3))
                }
                
                it("overrides existent value with a new one") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.expansion = 3
                    }
                    string.add("potato") { (inout a: Attributes) in
                        expect(string.runningAttributes!).to(haveCount(1))
                        expect(string.runningAttributes![NSExpansionAttributeName] as? Float).to(equal(3))
                        
                        a.expansion = 5
                    }
                    expect(string.runningAttributes!).to(haveCount(1))
                    expect(string.runningAttributes![NSExpansionAttributeName] as? Float).to(equal(5))
                }
                
                it("removes existent value when set to nil") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.expansion = 10
                    }
                    string.add("potato") { (inout a: Attributes) in
                        a.expansion = nil
                    }
                    expect(string.runningAttributes).to(haveCount(0))
                }
            }

            describe("font") {
                it("sets new value") {
                    string.add("potato") { (inout a: Attributes) in
                        a.font = .boldSystemFontOfSize(20)
                    }
                    expect(string.runningAttributes!).to(haveCount(1))
                    expect(string.runningAttributes![NSFontAttributeName] as? UIFont).to(equal(UIFont.boldSystemFontOfSize(20)))
                }
                
                it("overrides existent value with a new one") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.font = .boldSystemFontOfSize(20)
                    }
                    string.add("potato") { (inout a: Attributes) in
                        expect(string.runningAttributes!).to(haveCount(1))
                        expect(string.runningAttributes![NSFontAttributeName] as? UIFont).to(equal(UIFont.boldSystemFontOfSize(20)))
                        a.font = .italicSystemFontOfSize(20)
                    }
                    expect(string.runningAttributes!).to(haveCount(1))
                    expect(string.runningAttributes![NSFontAttributeName] as? UIFont).to(equal(UIFont.italicSystemFontOfSize(20)))
                }
                
                it("removes existent value when set to nil") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.font = .boldSystemFontOfSize(20)
                    }
                    string.add("potato") { (inout a: Attributes) in
                        a.font = nil
                    }
                    expect(string.runningAttributes).to(haveCount(0))
                }
            }

            describe("leading") {
                it("sets new value") {
                    string.add("potato") { (inout a: Attributes) in
                        a.leading = 20
                    }
                    expect(string.runningAttributes).to(haveCount(1))
                    let paragraph = string.runningAttributes![NSParagraphStyleAttributeName] as? NSParagraphStyle
                    expect(paragraph?.lineSpacing).to(equal(20))
                }
                
                it("sets new value equal to default") {
                    string.add("potato") { (inout a: Attributes) in
                        a.leading = Float(NSParagraphStyle.defaultParagraphStyle().lineSpacing)
                    }
                    expect(string.runningAttributes).to(haveCount(1))
                    let paragraph = string.runningAttributes![NSParagraphStyleAttributeName] as? NSParagraphStyle
                    expect(paragraph?.lineSpacing).to(equal(NSParagraphStyle.defaultParagraphStyle().lineSpacing))
                }
                
                it("overrides existent value with a new one") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.leading = 20
                    }
                    string.add("potato") { (inout a: Attributes) in
                        expect(string.runningAttributes).to(haveCount(1))
                        let paragraph = string.runningAttributes![NSParagraphStyleAttributeName] as? NSParagraphStyle
                        expect(paragraph?.lineSpacing).to(equal(20))
                        
                        a.leading = 30
                    }
                    expect(string.runningAttributes).to(haveCount(1))
                    
                    let paragraph = string.runningAttributes![NSParagraphStyleAttributeName] as? NSParagraphStyle
                    expect(paragraph?.lineSpacing).to(equal(30))
                }
                
                it("overrides existent value equal to the default with a new one") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.leading = Float(NSParagraphStyle.defaultParagraphStyle().lineSpacing)
                    }
                    string.add("potato") { (inout a: Attributes) in
                        a.leading = 30
                    }
                    expect(string.runningAttributes).to(haveCount(1))
                    
                    let paragraph = string.runningAttributes![NSParagraphStyleAttributeName] as? NSParagraphStyle
                    expect(paragraph?.lineSpacing).to(equal(30))
                }
                
                it("overrides existent value with a new one equal to the default") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.leading = 30
                    }
                    string.add("potato") { (inout a: Attributes) in
                        a.leading = Float(NSParagraphStyle.defaultParagraphStyle().lineSpacing)
                    }
                    expect(string.runningAttributes).to(haveCount(1))
                    
                    let paragraph = string.runningAttributes![NSParagraphStyleAttributeName] as? NSParagraphStyle
                    expect(paragraph?.lineSpacing).to(equal(NSParagraphStyle.defaultParagraphStyle().lineSpacing))
                }
                
                
                it("removes existent value when set to nil") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.leading = 30
                    }
                    string.add("potato") { (inout a: Attributes) in
                        a.leading = nil
                    }
                    expect(string.runningAttributes).to(haveCount(0))
                }
            }

            describe("ligature") {
                it("sets new value") {
                    string.add("potato") { (inout a: Attributes) in
                        a.ligature = true
                    }
                    expect(string.runningAttributes!).to(haveCount(1))
                    expect(string.runningAttributes![NSLigatureAttributeName] as? Int).to(equal(1))
                }
                
                it("overrides existent value with a new one") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.ligature = true
                    }
                    string.add("potato") { (inout a: Attributes) in
                        expect(string.runningAttributes!).to(haveCount(1))
                        expect(string.runningAttributes![NSLigatureAttributeName] as? Int).to(equal(1))
                        a.ligature = false
                    }
                    expect(string.runningAttributes!).to(haveCount(1))
                    expect(string.runningAttributes![NSLigatureAttributeName] as? Int).to(equal(0))
                }
                
                it("removes existent value when set to nil") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.ligature = true
                    }
                    string.add("potato") { (inout a: Attributes) in
                        a.ligature = nil
                    }
                    expect(string.runningAttributes).to(haveCount(0))
                }
            }
            
            describe("kern") {
                it("sets new value") {
                    string.add("potato") { (inout a: Attributes) in
                        a.kern = 5
                    }
                    expect(string.runningAttributes!).to(haveCount(1))
                    expect(string.runningAttributes![NSKernAttributeName] as? Float).to(equal(5))
                }
                
                it("overrides existent value with a new one") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.kern = 5
                    }
                    string.add("potato") { (inout a: Attributes) in
                        expect(string.runningAttributes!).to(haveCount(1))
                        expect(string.runningAttributes![NSKernAttributeName] as? Float).to(equal(5))
                        a.kern = 3
                    }
                    expect(string.runningAttributes!).to(haveCount(1))
                    expect(string.runningAttributes![NSKernAttributeName] as? Float).to(equal(3))
                }
                
                it("removes existent value when set to nil") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.kern = 5
                    }
                    string.add("potato") { (inout a: Attributes) in
                        a.kern = nil
                    }
                    expect(string.runningAttributes).to(haveCount(0))
                }
            }
            
            describe("obliqueness") {
                it("sets new value") {
                    string.add("potato") { (inout a: Attributes) in
                        a.obliqueness = 3
                    }
                    expect(string.runningAttributes!).to(haveCount(1))
                    expect(string.runningAttributes![NSObliquenessAttributeName] as? Float).to(equal(3))
                }
                
                it("overrides existent value with a new one") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.obliqueness = 3
                    }
                    string.add("potato") { (inout a: Attributes) in
                        expect(string.runningAttributes!).to(haveCount(1))
                        expect(string.runningAttributes![NSObliquenessAttributeName] as? Float).to(equal(3))
                        
                        a.obliqueness = 5
                    }
                    expect(string.runningAttributes!).to(haveCount(1))
                    expect(string.runningAttributes![NSObliquenessAttributeName] as? Float).to(equal(5))
                }
                
                it("removes existent value when set to nil") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.obliqueness = 10
                    }
                    string.add("potato") { (inout a: Attributes) in
                        a.obliqueness = nil
                    }
                    expect(string.runningAttributes).to(haveCount(0))
                }
            }

            describe("strikethrough") {
                it("sets new value") {
                    string.add("potato") { (inout a: Attributes) in
                        a.strikethrough = .StyleSingle
                    }
                    expect(string.runningAttributes!).to(haveCount(1))
                    expect(NSUnderlineStyle(rawValue: string.runningAttributes![NSStrikethroughStyleAttributeName] as! Int)).to(equal(NSUnderlineStyle.StyleSingle))
                }
                
                it("overrides existent value with a new one") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.strikethrough = .StyleSingle
                    }
                    string.add("potato") { (inout a: Attributes) in
                        expect(string.runningAttributes!).to(haveCount(1))
                        expect(NSUnderlineStyle(rawValue: string.runningAttributes![NSStrikethroughStyleAttributeName] as! Int)).to(equal(NSUnderlineStyle.StyleSingle))
                        a.strikethrough = .StyleThick
                    }
                    expect(string.runningAttributes!).to(haveCount(1))
                    expect(NSUnderlineStyle(rawValue: string.runningAttributes![NSStrikethroughStyleAttributeName] as! Int)).to(equal(NSUnderlineStyle.StyleThick))
                }
                
                it("removes existent value when set to nil") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.strikethrough = .StyleThick
                    }
                    string.add("potato") { (inout a: Attributes) in
                        a.strikethrough = nil
                    }
                    expect(string.runningAttributes).to(haveCount(0))
                }
            }
            
            describe("strikethroughColor") {
                it("sets new value") {
                    string.add("potato") { (inout a: Attributes) in
                        a.strikethroughColor = .redColor()
                    }
                    expect(string.runningAttributes!).to(haveCount(1))
                    expect(string.runningAttributes![NSStrikethroughColorAttributeName] as? UIColor).to(equal(UIColor.redColor()))
                }
                
                it("overrides existent value with a new one") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.strikethroughColor = .redColor()
                    }
                    string.add("potato") { (inout a: Attributes) in
                        expect(string.runningAttributes!).to(haveCount(1))
                        expect(string.runningAttributes![NSStrikethroughColorAttributeName] as? UIColor).to(equal(UIColor.redColor()))
                        a.strikethroughColor = .blueColor()
                    }
                    expect(string.runningAttributes!).to(haveCount(1))
                    expect(string.runningAttributes![NSStrikethroughColorAttributeName] as? UIColor).to(equal(UIColor.blueColor()))
                }
                
                it("removes existent value when set to nil") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.strikethroughColor = .redColor()
                    }
                    string.add("potato") { (inout a: Attributes) in
                        a.strikethroughColor = nil
                    }
                    expect(string.runningAttributes).to(haveCount(0))
                }
            }
            
            describe("stroke") {
                it("sets new value") {
                    string.add("potato") { (inout a: Attributes) in
                        a.stroke = .Filled(width: 10)
                    }
                    expect(string.runningAttributes).to(haveCount(1))
                    expect(string.runningAttributes![NSStrokeWidthAttributeName] as? Float).to(equal(-10))
                }
                
                it("overrides existent value with a new one") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.stroke = .Filled(width: 10)
                    }
                    string.add("potato") { (inout a: Attributes) in
                        expect(string.runningAttributes).to(haveCount(1))
                        expect(string.runningAttributes![NSStrokeWidthAttributeName] as? Float).to(equal(-10))

                        a.stroke = .NotFilled(width: 10)
                    }
                    expect(string.runningAttributes).to(haveCount(1))
                    expect(string.runningAttributes?[NSStrokeWidthAttributeName] as? Float).to(equal(10))
                }
                
                it("removes existent value when set to nil") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.stroke = .NotFilled(width: 10)
                    }
                    string.add("potato") { (inout a: Attributes) in
                        a.stroke = nil
                    }
                    expect(string.runningAttributes).to(haveCount(0))
                }
                
            }
            
            describe("strokeColor") {
                it("sets new value") {
                    string.add("potato") { (inout a: Attributes) in
                        a.strokeColor = .redColor()
                    }
                    expect(string.runningAttributes).to(haveCount(1))
                    expect(string.runningAttributes![NSStrokeColorAttributeName] as? UIColor).to(equal(UIColor.redColor()))
                }
                
                it("overrides existent value with a new one") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.strokeColor = .redColor()
                    }
                    string.add("potato") { (inout a: Attributes) in
                        expect(string.runningAttributes).to(haveCount(1))
                        expect(string.runningAttributes![NSStrokeColorAttributeName] as? UIColor).to(equal(UIColor.redColor()))

                        a.strokeColor = .blueColor()
                    }
                    expect(string.runningAttributes).to(haveCount(1))
                    expect(string.runningAttributes?[NSStrokeColorAttributeName] as? UIColor).to(equal(UIColor.blueColor()))
                }
                
                it("removes existent value when set to nil") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.strokeColor = UIColor.redColor()
                    }
                    string.add("potato") { (inout a: Attributes) in
                        a.strokeColor = nil
                    }
                    expect(string.runningAttributes).to(haveCount(0))
                }
                
            }
            
            describe("textEffect") {
                it("sets new value") {
                    string.add("potato") { (inout a: Attributes) in
                        a.textEffect = .Letterpress
                    }
                    expect(string.runningAttributes).to(haveCount(1))
                    expect(string.runningAttributes![NSTextEffectAttributeName] as? String).to(equal(NSTextEffectLetterpressStyle))
                }

                it("ignores invalid values") {
                    string.appendAttributedString(NSAttributedString(string: "invalid text effect", attributes: [
                        NSTextEffectAttributeName: "shazooo"
                    ]))
                    string.add("potato") { (inout a: Attributes) in
                        expect(a.textEffect).to(beNil())
                    }
                }

                // TODO: change the test when Cocoa supports more effects
                it("overrides existent value with the same one") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.textEffect = .Letterpress
                    }
                    string.add("potato") { (inout a: Attributes) in
                        expect(string.runningAttributes).to(haveCount(1))
                        expect(string.runningAttributes?[NSTextEffectAttributeName] as? String).to(equal(NSTextEffectLetterpressStyle))
                       
                        a.textEffect = .Letterpress
                    }
                    expect(string.runningAttributes).to(haveCount(1))
                    expect(string.runningAttributes?[NSTextEffectAttributeName] as? String).to(equal(NSTextEffectLetterpressStyle))
                }
                
                it("removes existent value when set to nil") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.textEffect = .Letterpress
                    }
                    string.add("potato") { (inout a: Attributes) in
                        a.textEffect = nil
                    }
                    expect(string.runningAttributes).to(haveCount(0))
                }
                
            }
            
            describe("underline") {
                it("sets new value") {
                    string.add("potato") { (inout a: Attributes) in
                        a.underline = .StyleSingle
                    }
                    expect(string.runningAttributes!).to(haveCount(1))
                    expect(NSUnderlineStyle(rawValue: string.runningAttributes![NSUnderlineStyleAttributeName] as! Int)).to(equal(NSUnderlineStyle.StyleSingle))
                }
                
                it("overrides existent value with a new one") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.underline = .StyleSingle
                    }
                    string.add("potato") { (inout a: Attributes) in
                        expect(string.runningAttributes!).to(haveCount(1))
                        expect(NSUnderlineStyle(rawValue: string.runningAttributes![NSUnderlineStyleAttributeName] as! Int)).to(equal(NSUnderlineStyle.StyleSingle))
                        a.underline = .StyleThick
                    }
                    expect(string.runningAttributes!).to(haveCount(1))
                    expect(NSUnderlineStyle(rawValue: string.runningAttributes![NSUnderlineStyleAttributeName] as! Int)).to(equal(NSUnderlineStyle.StyleThick))
                }
                
                it("removes existent value when set to nil") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.underline = .StyleThick
                    }
                    string.add("potato") { (inout a: Attributes) in
                        a.underline = nil
                    }
                    expect(string.runningAttributes).to(haveCount(0))
                }
            }

            describe("underlineColor") {
                it("sets new value") {
                    string.add("potato") { (inout a: Attributes) in
                        a.underlineColor = .redColor()
                    }
                    expect(string.runningAttributes!).to(haveCount(1))
                    expect(string.runningAttributes![NSUnderlineColorAttributeName] as? UIColor).to(equal(UIColor.redColor()))
                }
                
                it("overrides existent value with a new one") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.underlineColor = .redColor()
                    }
                    string.add("potato") { (inout a: Attributes) in
                        expect(string.runningAttributes!).to(haveCount(1))
                        expect(string.runningAttributes![NSUnderlineColorAttributeName] as? UIColor).to(equal(UIColor.redColor()))
                        a.underlineColor = .blueColor()
                    }
                    expect(string.runningAttributes!).to(haveCount(1))
                    expect(string.runningAttributes![NSUnderlineColorAttributeName] as? UIColor).to(equal(UIColor.blueColor()))
                }
                
                it("removes existent value when set to nil") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.underlineColor = .redColor()
                    }
                    string.add("potato") { (inout a: Attributes) in
                        a.underlineColor = nil
                    }
                    expect(string.runningAttributes).to(haveCount(0))
                }
            }

            describe("URL") {
                var url1: NSURL!, url2: NSURL!
                
                beforeEach {
                    url1 = NSURL(string: "https://swift.org")!
                    url2 = NSURL(string: "https://apple.com")!
                }
                
                it("sets new value") {
                    string.add("potato") { (inout a: Attributes) in
                        a.URL = url1
                    }
                    expect(string.runningAttributes!).to(haveCount(1))
                    expect(string.runningAttributes![NSLinkAttributeName] as? NSURL).to(equal(url1))
                }
                
                it("overrides existent value with a new one") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.URL = url1
                    }
                    string.add("potato") { (inout a: Attributes) in
                        expect(string.runningAttributes!).to(haveCount(1))
                        expect(string.runningAttributes![NSLinkAttributeName] as? NSURL).to(equal(url1))

                        a.URL = url2
                    }
                    expect(string.runningAttributes!).to(haveCount(1))
                    expect(string.runningAttributes![NSLinkAttributeName] as? NSURL).to(equal(url2))
                }
                
                it("removes existent value when set to nil") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.URL = url1
                    }
                    string.add("potato") { (inout a: Attributes) in
                        a.URL = nil
                    }
                    expect(string.runningAttributes).to(haveCount(0))
                }
                
            }
            
        }
        
        context("image") {
            var image: UIImage!
            beforeSuite {
                let bundle = NSBundle(forClass: self.dynamicType)
                image = UIImage(named: "swift", inBundle: bundle, compatibleWithTraitCollection: nil)!
            }

            describe("adding image") {
                it("just works") {
                    string.add(image)
                    expect(string.runningAttributes).to(haveCount(1))
                    expect((string.runningAttributes?[NSAttachmentAttributeName] as? NSTextAttachment)?.image).to(equal(image))
                }

                it("keeps existent attributes") {
                    string.add("banana") {
                        $0.color = .redColor()
                        $0.font = .systemFontOfSize(20)
                    }.add(image)
                    expect(string.runningAttributes?[NSFontAttributeName] as? UIFont).to(equal(UIFont.systemFontOfSize(20)))
                    expect(string.runningAttributes?[NSForegroundColorAttributeName] as? UIColor).to(equal(UIColor.redColor()))
                }
                
                it("applies new attributes") {
                    string.add(image) {
                        $0.color = .redColor()
                        $0.font = .boldSystemFontOfSize(12)
                    }
                    expect(string.runningAttributes?[NSFontAttributeName] as? UIFont).to(equal(UIFont.boldSystemFontOfSize(12)))
                    expect(string.runningAttributes?[NSForegroundColorAttributeName] as? UIColor).to(equal(UIColor.redColor()))
                }
            }
            
            describe("setting bounds") {
                it("changes bounds of attachment") {
                    let imageBounds = CGRect(x: 1, y: 2, width: 3, height: 4)
                    string.add(image, bounds: imageBounds)
                    expect(string.runningAttributes).to(haveCount(1))
                    let attachment = string.runningAttributes?[NSAttachmentAttributeName] as? NSTextAttachment
                    expect(attachment?.bounds).to(equal(imageBounds))
                }
            }
        }
    }
}
