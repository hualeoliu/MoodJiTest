//
//  TimelinesView.swift
//  Flowzland
//
//  Created by flowz-leo on 2024/1/23.
//


import SwiftUI

struct TimelinesView: View {
    
    @Environment(\.presentationMode) var navigator

    @State private var isPage = false
    @StateObject var mEnvBean = TimelineEnvBean()

    func loadStart() {
//        UserDefaults.standard.removeObject(forKey: timeLinesUDName)
        mEnvBean.loadStart()
    }

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: sizeStyles.spacingS) {
                    if !mEnvBean.findBalnkWeekidx().isEmpty {
                        HStack(alignment: .center, spacing: sizeStyles.spacingXs) {
                            Image(systemName: "exclamationmark.circle.fill")
                            Text("Please Set Routines For \(mEnvBean.getBlankString(mEnvBean.findBalnkWeekidx()))")
                            Spacer(minLength: 0)
                        }
                        .padding(.leading, sizeStyles.paddingXs)
                        .font(TextStyles.subHeadlineSemibold)
                        .foregroundColor(accentWarning)
                    }

                    ForEach($mEnvBean.times) { $element in
                        TimelinesCell(mBean: $element)
                    }
                    
                    if mEnvBean.times.filter(\.isReal).count <= 3 {
                        addBtn
                    }

                    Spacer()
                }
                .padding(.top, sizeStyles.spacingXs)
                .animation(.spring)
            }
            .navigationBarTitle("Routines", displayMode: .inline)
            .padding(.top, sizeStyles.spacingXs)
            .padding(.bottom, sizeStyles.paddingL)
            .padding(.horizontal, sizeStyles.paddingM)
            .edgesIgnoringSafeArea(.bottom)
            .background(Color(UIColor.systemGroupedBackground))
        }
        .environmentObject(mEnvBean)
        .interactiveDismissDisabled(!mEnvBean.findBalnkWeekidx().isEmpty)
        .onAppear {
            loadStart()
        }
    }

    private var addBtn: some View {
        HStack(alignment: .center, spacing: sizeStyles.spacingXxs) {
            Image(systemName: "plus")
                .font(TextStyles.subHeadlineSemibold)
                .foregroundColor(accentScreenTime)
            Text("Add Routine")
                .font(TextStyles.subHeadlineSemibold)
                .multilineTextAlignment(.center)
                .foregroundColor(accentScreenTime)
        }
        .padding(.horizontal, sizeStyles.paddingM)
        .padding(.vertical, sizeStyles.paddingL)
        .frame(maxWidth: .infinity)
        .sheet(isPresented: $isPage) {
            TimelineEditView(isAdd: true, mBean: $mEnvBean.times.last!)
        }
        .containerShape(Rectangle())
        .onTapGesture {
            rigidDo()

            let bean = TimelineBean()
            mEnvBean.times.append(bean)
            isPage.toggle()
        }
    }
}
