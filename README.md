# Tribute

```swift

let string = NSMutableAttributedString().add("Hello ") {
	$0.color = .redColor()
	$0.underline = .StyleSingle
}.add("world ") {
	$0.font = .systemFontOfSize(20)
	$0.stroke = .Filled(width: 2)
	$0.textEffect = .Letterpress
}.add("of Swift "){
	$0.font = .systemFontOfSize(12)
	$0.textEffects = nil
}.add(UIImage(named: "swift")!)
```

# Design Goals

1. Word processor logic: appending a string should inherit last attributes.
1. Allow for easy customization of common properties, including toggle bold or change the font size.
1. Flatten paragraph style and attrbiutes, no more 5 lines of code if all you wanted is to change text alignment.
1. Minimal overhead: produce only required attributes.
1. Have an attributed string ready to use every time you leave the configuration block.
1. Replace string constants with strongly typed enums where possible.

# Notes

1. Keep in mind that playground doesn't always render `NSAttributesString` correctly (font variations and attachments are few of the problematic I noticed). Use a `UILabel` as a live view instead: `XCPlaygroundPage.currentPage.liveView = label`.
2. Not all fonts have both italic and bold variations, you can use `obliqueness` property as a poor man italic



*This is just a tribute*
