//
//  Saved.swift
//  Near
//
//  Created by Adnann Muratovic on 24.05.25.
//

import SwiftUI

struct Saved: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Adnann")
                Text("Muratovic")
                    .font(.caption)
            }
            
            Spacer()
            
            Text("20.20.2025")
                .font(.caption)
        }
        
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 15)
                .stroke(.gray.opacity(0.3), lineWidth: 1)
        }
        
        
        
        Spacer()
    }
}


#Preview {
    Saved()
}
