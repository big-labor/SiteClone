import Vapor

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
        print(form.website)
        
        let site = try await req.client.get("http://motherfuckingwebsite.com")
        let content = String(bytes: site.body!.readableBytesView, encoding: .utf8)!
        let editableHTML = try makeEditable(req: req, content: content)
        
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
