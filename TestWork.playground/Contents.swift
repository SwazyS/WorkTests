import UIKit

do {
    let html: String = "<p>An <a href='http://example.com/'><b>example</b></a> link.</p>";
    let doc: Document = try SwiftSoup.parse(html)
    let link: Element = try doc.select("a").first()!
    
    let text: String = try doc.body()!.text(); // "An example link"
    let linkHref: String = try link.attr("href"); // "http://example.com/"
    let linkText: String = try link.text(); // "example""
    
    let linkOuterH: String = try link.outerHtml(); // "<a href="http://example.com"><b>example</b></a>"
    let linkInnerH: String = try link.html(); // "<b>example</b>"
} catch Exception.Error(let type, let message) {
    print(message)
} catch {
    print("error")
}
