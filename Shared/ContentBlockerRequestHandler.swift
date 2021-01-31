import Foundation

class ContentBlockerRequestHandler: NSObject, NSExtensionRequestHandling {
    func beginRequest(with context: NSExtensionContext) {
        var blockListURL = Bundle.main.url(forResource: "blockerList", withExtension: "json")
        let appGroupDirectory = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Config.appGroupIdentifier)
        let downloadedBlockListURL = appGroupDirectory?.appendingPathComponent("blockerList.json")
        if (FileManager.default.fileExists(atPath: downloadedBlockListURL!.path)) {
            blockListURL = downloadedBlockListURL
        }
        let attachment = NSItemProvider(contentsOf: blockListURL)!

        let item = NSExtensionItem()
        item.attachments = [attachment]

        context.completeRequest(returningItems: [item], completionHandler: nil)
    }
}
