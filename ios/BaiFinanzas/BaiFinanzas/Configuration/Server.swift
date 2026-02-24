import Foundation

enum Server {
    // MARK: - Change this to your production URL
   // static let baseURL = URL(string:"https://baifinanzas-c965c9e3b19a.herokuapp.com")!
    static let baseURL = URL(string: "http://localhost:3000")!

    static let pathConfigurationURL = baseURL.appendingPathComponent("native/path-configuration")

    static func url(path: String) -> URL {
        baseURL.appendingPathComponent(path)
    }
}
