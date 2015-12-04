//: Playground - noun: a place where people can play

import Tribute

let string = NSMutableAttributedString().add("Hello") {
    $0.font = .systemFontOfSize(20)
    $0.color = .blueColor()
    $0.URL = NSURL(string: "http://google.com")!
    $0.underline = .StyleSingle
}.add(" world") {
    $0.underline = nil
    $0.color = nil
}

string
