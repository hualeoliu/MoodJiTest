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

    private func saveDo() {
        mEnvBean.isEditing = false
        mEnvBean.toJsonAndUDSave()
        navigator.wrappedValue.dismiss()
    }

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
                    
                    addBtn

                    Spacer()
                }
                .padding(.top, sizeStyles.spacingXs)
                .animation(.spring)
            }
            .navigationBarTitle("Routines", displayMode: .inline)
            .navigationBarItems(leading: leftBtn, trailing: rightBtn)
            .padding(.top, sizeStyles.spacingXs)
            .padding(.bottom, sizeStyles.paddingL)
            .padding(.horizontal, sizeStyles.paddingM)
            .edgesIgnoringSafeArea(.bottom)
            .background(Color(UIColor.systemGroupedBackground))
        }
        .environmentObject(mEnvBean)
        .interactiveDismissDisabled(isEditing)
        .onAppear {
            loadStart()
        }
    }

    private var isEditing: Bool {
        mEnvBean.isChangedWeekidx() || !mEnvBean.findBalnkWeekidx().isEmpty || mEnvBean.isEditing
    }

    private var leftBtn: some View {
        Button(action: {
            rigidDo()
            navigator.wrappedValue.dismiss()
        }) {
            Text("Cancel")
                .font(.system(size: 17).weight(.regular))
                .foregroundColor(accentScreenTime)
        }
        .opacity(isEditing ? 1 : 0)
    }

    private var rightBtn: some View {
        Button(action: {
            rigidDo()
            saveDo()
        }) {
            Text("Save")
                .font(.system(size: 17).weight(.semibold))
                .foregroundColor(mEnvBean.findBalnkWeekidx().isEmpty ? accentScreenTime : Color(UIColor.systemFill))
        }
        .opacity(isEditing ? 1 : 0)
        .allowsHitTesting(mEnvBean.findBalnkWeekidx().isEmpty)
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
