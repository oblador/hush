import Foundation

extension UserDefaults {
    @objc dynamic var backgroundRefreshEnabled: Bool {
        return bool(forKey: "backgroundRefreshEnabled")
    }
    @objc dynamic var rulesLastRefreshedAt: Int {
        return integer(forKey: "rulesLastRefreshedAt")
    }
}
