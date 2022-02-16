import Vapor
import Gzip

struct EditSiteForm: Content {
    static var defaultContentType: HTTPMediaType = .formData
   
    let website: String
}

struct SaveSiteForm: Content {
    static var defaultContentType: HTTPMediaType = .json
    
    let savedDocument: String
}

func routes(_ app: Application) throws {
    app.get { req in
        return req.view.render("index.html")
    }

    app.get("hello") { req -> String in
        return "Hello, world!"
    }
    
    app.post("edit") { req -> Response in
        let form = try req.content.decode(EditSiteForm.self)
        
        let website: URI = form.website == "" ? URI("http://motherfuckingwebsite.com") : URI(stringLiteral: form.website)
        print(website)
        
        let doc = try await recursiveDownload(req: req, uri: website)
        let editableHTML = try makeEditable(req: req, doc: doc)
        
        let response = try await editableHTML.encodeResponse(for: req)
        response.headers.contentType = .html
        
        return response
    }
    
    app.post("save") { req -> Response in
        let body = try req.content.decode(SaveSiteForm.self)
        
        let editedHTML = try makeNotEditable(req: req, content: body.savedDocument)
        
        let response = try await editedHTML.encodeResponse(for: req)
        response.headers.contentType = .html
        
        return response
    }
}
