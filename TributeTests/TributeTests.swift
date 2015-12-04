//
//  TributeTests.swift
//  TributeTests
//
//  Created by Sash Zats on 11/26/15.
//  Copyright © 2015 Sash Zats. All rights reserved.
//

import Quick
import Nimble
import Tribute


class TributeSpec: QuickSpec {
    override func spec() {
        var string: NSMutableAttributedString!
        
        beforeEach{
            string = NSMutableAttributedString()
        }

        context("sanity") {
            describe("empty string") {
                it("produces no attributes") {
                    string.add("картошка")
                    expect(string.attributesAtIndex(0)).to(haveCount(0))
                }
                
                it("keeps existent attributes") {
                    string.appendAttributedString(NSAttributedString(string: "תפוח", attributes: [
                        NSForegroundColorAttributeName: UIColor.redColor()
                    ]))
                    string.add(" אדמה")
                    guard let attributes = string.lastAttributes else {
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
                    expect(string.lastAttributes!).to(haveCount(0))
                }
            }
            
            describe("simple manipulations") {
                it("should keep running attributes") {
                    string.add("Hello ") { (inout a: Attributes) in
                        a.color = .redColor()
                    }
                    string.add("world") { _ in
                    }
                    let attributes = string.lastAttributes
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
                    expect(string.lastAttributes).to(haveCount(1))
                    let paragraph = string.lastAttributes![NSParagraphStyleAttributeName] as? NSParagraphStyle
                    expect(paragraph?.alignment).to(equal(NSTextAlignment.Center))
                }
                
                it("sets new value equal to default") {
                    string.add("potato") { (inout a: Attributes) in
                        a.alignment = NSParagraphStyle.defaultParagraphStyle().alignment
                    }
                    expect(string.lastAttributes).to(haveCount(1))
                    let paragraph = string.lastAttributes![NSParagraphStyleAttributeName] as? NSParagraphStyle
                    expect(paragraph?.alignment).to(equal(NSParagraphStyle.defaultParagraphStyle().alignment))
                }
                
                it("overrides existent value with a new one") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.alignment = .Center
                    }
                    string.add("potato") { (inout a: Attributes) in
                        expect(string.lastAttributes).to(haveCount(1))
                        let paragraph = string.lastAttributes![NSParagraphStyleAttributeName] as? NSParagraphStyle
                        expect(paragraph?.alignment).to(equal(NSTextAlignment.Center))
                        
                        a.alignment = .Justified
                    }
                    expect(string.lastAttributes).to(haveCount(1))
                    
                    let paragraph = string.lastAttributes![NSParagraphStyleAttributeName] as? NSParagraphStyle
                    expect(paragraph?.alignment).to(equal(NSTextAlignment.Justified))
                }
                
                it("overrides existent value equal to the default with a new one") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.alignment = NSParagraphStyle.defaultParagraphStyle().alignment
                    }
                    string.add("potato") { (inout a: Attributes) in
                        a.alignment = .Justified
                    }
                    expect(string.lastAttributes).to(haveCount(1))
                    
                    let paragraph = string.lastAttributes![NSParagraphStyleAttributeName] as? NSParagraphStyle
                    expect(paragraph?.alignment).to(equal(NSTextAlignment.Justified))
                }
                
                it("overrides existent value with a new one equal to the default") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.alignment = .Center
                    }
                    string.add("potato") { (inout a: Attributes) in
                        a.alignment = NSParagraphStyle.defaultParagraphStyle().alignment
                    }
                    expect(string.lastAttributes).to(haveCount(1))
                    
                    let paragraph = string.lastAttributes![NSParagraphStyleAttributeName] as? NSParagraphStyle
                    expect(paragraph?.alignment).to(equal(NSParagraphStyle.defaultParagraphStyle().alignment))
                }
                
                
                it("removes existent value when set to nil") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.alignment = .Center
                    }
                    string.add("potato") { (inout a: Attributes) in
                        a.alignment = nil
                    }
                    expect(string.lastAttributes).to(haveCount(0))
                }
            }

            describe("backgroundColor") {
                it("sets new value") {
                    string.add("potato") { (inout a: Attributes) in
                        a.backgroundColor = .redColor()
                    }
                    expect(string.lastAttributes).to(haveCount(1))
                    expect(string.lastAttributes![NSBackgroundColorAttributeName] as? UIColor).to(equal(UIColor.redColor()))
                }
                
                it("overrides existent value with a new one") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.backgroundColor = .redColor()
                    }
                    string.add("potato") { (inout a: Attributes) in
                        expect(string.lastAttributes).to(haveCount(1))
                        expect(string.lastAttributes![NSBackgroundColorAttributeName] as? UIColor).to(equal(UIColor.redColor()))
                        a.backgroundColor = .blueColor()
                    }
                    expect(string.lastAttributes).to(haveCount(1))
                    expect(string.lastAttributes?[NSBackgroundColorAttributeName] as? UIColor).to(equal(UIColor.blueColor()))
                }
                
                it("removes existent value when set to nil") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.backgroundColor = .redColor()
                    }
                    string.add("potato") { (inout a: Attributes) in
                        a.backgroundColor = nil
                    }
                    expect(string.lastAttributes).to(haveCount(0))
                }
            }

            describe("color") {
                it("sets new value") {
                    string.add("potato") { (inout a: Attributes) in
                        a.color = .redColor()
                    }
                    expect(string.lastAttributes).to(haveCount(1))
                    expect(string.lastAttributes![NSForegroundColorAttributeName] as? UIColor).to(equal(UIColor.redColor()))
                }
                
                it("overrides existent value with a new one") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.color = .redColor()
                    }
                    string.add("potato") { (inout a: Attributes) in
                        expect(string.lastAttributes).to(haveCount(1))
                        expect(string.lastAttributes![NSForegroundColorAttributeName] as? UIColor).to(equal(UIColor.redColor()))
                        a.color = .blueColor()
                    }
                    expect(string.lastAttributes).to(haveCount(1))
                    expect(string.lastAttributes?[NSForegroundColorAttributeName] as? UIColor).to(equal(UIColor.blueColor()))
                }
                
                it("removes existent value when set to nil") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.color = .redColor()
                    }
                    string.add("potato") { (inout a: Attributes) in
                        a.color = nil
                    }
                    expect(string.lastAttributes).to(haveCount(0))
                }
            }

            describe("direction") {
                it("sets new value") {
                    string.add("potato") { (inout a: Attributes) in
                        a.direction = .Vertical
                    }
                    expect(string.lastAttributes!).to(haveCount(1))
                    expect(string.lastAttributes![NSVerticalGlyphFormAttributeName] as? Int).to(equal(1))
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
                        expect(string.lastAttributes!).to(haveCount(1))
                        expect(string.lastAttributes![NSVerticalGlyphFormAttributeName] as? Int).to(equal(1))
                        
                        a.direction = .Horizontal
                    }
                    expect(string.lastAttributes!).to(haveCount(1))
                    expect(string.lastAttributes![NSVerticalGlyphFormAttributeName] as? Int).to(equal(0))
                }
                
                it("removes existent value when set to nil") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.direction = .Horizontal
                    }
                    string.add("potato") { (inout a: Attributes) in
                        a.direction = nil
                    }
                    expect(string.lastAttributes).to(haveCount(0))
                }
                
                it("unknown glyph direction won't affect direction") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.direction = .Horizontal
                    }
                    string.add("potato") { (inout a: Attributes) in
                        a.direction = nil
                    }
                    expect(string.lastAttributes).to(haveCount(0))
                }
            }

            describe("expansion") {
                it("sets new value") {
                    string.add("potato") { (inout a: Attributes) in
                        a.expansion = 3
                    }
                    expect(string.lastAttributes!).to(haveCount(1))
                    expect(string.lastAttributes![NSExpansionAttributeName] as? Float).to(equal(3))
                }
                
                it("overrides existent value with a new one") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.expansion = 3
                    }
                    string.add("potato") { (inout a: Attributes) in
                        expect(string.lastAttributes!).to(haveCount(1))
                        expect(string.lastAttributes![NSExpansionAttributeName] as? Float).to(equal(3))
                        
                        a.expansion = 5
                    }
                    expect(string.lastAttributes!).to(haveCount(1))
                    expect(string.lastAttributes![NSExpansionAttributeName] as? Float).to(equal(5))
                }
                
                it("removes existent value when set to nil") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.expansion = 10
                    }
                    string.add("potato") { (inout a: Attributes) in
                        a.expansion = nil
                    }
                    expect(string.lastAttributes).to(haveCount(0))
                }
            }

            describe("font") {
                it("sets new value") {
                    string.add("potato") { (inout a: Attributes) in
                        a.font = .boldSystemFontOfSize(20)
                    }
                    expect(string.lastAttributes!).to(haveCount(1))
                    expect(string.lastAttributes![NSFontAttributeName] as? UIFont).to(equal(UIFont.boldSystemFontOfSize(20)))
                }
                
                it("overrides existent value with a new one") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.font = .boldSystemFontOfSize(20)
                    }
                    string.add("potato") { (inout a: Attributes) in
                        expect(string.lastAttributes!).to(haveCount(1))
                        expect(string.lastAttributes![NSFontAttributeName] as? UIFont).to(equal(UIFont.boldSystemFontOfSize(20)))
                        a.font = .italicSystemFontOfSize(20)
                    }
                    expect(string.lastAttributes!).to(haveCount(1))
                    expect(string.lastAttributes![NSFontAttributeName] as? UIFont).to(equal(UIFont.italicSystemFontOfSize(20)))
                }
                
                it("removes existent value when set to nil") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.font = .boldSystemFontOfSize(20)
                    }
                    string.add("potato") { (inout a: Attributes) in
                        a.font = nil
                    }
                    expect(string.lastAttributes).to(haveCount(0))
                }
            }

            describe("leading") {
                it("sets new value") {
                    string.add("potato") { (inout a: Attributes) in
                        a.leading = 20
                    }
                    expect(string.lastAttributes).to(haveCount(1))
                    let paragraph = string.lastAttributes![NSParagraphStyleAttributeName] as? NSParagraphStyle
                    expect(paragraph?.lineSpacing).to(equal(20))
                }
                
                it("sets new value equal to default") {
                    string.add("potato") { (inout a: Attributes) in
                        a.leading = Float(NSParagraphStyle.defaultParagraphStyle().lineSpacing)
                    }
                    expect(string.lastAttributes).to(haveCount(1))
                    let paragraph = string.lastAttributes![NSParagraphStyleAttributeName] as? NSParagraphStyle
                    expect(paragraph?.lineSpacing).to(equal(NSParagraphStyle.defaultParagraphStyle().lineSpacing))
                }
                
                it("overrides existent value with a new one") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.leading = 20
                    }
                    string.add("potato") { (inout a: Attributes) in
                        expect(string.lastAttributes).to(haveCount(1))
                        let paragraph = string.lastAttributes![NSParagraphStyleAttributeName] as? NSParagraphStyle
                        expect(paragraph?.lineSpacing).to(equal(20))
                        
                        a.leading = 30
                    }
                    expect(string.lastAttributes).to(haveCount(1))
                    
                    let paragraph = string.lastAttributes![NSParagraphStyleAttributeName] as? NSParagraphStyle
                    expect(paragraph?.lineSpacing).to(equal(30))
                }
                
                it("overrides existent value equal to the default with a new one") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.leading = Float(NSParagraphStyle.defaultParagraphStyle().lineSpacing)
                    }
                    string.add("potato") { (inout a: Attributes) in
                        a.leading = 30
                    }
                    expect(string.lastAttributes).to(haveCount(1))
                    
                    let paragraph = string.lastAttributes![NSParagraphStyleAttributeName] as? NSParagraphStyle
                    expect(paragraph?.lineSpacing).to(equal(30))
                }
                
                it("overrides existent value with a new one equal to the default") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.leading = 30
                    }
                    string.add("potato") { (inout a: Attributes) in
                        a.leading = Float(NSParagraphStyle.defaultParagraphStyle().lineSpacing)
                    }
                    expect(string.lastAttributes).to(haveCount(1))
                    
                    let paragraph = string.lastAttributes![NSParagraphStyleAttributeName] as? NSParagraphStyle
                    expect(paragraph?.lineSpacing).to(equal(NSParagraphStyle.defaultParagraphStyle().lineSpacing))
                }
                
                
                it("removes existent value when set to nil") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.leading = 30
                    }
                    string.add("potato") { (inout a: Attributes) in
                        a.leading = nil
                    }
                    expect(string.lastAttributes).to(haveCount(0))
                }
            }

            describe("ligature") {
                it("sets new value") {
                    string.add("potato") { (inout a: Attributes) in
                        a.ligature = true
                    }
                    expect(string.lastAttributes!).to(haveCount(1))
                    expect(string.lastAttributes![NSLigatureAttributeName] as? Int).to(equal(1))
                }
                
                it("overrides existent value with a new one") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.ligature = true
                    }
                    string.add("potato") { (inout a: Attributes) in
                        expect(string.lastAttributes!).to(haveCount(1))
                        expect(string.lastAttributes![NSLigatureAttributeName] as? Int).to(equal(1))
                        a.ligature = false
                    }
                    expect(string.lastAttributes!).to(haveCount(1))
                    expect(string.lastAttributes![NSLigatureAttributeName] as? Int).to(equal(0))
                }
                
                it("removes existent value when set to nil") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.ligature = true
                    }
                    string.add("potato") { (inout a: Attributes) in
                        a.ligature = nil
                    }
                    expect(string.lastAttributes).to(haveCount(0))
                }
            }
            
            describe("kern") {
                it("sets new value") {
                    string.add("potato") { (inout a: Attributes) in
                        a.kern = 5
                    }
                    expect(string.lastAttributes!).to(haveCount(1))
                    expect(string.lastAttributes![NSKernAttributeName] as? Float).to(equal(5))
                }
                
                it("overrides existent value with a new one") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.kern = 5
                    }
                    string.add("potato") { (inout a: Attributes) in
                        expect(string.lastAttributes!).to(haveCount(1))
                        expect(string.lastAttributes![NSKernAttributeName] as? Float).to(equal(5))
                        a.kern = 3
                    }
                    expect(string.lastAttributes!).to(haveCount(1))
                    expect(string.lastAttributes![NSKernAttributeName] as? Float).to(equal(3))
                }
                
                it("removes existent value when set to nil") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.kern = 5
                    }
                    string.add("potato") { (inout a: Attributes) in
                        a.kern = nil
                    }
                    expect(string.lastAttributes).to(haveCount(0))
                }
            }
            
            describe("obliqueness") {
                it("sets new value") {
                    string.add("potato") { (inout a: Attributes) in
                        a.obliqueness = 3
                    }
                    expect(string.lastAttributes!).to(haveCount(1))
                    expect(string.lastAttributes![NSObliquenessAttributeName] as? Float).to(equal(3))
                }
                
                it("overrides existent value with a new one") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.obliqueness = 3
                    }
                    string.add("potato") { (inout a: Attributes) in
                        expect(string.lastAttributes!).to(haveCount(1))
                        expect(string.lastAttributes![NSObliquenessAttributeName] as? Float).to(equal(3))
                        
                        a.obliqueness = 5
                    }
                    expect(string.lastAttributes!).to(haveCount(1))
                    expect(string.lastAttributes![NSObliquenessAttributeName] as? Float).to(equal(5))
                }
                
                it("removes existent value when set to nil") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.obliqueness = 10
                    }
                    string.add("potato") { (inout a: Attributes) in
                        a.obliqueness = nil
                    }
                    expect(string.lastAttributes).to(haveCount(0))
                }
            }

            describe("strikethrough") {
                it("sets new value") {
                    string.add("potato") { (inout a: Attributes) in
                        a.strikethrough = .StyleSingle
                    }
                    expect(string.lastAttributes!).to(haveCount(1))
                    expect(NSUnderlineStyle(rawValue: string.lastAttributes![NSStrikethroughStyleAttributeName] as! Int)).to(equal(NSUnderlineStyle.StyleSingle))
                }
                
                it("overrides existent value with a new one") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.strikethrough = .StyleSingle
                    }
                    string.add("potato") { (inout a: Attributes) in
                        expect(string.lastAttributes!).to(haveCount(1))
                        expect(NSUnderlineStyle(rawValue: string.lastAttributes![NSStrikethroughStyleAttributeName] as! Int)).to(equal(NSUnderlineStyle.StyleSingle))
                        a.strikethrough = .StyleThick
                    }
                    expect(string.lastAttributes!).to(haveCount(1))
                    expect(NSUnderlineStyle(rawValue: string.lastAttributes![NSStrikethroughStyleAttributeName] as! Int)).to(equal(NSUnderlineStyle.StyleThick))
                }
                
                it("removes existent value when set to nil") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.strikethrough = .StyleThick
                    }
                    string.add("potato") { (inout a: Attributes) in
                        a.strikethrough = nil
                    }
                    expect(string.lastAttributes).to(haveCount(0))
                }
            }
            
            describe("strikethroughColor") {
                it("sets new value") {
                    string.add("potato") { (inout a: Attributes) in
                        a.strikethroughColor = .redColor()
                    }
                    expect(string.lastAttributes!).to(haveCount(1))
                    expect(string.lastAttributes![NSStrikethroughColorAttributeName] as? UIColor).to(equal(UIColor.redColor()))
                }
                
                it("overrides existent value with a new one") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.strikethroughColor = .redColor()
                    }
                    string.add("potato") { (inout a: Attributes) in
                        expect(string.lastAttributes!).to(haveCount(1))
                        expect(string.lastAttributes![NSStrikethroughColorAttributeName] as? UIColor).to(equal(UIColor.redColor()))
                        a.strikethroughColor = .blueColor()
                    }
                    expect(string.lastAttributes!).to(haveCount(1))
                    expect(string.lastAttributes![NSStrikethroughColorAttributeName] as? UIColor).to(equal(UIColor.blueColor()))
                }
                
                it("removes existent value when set to nil") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.strikethroughColor = .redColor()
                    }
                    string.add("potato") { (inout a: Attributes) in
                        a.strikethroughColor = nil
                    }
                    expect(string.lastAttributes).to(haveCount(0))
                }
            }
            
            describe("stroke") {
                it("sets new value") {
                    string.add("potato") { (inout a: Attributes) in
                        a.stroke = .Filled(width: 10)
                    }
                    expect(string.lastAttributes).to(haveCount(1))
                    expect(string.lastAttributes![NSStrokeWidthAttributeName] as? Float).to(equal(-10))
                }
                
                it("overrides existent value with a new one") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.stroke = .Filled(width: 10)
                    }
                    string.add("potato") { (inout a: Attributes) in
                        expect(string.lastAttributes).to(haveCount(1))
                        expect(string.lastAttributes![NSStrokeWidthAttributeName] as? Float).to(equal(-10))

                        a.stroke = .NotFilled(width: 10)
                    }
                    expect(string.lastAttributes).to(haveCount(1))
                    expect(string.lastAttributes?[NSStrokeWidthAttributeName] as? Float).to(equal(10))
                }
                
                it("removes existent value when set to nil") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.stroke = .NotFilled(width: 10)
                    }
                    string.add("potato") { (inout a: Attributes) in
                        a.stroke = nil
                    }
                    expect(string.lastAttributes).to(haveCount(0))
                }
                
            }
            
            describe("strokeColor") {
                it("sets new value") {
                    string.add("potato") { (inout a: Attributes) in
                        a.strokeColor = .redColor()
                    }
                    expect(string.lastAttributes).to(haveCount(1))
                    expect(string.lastAttributes![NSStrokeColorAttributeName] as? UIColor).to(equal(UIColor.redColor()))
                }
                
                it("overrides existent value with a new one") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.strokeColor = .redColor()
                    }
                    string.add("potato") { (inout a: Attributes) in
                        expect(string.lastAttributes).to(haveCount(1))
                        expect(string.lastAttributes![NSStrokeColorAttributeName] as? UIColor).to(equal(UIColor.redColor()))

                        a.strokeColor = .blueColor()
                    }
                    expect(string.lastAttributes).to(haveCount(1))
                    expect(string.lastAttributes?[NSStrokeColorAttributeName] as? UIColor).to(equal(UIColor.blueColor()))
                }
                
                it("removes existent value when set to nil") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.strokeColor = UIColor.redColor()
                    }
                    string.add("potato") { (inout a: Attributes) in
                        a.strokeColor = nil
                    }
                    expect(string.lastAttributes).to(haveCount(0))
                }
                
            }
            
            describe("textEffect") {
                it("sets new value") {
                    string.add("potato") { (inout a: Attributes) in
                        a.textEffect = .Letterpress
                    }
                    expect(string.lastAttributes).to(haveCount(1))
                    expect(string.lastAttributes![NSTextEffectAttributeName] as? String).to(equal(NSTextEffectLetterpressStyle))
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
                        expect(string.lastAttributes).to(haveCount(1))
                        expect(string.lastAttributes?[NSTextEffectAttributeName] as? String).to(equal(NSTextEffectLetterpressStyle))
                       
                        a.textEffect = .Letterpress
                    }
                    expect(string.lastAttributes).to(haveCount(1))
                    expect(string.lastAttributes?[NSTextEffectAttributeName] as? String).to(equal(NSTextEffectLetterpressStyle))
                }
                
                it("removes existent value when set to nil") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.textEffect = .Letterpress
                    }
                    string.add("potato") { (inout a: Attributes) in
                        a.textEffect = nil
                    }
                    expect(string.lastAttributes).to(haveCount(0))
                }
                
            }
            
            describe("underline") {
                it("sets new value") {
                    string.add("potato") { (inout a: Attributes) in
                        a.underline = .StyleSingle
                    }
                    expect(string.lastAttributes!).to(haveCount(1))
                    expect(NSUnderlineStyle(rawValue: string.lastAttributes![NSUnderlineStyleAttributeName] as! Int)).to(equal(NSUnderlineStyle.StyleSingle))
                }
                
                it("overrides existent value with a new one") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.underline = .StyleSingle
                    }
                    string.add("potato") { (inout a: Attributes) in
                        expect(string.lastAttributes!).to(haveCount(1))
                        expect(NSUnderlineStyle(rawValue: string.lastAttributes![NSUnderlineStyleAttributeName] as! Int)).to(equal(NSUnderlineStyle.StyleSingle))
                        a.underline = .StyleThick
                    }
                    expect(string.lastAttributes!).to(haveCount(1))
                    expect(NSUnderlineStyle(rawValue: string.lastAttributes![NSUnderlineStyleAttributeName] as! Int)).to(equal(NSUnderlineStyle.StyleThick))
                }
                
                it("removes existent value when set to nil") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.underline = .StyleThick
                    }
                    string.add("potato") { (inout a: Attributes) in
                        a.underline = nil
                    }
                    expect(string.lastAttributes).to(haveCount(0))
                }
            }

            describe("underlineColor") {
                it("sets new value") {
                    string.add("potato") { (inout a: Attributes) in
                        a.underlineColor = .redColor()
                    }
                    expect(string.lastAttributes!).to(haveCount(1))
                    expect(string.lastAttributes![NSUnderlineColorAttributeName] as? UIColor).to(equal(UIColor.redColor()))
                }
                
                it("overrides existent value with a new one") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.underlineColor = .redColor()
                    }
                    string.add("potato") { (inout a: Attributes) in
                        expect(string.lastAttributes!).to(haveCount(1))
                        expect(string.lastAttributes![NSUnderlineColorAttributeName] as? UIColor).to(equal(UIColor.redColor()))
                        a.underlineColor = .blueColor()
                    }
                    expect(string.lastAttributes!).to(haveCount(1))
                    expect(string.lastAttributes![NSUnderlineColorAttributeName] as? UIColor).to(equal(UIColor.blueColor()))
                }
                
                it("removes existent value when set to nil") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.underlineColor = .redColor()
                    }
                    string.add("potato") { (inout a: Attributes) in
                        a.underlineColor = nil
                    }
                    expect(string.lastAttributes).to(haveCount(0))
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
                    expect(string.lastAttributes!).to(haveCount(1))
                    expect(string.lastAttributes![NSLinkAttributeName] as? NSURL).to(equal(url1))
                }
                
                it("overrides existent value with a new one") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.URL = url1
                    }
                    string.add("potato") { (inout a: Attributes) in
                        expect(string.lastAttributes!).to(haveCount(1))
                        expect(string.lastAttributes![NSLinkAttributeName] as? NSURL).to(equal(url1))

                        a.URL = url2
                    }
                    expect(string.lastAttributes!).to(haveCount(1))
                    expect(string.lastAttributes![NSLinkAttributeName] as? NSURL).to(equal(url2))
                }
                
                it("removes existent value when set to nil") {
                    string.add("tomato") { (inout a: Attributes) in
                        a.URL = url1
                    }
                    string.add("potato") { (inout a: Attributes) in
                        a.URL = nil
                    }
                    expect(string.lastAttributes).to(haveCount(0))
                }
                
            }
            
        }
    }
}

extension NSAttributedString {
    var lastAttributes: [String: AnyObject]? {
        guard length > 0 else {
            return nil
        }
        return attributesAtIndex(length - 1, effectiveRange: nil)
    }
    
    func attributesAtIndex(index: Int) -> [String: AnyObject] {
        return attributesAtIndex(index, effectiveRange: nil)
    }
}
