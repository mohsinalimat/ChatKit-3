//
//  MessengesUIHelper.swift
//  chatUI
//
//  Created by Faris Albalawi on 6/8/20.
//  Copyright © 2020 Faris Albalawi. All rights reserved.
//

import Foundation


extension MessagesUI {
    

    
    
    
   func insert(_ messages: [Messages], callback: (() -> Void)? = nil) {
      MessagesViewModel.shared.GroupedMessages(Messages: messages) { (messages) in
              self.tableView.reloadData()
              DispatchQueue.main.async {
                  let lastRow: Int = self.tableView.numberOfRows(inSection: messages.count - 1) - 1
                  let indexPath = IndexPath(row: lastRow, section: messages.count - 1);
                  self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                  DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        callback?()
                    }
              }
          }
    }
    
    
    func remove(_ message: Messages) {
        
        // TODO: Needs implementing
        
    }
}
