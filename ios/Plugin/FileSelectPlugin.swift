import Foundation
import Capacitor
import CoreServices

@objc(FileSelectPlugin)
public class FileSelectPlugin: CAPPlugin, UIDocumentPickerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var savedCall: CAPPluginCall? = nil
    
    @objc func select(_ call: CAPPluginCall) {
        savedCall = call
        
        let multiple = call.getBool("multiple") ?? true
        let extensions = call.getArray("extensions", String.self) ?? ["*"]
        var extUTIs: [String] = []
        for element in extensions
        {
            var extUTI:CFString?
            if(element == "images")
            {
                extUTI = kUTTypeImage
            }
            else if(element == "videos")
            {
                extUTI = kUTTypeVideo
            }
            else if(element == "audios")
            {
                extUTI = kUTTypeAudio
            }
            else if(element == "*")
            {
                extUTI = kUTTypeData
            }
            else
            {
                extUTI  = UTTypeCreatePreferredIdentifierForTag(
                    kUTTagClassFilenameExtension,
                    element as CFString,
                    nil
                )?.takeRetainedValue()
            }
            extUTIs.append(extUTI! as String)
        }
        
        DispatchQueue.main.async {
            if (extUTIs[0] == (kUTTypeImage as String)) {
                let picker = UIImagePickerController();
                picker.delegate = self
                picker.sourceType = .photoLibrary

                self.bridge!.viewController!.present(picker, animated: true)
            } else {
                let types: [String] = extUTIs
                let documentPicker = UIDocumentPickerViewController(documentTypes: types, in: .import)
                documentPicker.delegate = self
                documentPicker.modalPresentationStyle = .formSheet
                documentPicker.allowsMultipleSelection = multiple

                self.bridge!.viewController!.present(documentPicker, animated: true)
            }
        }
    }

    private func urlToFile(_ url: URL) -> PluginCallResultData {
        return [
            "path": url.absoluteString,
            "name": url.lastPathComponent,
            "extension": url.pathExtension
        ]
    }
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        var files: [PluginCallResultData] = []
        for value in urls
        {
            files.append(urlToFile(value));
        }
        savedCall!.resolve(["files": files])
    }
    
    public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        savedCall!.reject("canceled", "1")
    }

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let fileUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL else { return }

        var files: [PluginCallResultData] = []
        files.append(urlToFile(fileUrl))

        savedCall!.resolve(["files": files])
    }

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        savedCall!.reject("canceled", "1")
    }

    @objc func imagePickerController(_ picker: UIImagePickerController, pickedImage: UIImage?) {
    }
}
