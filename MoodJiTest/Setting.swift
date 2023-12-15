//
//  Seting.swift
//  MoodJiTest
//
//  Created by ZZ on 2023/12/12.
//

import SwiftUI

struct Setting: View {
    @Environment(\.colorScheme) var curMode
    @EnvironmentObject var coloState : MainColorModel
    
    let options = ["Auto", "Light", "Dark"]
    @State private var isPopoverVisible = false
    
    var body: some View {
        
        NavigationView {
            ScrollView(.vertical, showsIndicators: false, content: {
                VStack(alignment: .leading, spacing: SizeStylesPro().spacing16, content: {
                    VStack(alignment:.leading) {
                        HStack {
                            Image("set_appearance")
                            Text("Appearance")
                                .font(TextStyles.bodySemibold)
                                .foregroundColor(Color(UIColor.label))
                        }
                        Text("Set to Auto will follow system appearance")
                            .font(TextStyles.subHeadlineRegular)
                            .foregroundColor(Color(UIColor.secondaryLabel))
                            .padding(.leading, SizeStylesPro().padding4)
                        Picker("Options", selection: $coloState.colorOption) {
                            ForEach(0..<options.count) { index in
                                Text(options[index]).tag(index)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.top, SizeStylesPro().padding8)
                        .onChange(of: coloState.colorOption) { tag in
                            print("tag color  \(tag)")
                            __UserDefault.setValue(tag, forKey: mainColorSet)
                            __UserDefault.synchronize()
                        }
                    }
                    .padding(SizeStylesPro().spacing16)
                    .background(Color(UIColor.secondarySystemGroupedBackground))
                    .cornerRadius(SizeStylesPro().spacing16)
                    
                    Button(action: {
                        isPopoverVisible.toggle()
                    }, label: {
                        VStack(alignment:.leading) {
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
                                .padding(.leading, CGFloat(SizeStylesPro().padding4))
                        }
                        .padding(SizeStylesPro().spacing16)
                        .background(Color(UIColor.secondarySystemGroupedBackground))
                        .cornerRadius(SizeStylesPro().spacing16)
                    })
                    .popover(isPresented: $isPopoverVisible) {
                        ScheduleList()
//                            .environmentObject(self.coloState)
                    }
                    
                })
                .padding(SizeStylesPro().spacing16)
            })
            .background(Color(UIColor.systemGroupedBackground))
            .preferredColorScheme(coloState.colorOption == 0 ? .none : (coloState.colorOption == 1 ? .light : .dark))
            .navigationTitle("Setting")
            .environmentObject(coloState)
            .onAppear(perform: {
                if let t = __UserDefault.value(forKey: mainColorSet) as? Int {
                    print("color 设置 \(t)")
                    coloState.colorOption = t
                }else{
                    print("color 未设置")
                    __UserDefault.setValue(0, forKey: mainColorSet)
                }
            })
        }
    }
}

