//: Playground - noun: a place where people can play

import Tribute
import XCPlayground


let string = NSMutableAttributedString()
    .add("Tribute is a ") {
        $0.font = .systemFontOfSize(15)
        $0.color = [#Color(colorLiteralRed: 0.8504372835, green: 0.2181603462, blue: 0.1592026055, alpha: 1)#]
    }
    .add("micro") {
        $0.obliqueness = 0.2
        $0.underline = .StyleSingle
        $0.color = [#Color(colorLiteralRed: 0.7608990073, green: 0.2564961016, blue: 0, alpha: 1)#]
    }.add(" library") {
        $0.underline = nil
        $0.color = [#Color(colorLiteralRed: 0.8526210189, green: 0.4221832156, blue: 0, alpha: 1)#]
    }.add(" for ") {
        $0.obliqueness = nil
        $0.color = [#Color(colorLiteralRed: 0.9767052531, green: 0.605463922, blue: 0, alpha: 1)#]
    }
    .add([#Image(imageLiteral: "swift@2x.png")#], bounds: CGRect(x: 0, y: -8, width: 30, height: 30))
    .add("\nIt simplifies"){
        $0.reset()
        $0.color = [#Color(colorLiteralRed: 0.5948907137, green: 0.7498663664, blue: 0, alpha: 1)#]
        $0.alignment = .Center
    }
    .add(" ")
    .add(" the way you work with") {
        $0.font = .systemFontOfSize(10)
        $0.URL = NSURL(string: "http://google.com")!
    }.add("\nNSAttributedStrings") {
        $0.URL = nil
        $0.font = UIFont(name: "Courier", size: 14)
        $0.color = [#Color(colorLiteralRed: 0.1819814891, green: 0.6942673326, blue: 0.5302479267, alpha: 1)#]
    }

string
let page = XCPlaygroundPage.currentPage
page.needsIndefiniteExecution = true

let label = UILabel()
label.attributedText = string
label.numberOfLines = 0
label.sizeToFit()
label.backgroundColor = [#Color(colorLiteralRed: 0.9607843136999999, green: 0.9607843136999999, blue: 0.9607843136999999, alpha: 1)#]
page.liveView = label
