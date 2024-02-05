//
//  FlexibleView.swift
//  Flowzland
//
//  Created by flowz-leo on 2023/12/25.
//

import SwiftUI

struct FlexibleView<Data: Collection, Content: View>: View where Data.Element: Hashable {
    let data: Data
    let spacing: CGFloat
    let availableWidth: CGFloat
    var alignment: HorizontalAlignment = .leading
    var targetline: Int = 3

    let content: (Data.Element) -> Content
    @State var elementsSize: [Data.Element: CGSize] = [:]

    var body: some View {
        if data.isEmpty {
            EmptyView()
        } else {
            ZStack(alignment: .topLeading) {
                VStack(alignment: alignment, spacing: spacing) {
                    ForEach(0 ..< targetline, id: \.self) { _ in
                        content(data.first!) // 每个
                            .fixedSize()
                            .opacity(0)
                    }
                }

                VStack(alignment: alignment, spacing: spacing) {
                    ForEach(computeRows(), id: \.self) { rowElements in
                        HStack(spacing: spacing) { // 每行
                            ForEach(rowElements, id: \.self) { element in
                                content(element) // 每个
                                    .fixedSize()
                                    .readSize { size in
                                        elementsSize[element] = size
                                    }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func computeRows() -> [[Data.Element]] {
        var rows: [[Data.Element]] = [[]]
        var currentRow = 0
        var remainingWidth = availableWidth

        for element in data {
            let elementSize = elementsSize[element, default: CGSize(width: availableWidth, height: 1)]

            if remainingWidth - (elementSize.width + spacing) >= -4 {
                rows[currentRow].append(element)
            } else {
                currentRow = currentRow + 1
                rows.append([element])
                remainingWidth = availableWidth
            }

            remainingWidth = remainingWidth - (elementSize.width + spacing)
        }

        return rows
    }
}


