import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    let file = FileMiddleware(publicDirectory: app.directory.publicDirectory)
    app.middleware.use(file)
    app.views.use(.plaintext)
    app.http.client.configuration.decompression = .enabled(limit: .size(Int.max))

    // register routes
    try routes(app)
}
