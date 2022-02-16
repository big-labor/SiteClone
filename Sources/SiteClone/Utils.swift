import Foundation
import SwiftSoup
import Files
import Vapor

private let editableTags = "p, h1, h2, h3, a, button, li, blockquote, aside, span, div, summary"

func makeEditable(req: Request, doc: Document) throws -> String {
    
    // we don't want our right click menu to also be editable
    try doc.select(editableTags).attr("contenteditable", "true")
    
    let htmlFilePath = req.application.directory.publicDirectory.appending("RightClickMenu/html/RightClickMenu.html")
    let htmlFile = try File(path: htmlFilePath)
    let html = try htmlFile.readAsString()
    try doc.body()?.append(html)
    
    let css = #"<link class="site-edit" rel="stylesheet" type="text/css" href="RightClickMenu/css/RightClickMenu.css">"#
    try doc.head()?.append(css)
    
    let js = #"<script class="site-edit" src="RightClickMenu/js/RightClickMenu.js" type="text/javascript"></script>"#
    try doc.head()?.append(js)
    
    return try doc.html()
}

func makeNotEditable(req: Request, content: String) throws -> String {
    let doc = try SwiftSoup.parse(content)
    
    try doc.select(editableTags).removeAttr("contenteditable")
    let siteEditElements = try doc.select(".site-edit")
    try siteEditElements.remove()
    
    return try doc.html()
}

func recursiveDownload(req: Request, uri: URI) async throws -> Document {
    var site = try await req.client.get(uri)
    print(site.headers.debugDescription)
    
    let contentData = site.body!.readData(length: site.body!.readableBytes)!
    let encoding = getEncoding(httpHeaders: site.headers)
    
    let content = String(data: contentData, encoding: encoding)!
    return try SwiftSoup.parse(content)
}

func getEncoding(httpHeaders: HTTPHeaders) -> String.Encoding {
    if httpHeaders.contentType?.parameters["charset"] == "ISO-8859-1" {
        return .isoLatin1
    }
    
    return .utf8
}
