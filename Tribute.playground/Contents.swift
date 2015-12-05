//: Playground - noun: a place where people can play

import Tribute

let image = [#Image(imageLiteral: "swift@2x.png")#]

let string = NSMutableAttributedString()
    .add("hello world") {
        $0.underline = NSUnderlineStyle.StyleSingle
        $0.color = .blueColor()
    }
    .add(image)
    .add("hello world")
string

