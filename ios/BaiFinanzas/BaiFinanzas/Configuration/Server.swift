import Foundation

enum Server {
    // MARK: - Change this to your production URL
    static let baseURL = URL(string: "https://baifinanzas.com")!

    static let pathConfigurationURL = baseURL.appendingPathComponent("native/path-configuration")

    static func url(path: String) -> URL {
        baseURL.appendingPathComponent(path)
    }
}
