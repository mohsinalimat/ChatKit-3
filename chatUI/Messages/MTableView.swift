//
//  MTableView.swift
//  chatUI
//
//  Created by Faris Albalawi on 6/9/20.
//  Copyright © 2020 Faris Albalawi. All rights reserved.
//

import Foundation
import UIKit


extension MessagesUI: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get the cell for the index of the model
        guard let cell = tableView.cellForRow(at: .init(row: indexPath.row, section: indexPath.section)) as? MessageCell else { return }
        let positionInBlock = MessagesViewModel.shared.getPositionInBlockForMessageAtIndex(indexPath.section, indexPath.row)
        switch positionInBlock {
        case .bottom, .single:
            /// the last row (date show always)
            cell.messageStatusView.isHidden = false
        default:
            if cell.messageStatusView.isHidden {
                 self.tableView.beginUpdates()
                 cell.messageStatusView.isHidden = false
                 self.tableView.endUpdates()
            } else {
                 self.tableView.beginUpdates()
                 cell.messageStatusView.isHidden = true
                 self.tableView.endUpdates()
            }
        }
        
        endEditing(true)
    }
    

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
       // Get the cell for the index of the model
       guard let cell = tableView.cellForRow(at: .init(row: indexPath.row, section: indexPath.section)) as? MessageCell else { return }
       let positionInBlock = MessagesViewModel.shared.getPositionInBlockForMessageAtIndex(indexPath.section, indexPath.row)
       switch positionInBlock {
       case .bottom, .single:
            /// the last row (date show always)
           cell.messageStatusView.isHidden = false
       default:
            self.tableView.beginUpdates()
            cell.messageStatusView.isHidden = true
            self.tableView.endUpdates()
       }
        
    }
    
 
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        guard let item = dataSource?.message(for: indexPath) else {
                 fatalError("Message not defined for \(indexPath)")
            }
        
        let identifier = ["row": indexPath.row, "section": indexPath.section]
        switch item.type {
        case .text:
             return UIContextMenuConfiguration(identifier: identifier as NSCopying, previewProvider: nil) { _ -> UIMenu? in
                return self.TextContextMenu(text: item.text!)
            }
        case .file:
             return UIContextMenuConfiguration(identifier: identifier as NSCopying, previewProvider: nil) { _ -> UIMenu? in
                return self.ImageContextMenu()
            }
        case .sticker:
            print("sticker")
        case .map:
            print("map")
        case .audio:
            print("audio")
        case .caption:
            return UIContextMenuConfiguration(identifier: identifier as NSCopying, previewProvider: nil) { _ -> UIMenu? in
                return self.CaptionContextMenu(text: item.text!)
            }
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {

         // Ensure we can get the expected identifier
         guard let identifier = configuration.identifier as? [String : Int] else { return nil }

         print(configuration.identifier)
         // Get the current index of the identifier
         let row = identifier["row"]!
         let section = identifier["section"]!

         // Get the cell for the index of the model
         guard let cell = tableView.cellForRow(at: .init(row: row, section: section)) as? MessageCell else { return nil }

         // Since our preview has its own shape (a circle) we need to set the preview parameters
         // backgroundColor to clear, or we'll see a white rect behind it.
         let parameters = UIPreviewParameters()
         parameters.backgroundColor = .clear

         // Return a targeted preview using our cell previewView and parameters
         return UITargetedPreview(view: cell, parameters: parameters)
     }
    
    
    private func updateCell(row: Int,section: Int){
        let indexPath = NSIndexPath(row: row, section: section)
        tableView.beginUpdates()
        tableView.reloadRows(at: [(indexPath as IndexPath)], with: UITableView.RowAnimation.automatic)
        tableView.endUpdates()
    }
    
}
