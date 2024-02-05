//
//  TimeColorView.swift
//  Flowzland
//
//  Created by flowz-leo on 2024/1/23.
//


import SwiftUI

struct TimeColorView: View {
    @Binding var mCells: [TimeCellBean]
    var strokeColor = Color.secondary
    private let itemLong = 32.0

    private func loadStart() {
        //
    }

    func setContent(_ bean: TimeCellBean, _ isStart: Bool = true) -> some View {
        Image(systemName: isStart ? bean.type.firstIcon : bean.type.secIcon)
            .font(TextStyles.footnoteSemibold)
            .foregroundColor(Color.white)
            .frame(width: itemLong, height: itemLong)
            .background(isStart ? bean.type.mainColor() : bean.type.secColor())
            .clipShape(Circle())
            .overlay {
                RoundedRectangle(cornerRadius: 100, style: .continuous)
                    .stroke(strokeColor, lineWidth: 2)
            }
            .overlay(alignment: .center) {
                Text("\((isStart ? bean.firstStamp : bean.secStamp).hourNum.twoString):\((isStart ? bean.firstStamp : bean.secStamp).minuteNum.twoString)")
                    .padding(.all, 2)
                    .frame(width: 44, height: 19)
                    .background(strokeColor)
                    .cornerRadius(30)
                    .font(.footnote)
//                    .foregroundColor(Color.tertiaryLabel)
                    .offset(y: itemLong)
            }
    }

    func getGradient() -> Gradient {
        var arr = [Gradient.Stop]()

        let stop = Gradient.Stop(color: .black, location: 0)
        arr += [stop]
        mCells.forEach { cell in
            let stop = Gradient.Stop(color: cell.type.mainColor(), location: cell.firstStamp / everyDayStamp)
            if cell.type == .Sleep || cell.type == .Work {
                let stop = Gradient.Stop(color: cell.type.secColor(), location: cell.secStamp / everyDayStamp)
                arr += [stop]
            }
            arr += [stop]
        }
        let stop1 = Gradient.Stop(color: .black, location: 1)
        arr += [stop1]

        let sortedArray = arr.sorted { $0.location < $1.location }

        return Gradient(stops: sortedArray)
    }

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Capsule()
                    .fill(LinearGradient(gradient: getGradient(), startPoint: .leading, endPoint: .trailing))
                    .frame(height: 8)
                    .overlay(alignment: .center) {
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                ForEach(mCells) { cell in
                                    setContent(cell).offset(x: cell.firstStamp / everyDayStamp * (geo.size.width - itemLong))
                                    if cell.type == .Sleep || cell.type == .Work {
                                        setContent(cell, false).offset(x: cell.secStamp / everyDayStamp * (geo.size.width - itemLong))
                                    }
                                }
                                .animation(.bouncy)
                            }
                            .offset(x: 0, y: -12)
                        }
                    }
            }
            .frame(height: itemLong)
            .padding(.bottom, 8)

            HStack(spacing: 0) {}
                .frame(height: 15)
        }
        .onAppear {
            loadStart()
        }
    }
}
