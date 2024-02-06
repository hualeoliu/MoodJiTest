//
//  TimelineEditView.swift
//  Flowzland
//
//  Created by flowz-leo on 2024/1/23.
//


import SwiftUI
import SwiftUIIntrospect

struct TimelineEditView: View {
    @Environment(\.presentationMode) var navigator
    @State private var sv: UIScrollView!

    @State var isAdd = false
    @FocusState private var isFocused: Bool
    @State private var canTap = true {
        willSet(newValue) {
            if !newValue {
                uiAfterDo(0.1) { canTap = true }
            }
        }
    }

    @State private var mColorCells = [TimeCellBean]()
    @State private var mCells = [TimeCellBean]()
    @State private var mName = ""
    @Binding var mBean: TimelineBean
    @EnvironmentObject var mEnvBean: TimelineEnvBean

    private func saveDo() {
        isFocused = false

        if mEnvBean.times.filter(\.isReal).isEmpty {
            mBean.weekIdxs = [0, 1, 2, 3, 4, 5, 6]
        }
        mBean.cells = mCells
        mBean.name = mName
        mBean.isReal = true
        mEnvBean.toJsonAndUDSave()
        navigator.wrappedValue.dismiss()

        mEnvBean.refreshList()
    }

    private func loadStart() {
        isFocused = isAdd
        mCells = mBean.cells
        mName = mBean.name
        sortCells()
    }

    func sortCells() {
        var all = [TimeCellBean]()
        mCells.forEach { cell in
            var bean = TimeCellBean()
            bean.firstStamp = cell.firstStamp
            bean.type = cell.type
            if cell.type == .Sleep || cell.type == .Work {
                var bean = TimeCellBean()
                bean.isFirst = false
                bean.firstStamp = cell.secStamp
                bean.type = cell.type
                all += [bean]
            }
            all += [bean]
        }
        mColorCells = all.sorted(by: { a, b in
            a.firstStamp < b.firstStamp
        })
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: sizeStyles.spacingS) {
                TimeColorView(mCells: $mCells)
                    .padding(.top, sizeStyles.paddingXs)
                    .onTapGesture {
                        isFocused = false
                    }
                    .onChange(of: mCells) { newValue in
                        sortCells()
                    }

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: sizeStyles.spacingS) {
                        VStack(alignment: .leading, spacing: sizeStyles.spacingM) { // 输入框
                            TextField("Please enter Routines Name...", text: $mName)
                                .font(TextStyles.headline)
                                .foregroundColor(Color(UIColor.label))
                                .frame(maxWidth: .infinity)
                                .focused($isFocused)
                                .submitLabel(.done)
                                .introspect(.textField, on: .iOS(.v16, .v17), customize: { textField in
                                    if !isFocused {
                                        textField.placeHolderColor = UIColor(accentWarning)
                                    }
                                })
                                .onChange(of: mName) { newText in
                                    if newText.count > 30 {
                                        mName = String(newText.prefix(30))
                                    }
                                }
                                .onSubmit {
                                    isFocused = false
                                }
                        }
                        .padding(.horizontal, sizeStyles.paddingM)
                        .padding(.vertical, sizeStyles.paddingL)
                        .background(Color(UIColor.secondarySystemGroupedBackground))
                        .cornerRadius(sizeStyles.cornerRadiusL)
                        .overlay {
                            RoundedRectangle(cornerRadius: sizeStyles.cornerRadiusL, style: .continuous)
                                .inset(by: 1)
                                .stroke(accentScreenTime, lineWidth: 2)
                                .opacity(isFocused ? 1 : 0)
                                .animation(.default)
                        }

                        if mCells.count < 4 {
                            HStack(spacing: sizeStyles.spacingXs) { // 类型选择
                                if !mCells.map(\.type).contains(Timeline.Work) {
                                    setAddView(.Work)
                                }
                                if !mCells.map(\.type).contains(Timeline.Study) {
                                    setAddView(.Study)
                                }
                                if !mCells.map(\.type).contains(Timeline.Nap) {
                                    setAddView(.Nap)
                                }
                                Spacer()
                            }
                            .padding(.vertical, sizeStyles.paddingXs)
                            .animation(.bouncy(duration: 0.3), value: mCells)
                            .allowsHitTesting(canTap)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                isFocused = false
                            }
                        }

                        ForEach($mCells.filter { $0.wrappedValue.type == .Sleep }) { $cell in
                            if $cell.isReal.wrappedValue {
                                TimeCell(mBean: $cell, cellDoBlock: { type in
                                    if type == 0 { // close
                                        withAnimation(.bouncy()) {
                                            mCells.removeAll { $cell.id == $0.id }
                                        }
                                    }
                                    if type == 2 {
                                        isFocused = false
                                    }
                                })
                            }
                        }

                        ForEach($mCells.sorted(by: { $0.firstStamp.wrappedValue < $1.firstStamp.wrappedValue })) { $cell in
                            if $cell.isReal.wrappedValue && $cell.type.wrappedValue != .Sleep {
                                TimeCell(mBean: $cell, cellDoBlock: { type in
                                    if type == 0 { // close
                                        withAnimation(.bouncy()) {
                                            mCells.removeAll { $cell.id == $0.id }
                                        }
                                    }
                                    if type == 2 {
                                        isFocused = false
                                    }
                                })
                            }
                        }
                        .animation(.spring(duration: 0.4), value: mCells)

                        if !isAdd && mEnvBean.times.filter(\.isReal).count > 1 {
                            deleteBtn
                        }
                        Spacer()
                    }
                    .padding(.top, sizeStyles.spacingS)
                    .padding(.bottom, sizeStyles.scenePaddingBottom)
                }
                .introspect(.scrollView, on: .iOS(.v16, .v17), customize: { scrollView in
                    uiDo {
                        sv = scrollView
                    }
                })
            }
            .navigationBarTitle(isAdd ? "Add Routine" : "Edit Routine", displayMode: .inline)
            .navigationBarItems(leading: leftBtn, trailing: rightBtn)
            .padding(.top, sizeStyles.paddingS)
            .padding(.horizontal, sizeStyles.paddingM)
            .edgesIgnoringSafeArea(.bottom)
            .background(Color(UIColor.systemGroupedBackground))
        }
        .interactiveDismissDisabled(true)
        .onAppear {
            loadStart()
        }
    }

    private var deleteBtn: some View {
        HStack {
            Text("Delete Routine")
                .font(TextStyles.subHeadlineSemibold)
                .foregroundColor(accentWarning)
                .padding(.all, sizeStyles.paddingM)
                .frame(maxWidth: .infinity)
                .background(Color(UIColor.secondarySystemGroupedBackground))
                .cornerRadius(sizeStyles.cornerRadiusL)
        }
        .padding(.top, sizeStyles.spacingS)
        .containerShape(Rectangle())
        .onTapGesture {
            mEnvBean.times.remove(at: mEnvBean.times.firstIndex(of: mBean)!)
            mEnvBean.toJsonAndUDSave()
            navigator.wrappedValue.dismiss()
            rigidDo()
        }
    }

    private func setAddView(_ kind: Timeline) -> some View {
        HStack(alignment: .center, spacing: sizeStyles.spacingXxs) {
            Text("+")
            Text(kind.name)
        }
        .font(TextStyles.subHeadlineSemibold)
        .foregroundColor(Color.white)
        .padding(.horizontal, sizeStyles.paddingS)
        .padding(.vertical, sizeStyles.paddingXs)
        .background(kind.mainColor())
        .cornerRadius(sizeStyles.cornerRadiusXxl)
        .onTapGesture {
            if canTap {
                canTap = false
            }

            isFocused = false
            rigidDo()
            switch kind {
                case .Sleep:
                    break
                case .Study:
                    let bean = TimeCellBean(type: kind, firstStamp: 20 * everyHourStamp, secStamp: 22 * everyHourStamp, duration: 2 * 60)
                    mCells.insert(bean, at: 1)
                case .Work:
                    let bean = TimeCellBean(type: kind, firstStamp: 9 * everyHourStamp, secStamp: 18 * everyHourStamp, duration: 9 * 60)
                    mCells.insert(bean, at: 1)
                case .Nap:
                    let bean = TimeCellBean(type: kind, firstStamp: 13 * everyHourStamp, secStamp: 14 * everyHourStamp, duration: 1 * 60)
                    mCells.insert(bean, at: 1)
            }
        }
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
    }

    private var rightBtn: some View {
        Button(action: {
            if mName.isEmpty {
                isFocused = true
                sv?.scrollRectToVisible(CGRect(x: 0, y: 0, width: 100, height: 100), animated: true)
                return
            }

            rigidDo()
            saveDo()
        }) {
            Text(isAdd ? "Add" : "Save")
                .font(.system(size: 17).weight(.semibold))
                .foregroundColor(mName.isEmpty ? Color(UIColor.systemFill): accentScreenTime)
        }
    }
}

extension UITextField {
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string: self.placeholder != nil ? self.placeholder! : "", attributes: [NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}
