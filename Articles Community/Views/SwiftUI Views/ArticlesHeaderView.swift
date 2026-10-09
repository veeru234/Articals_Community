//
//  ArticlesHeaderView.swift
//  Articles Community
//
//  Created by Veeru Masal on 08/10/26.
//


import SwiftUI

struct ArticlesHeaderView: View {
    var title: String = "Articles"
    var isGridMode: Bool = false          // false = list mode, true = grid mode
    var onGridTap: () -> Void = {}
    var onSearchTap: () -> Void = {}

    var body: some View {
        HStack(spacing: 8) {
            Text(title)
                .font(AppFont.font(.bold, size: 30, style: .title))
                .foregroundColor(.black)
                .lineLimit(1)
                .minimumScaleFactor(0.7)

            Spacer()

            // Shows the layout you will switch TO:
            // list mode -> grid icon, grid mode -> list icon
            iconButton(isGridMode ? ButtonImageName.list : ButtonImageName.grid,
                       action: onGridTap)

            iconButton(ButtonImageName.search, action: onSearchTap)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(colors: [.white, Color(white: 0.94)],
                           startPoint: .top,
                           endPoint: .bottom)
                .ignoresSafeArea(edges: .top)
        )
    }

    private func iconButton(_ imageName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(imageName)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 26, height: 26)
                .foregroundColor(.black)
                .frame(width: 44, height: 44)
        }
    }
}
