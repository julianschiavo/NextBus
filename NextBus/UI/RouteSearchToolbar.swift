//
//  RouteSearchToolbar.swift
//  NextBus
//
//  Created by Julian Schiavo on 11/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI
import UIKit

class RouteSearchToolbar: UIToolbar {
    @Binding var searchText: String
    
    init(searchText: Binding<String>) {
        self._searchText = searchText
        super.init(frame: .zero)
        
        let flexible = UIBarButtonItem(systemItem: .flexibleSpace)
        
        let aAction = UIAction { _ in
            self.addLetter("A")
        }
        let a = UIBarButtonItem(title: "A", primaryAction: aAction)
        a.style = .done
        
        let bAction = UIAction { _ in
            self.addLetter("B")
        }
        let b = UIBarButtonItem(title: "B", primaryAction: bAction)
        b.style = .done
        
        let mAction = UIAction { _ in
            self.addLetter("M")
        }
        let m = UIBarButtonItem(title: "M", primaryAction: mAction)
        m.style = .done
        
        let nAction = UIAction { _ in
            self.addLetter("N")
        }
        let n = UIBarButtonItem(title: "N", primaryAction: nAction)
        n.style = .done
        
        let pAction = UIAction { _ in
            self.addLetter("P")
        }
        let p = UIBarButtonItem(title: "P", primaryAction: pAction)
        p.style = .done
        
        let rAction = UIAction { _ in
            self.addLetter("R")
        }
        let r = UIBarButtonItem(title: "R", primaryAction: rAction)
        r.style = .done
        
        let sAction = UIAction { _ in
            self.addLetter("S")
        }
        let s = UIBarButtonItem(title: "S", primaryAction: sAction)
        s.style = .done
        
        let xAction = UIAction { _ in
            self.addLetter("X")
        }
        let x = UIBarButtonItem(title: "X", primaryAction: xAction)
        x.style = .done
        
        items = [flexible, a, b, m, n, p, r, s, x, flexible]
        
        sizeToFit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addLetter(_ letter: Character) {
        DispatchQueue.main.async {
            self.searchText.append(letter)
        }
    }
}
