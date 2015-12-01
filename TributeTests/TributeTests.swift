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
//        context("starting with empty string") {
            var string: NSMutableAttributedString!
            
            beforeEach{
                string = NSMutableAttributedString()
            }
            
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
                    string.add("pineapple", resetRunningAttributes: true)
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
                        a.font = nil
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
        }
//    }
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
