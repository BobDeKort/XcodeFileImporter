//
//  ViewController.swift
//  XcodeFileImporter
//
//  Created by Bob De Kort on 27/02/2019.
//  Copyright © 2019 Bob De Kort. All rights reserved.
//

import Cocoa
import PathKit
import xcodeproj

class ViewController: NSViewController {
    
    @IBOutlet weak var selectProjectButton: NSButton!
    @IBOutlet weak var selectedProjectLabel: NSTextField!
    @IBOutlet weak var importFileButton: NSButton!
    
    let staticFileURL: URL = URL(fileURLWithPath: "/Users/bob/Desktop/TestImport.swift")
    
    var projectURL: URL?
    var project: XcodeProj? {
        didSet {
            if let project = project {
                selectedProjectLabel.stringValue = project.pbxproj.rootObject?.name ?? "No project found"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    private func getProject(with path: String) {
        projectURL = URL(fileURLWithPath: path)
        do {
            project = try XcodeProj(pathString: projectURL!.relativePath)
        } catch {
            print(error)
        }
    }

    @IBAction func selectProjectButtonPressed(_ sender: Any) {
        let dialog = NSOpenPanel()
        
        dialog.title = "Select the Xcode project you want to import files to"
        dialog.showsResizeIndicator = true
        dialog.showsHiddenFiles = false
        dialog.canChooseDirectories = false
        dialog.canCreateDirectories = false
        dialog.allowsMultipleSelection = false
        dialog.allowedFileTypes = ["xcodeproj"]
        
        if dialog.runModal() == NSApplication.ModalResponse.OK {
            if let result = dialog.url {
                getProject(with: result.path)
            }
        }
    }
    @IBAction func importFileButtonPressed(_ sender: Any) {
        print("Import")
        if let project = project {
            addNewGroup(project: project, with: [])
        }
//        if
//            let project = project,
//            let root = project.pbxproj.rootObject?.mainGroup,
//            let rootPath = root.path // -> Nil
//        {
//
//            do {
//                let file = try root.addFile(at: Path(staticFileURL.path),
//                                            sourceTree: .group,
//                                            sourceRoot: Path(rootPath))
//                print("file name: \(file.name)")
//
//            } catch {
//                print(error)
//            }
//
//
////
//
//            do {
//                if let root = try project.pbxproj.rootGroup() {
//                    try root.addFile(at: Path(staticFileURL.path),
//                                     sourceRoot: Path(projectURL!.path))
//
//                    try project.write(path: Path(projectURL!.path))
//                }
//            } catch {
//                print(error)
//            }
//        }
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    private func addNewGroup(project: XcodeProj, with children: [PBXFileElement]) {
        let newGroup = PBXGroup(children: children,
                                sourceTree: .group,
                                name: "Extensions")
        
        project.pbxproj.add(object: newGroup)
        
        do {
            if let projectURL = projectURL {
                print(projectURL.relativePath)
                try project.write(path: Path(projectURL.relativePath))
            }
        } catch {
            print(error)
        }
    }
}

