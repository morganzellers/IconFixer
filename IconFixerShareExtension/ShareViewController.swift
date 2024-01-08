//
//  ShareViewController.swift
//  IconFixerShareExtension
//
//  Created by Morgan Zellers on 1/7/24.
//

import UIKit
import Social
import MobileCoreServices
import UniformTypeIdentifiers

class ShareViewController: SLComposeServiceViewController {

    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
        
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        let content = extensionContext?.inputItems.first as? NSExtensionItem
        let attachments = content?.attachments ?? []
        
        for attachment in attachments {
            if let typeIdentifier = attachment.registeredTypeIdentifiers.first,
               typeIdentifier == UTType.image.identifier {
                attachment.loadItem(forTypeIdentifier: typeIdentifier, options: nil) { (item, error) in
                    if let url = item as? URL, let imageData = try? Data(contentsOf: url), let image = UIImage(data: imageData) {
                        // Process and use the shared image here
                    }
                    self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
                }
            }
        }
    }
    
    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }
    
}
