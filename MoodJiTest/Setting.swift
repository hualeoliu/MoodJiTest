//
//  Seting.swift
//  MoodJiTest
//
//  Created by ZZ on 2023/12/12.
//

import SwiftUI

struct Setting: View {
    @Environment(\.colorScheme) var curMode
    @EnvironmentObject var coloState: MainColorModel

    let options = ["Auto", "Light", "Dark"]
    @State private var isPopoverVisible = false
    @State private var viewFrame: CGRect = .zero

    private var lightV: some View {
        VStack(alignment: .leading) {
            HStack {
                Image("set_appearance")
                Text("Appearance")
                    .font(TextStyles.bodySemibold)
                    .foregroundColor(Color(UIColor.label))
            }
            Text("Set to Auto will follow system appearance")
                .font(TextStyles.subHeadlineRegular)
                .foregroundColor(Color(UIColor.secondaryLabel))
                .padding(.leading, SizeStylesPro().paddingXxs.byScaleWidth())
            Picker("Options", selection: $coloState.colorOption) {
                ForEach(0 ..< options.count) { index in
                    Text(options[index]).tag(index)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.top, SizeStylesPro().spacingXs.byScaleWidth())
            .onChange(of: coloState.colorOption) { tag in
                print("tag color  \(tag)")
                __UserDefault.setValue(tag, forKey: mainColorSet)
                __UserDefault.synchronize()
            }
        }
        .padding(SizeStylesPro().spacingM.byScaleWidth())
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(SizeStylesPro().spacingM.byScaleWidth())
    }

    var body: some View {
        NavigationView {
            ScrollViewReader { scrollViewProxy in
                ScrollView(.vertical, showsIndicators: false, content: {
                    VStack(alignment: .leading, spacing: SizeStylesPro().spacingM.byScaleWidth(), content: {
                        lightV
                        lightV
                        lightV
                        lightV
                        lightV

                        Button(action: {
                            isPopoverVisible.toggle()
                        }, label: {
                            VStack(alignment: .leading) {
                                HStack {
                                    Image("set_schedule")
                                    Text("Schedule")
                                        .font(TextStyles.bodySemibold)
                                        .foregroundColor(Color(UIColor.label))
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(Color(UIColor.label))
                                }
                                Text("Set your schedule to know you better")
                                    .font(TextStyles.subHeadlineRegular)
                                    .foregroundColor(Color(UIColor.secondaryLabel))
                                    .padding(.leading, CGFloat(SizeStylesPro().paddingXxs.byScaleWidth()))
                            }
                            .padding(SizeStylesPro().spacingM.byScaleWidth())
                            .background(Color(UIColor.secondarySystemGroupedBackground))
                            .cornerRadius(SizeStylesPro().spacingM.byScaleWidth())
                        })
                        .popover(isPresented: $isPopoverVisible) {
                            TimelinesView()
                        }

                        GeometryReader { geometry in
                            VStack {
                                Text("SwiftUI View Position").padding()

                                // 用GeometryReader获取视图的位置
                                Rectangle()
                                    .fill(Color.blue)
                                    .frame(width: 100, height: 100)
                                    .background(GeometryReader { proxy in
                                        Color.clear.onAppear {
                                            self.viewFrame = proxy.frame(in: .global)
                                            // 打印视图相对于屏幕的位置
                                            print("View frame in screen coordinates: \(self.viewFrame)")
                                        }
                                    })
                                    .border(Color.red) // 用红色边框标记视图边界
                            }
                        }
                        Rectangle().fill(Color.pink.opacity(0.3)).frame(height: 1)
                            .onAppear(perform: {
                                print("wollla")
                            })
                            .onDisappear(perform: {
                                print("wozbla")
                            })

                    })
                    .padding(SizeStylesPro().spacingM.byScaleWidth())
                })
            }
            .background(Color(UIColor.systemGroupedBackground))
            .preferredColorScheme(coloState.colorOption == 0 ? .none : (coloState.colorOption == 1 ? .light : .dark))
            .navigationTitle("Setting")
            .environmentObject(coloState)
            .onAppear(perform: {
                coloState.timeType = 0
                if let t = __UserDefault.value(forKey: mainColorSet) as? Int {
                    coloState.colorOption = t
                } else {
                    __UserDefault.setValue(0, forKey: mainColorSet)
                }
            })
        }
    }
}


