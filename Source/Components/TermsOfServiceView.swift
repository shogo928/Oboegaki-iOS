//
//  TermsOfServiceView.swift
//  Oboegaki-iOS
//
//  Created by sakumashogo on 2021/08/27.
//

import SwiftUI

struct TermsOfServiceView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color(.white).edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                TitllText
                
                Spacer().frame(height:20)
                
                infoTextScroll.padding(.horizontal, 20)
                
                Spacer().frame(height:30)
                
                backButton
                
                Spacer().frame(height:40)
            }
        }
    }
}

extension TermsOfServiceView {
    var TitllText: some View {
        HStack {
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color("MediumGray"))
                .cornerRadius(24)
            Spacer()
            Text("利用規約")
                .font(.system(size: 30, weight: .black, design: .default))
                .foregroundColor(Color("MediumGray"))
                .lineLimit(1)
                .frame(width: 140)
            Spacer()
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color("MediumGray"))
                .cornerRadius(24)
        }.padding(.horizontal, 20)
    }
    
    var infoTextScroll: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: true) {
                Text("規約書面出来次第記載")
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                    .frame(width: geometry.size.width)
            }.background(Color("backgroundGray"))
        }
    }
    
    var backButton: some View {
        Button(
            action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("戻る")
                    .bold()
                    .frame(width: 200, height: 40, alignment: .center)
                    .background(Color("Primary"))
                    .foregroundColor(.white)
                    .cornerRadius(9)
            }
        )
        .frame(width: 200, height: 40, alignment: .center)
    }
}

struct TermsOfServiceView_Previews: PreviewProvider {
    static var previews: some View {
        TermsOfServiceView()
    }
}
