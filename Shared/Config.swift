import Foundation

class Config {
    static let appGroupName = "se.oblador.Hush"
    static let bundleIndentifier = Bundle.main.bundleIdentifier ?? appGroupName
    #if os(macOS)
    public static let appGroupIdentifier = "\(Bundle.main.object(forInfoDictionaryKey: "TeamIdentifierPrefix") ?? "H28Z7NT4JR.")group.\(appGroupName)"
    #else
    public  static let appGroupIdentifier = "group.\(appGroupName)"
    #endif
    public static let contentBlockerIdentifier = "\(bundleIndentifier).ContentBlocker"
    public static let fetchRulesTaskIdentifier = "\(bundleIndentifier).fetchRules"
    public static let blockListDownloadURL = "https://raw.githubusercontent.com/oblador/hush/build-latest/block-list-v1.json"
}
