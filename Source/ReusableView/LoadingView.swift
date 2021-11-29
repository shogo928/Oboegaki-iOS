//
//  LoadingView.swift
//  Oboegaki-iOS
//
//  Created by sakumashogo on 2021/08/23.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.white)
                .opacity(0.6)
            ProgressView("")
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
