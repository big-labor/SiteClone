import Foundation
import SwiftSoup
import Files
import Vapor

func makeEditable(req: Request, content: String) throws -> String {
    let doc = try SwiftSoup.parse(content)
    
    // we don't want our right click menu to also be editable
    try doc.select("p, h1, h2, h3, a, button, li, blockquote").attr("contenteditable", "true")
    
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
    
    try doc.select("p, h1, h2, h3, a, button, li, blockquote").removeAttr("contenteditable")
    let siteEditElements = try doc.select(".site-edit")
    try siteEditElements.remove()
    
    return try doc.html()
}

//func recursiveDownload(url: URL) async throws -> Document {
//    let session = URLSession.shared
//    let (data, response) = try await session.data(from: url)
//    print(response)
//    return try SwiftSoup.parse(String(data: data, encoding: .utf8)!)
//}
