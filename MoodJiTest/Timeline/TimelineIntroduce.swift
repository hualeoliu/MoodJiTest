//
//  TimelineIntroduce.swift
//  Flowzland
//
//  Created by flowz-leo on 2024/1/26.
//

import SwiftUI

struct TimelineIntroduce: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var navigator
    @Binding<[IntroViewType]> var path: [IntroViewType]

    var doneBlock: (() -> Void)?

    @State private var isPage = false
    @StateObject var mEnvBean = TimelineEnvBean()

    var content: some View {
        VStack(alignment: .leading, spacing: sizeStyles.spacingS) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .center, spacing: sizeStyles.spacingL) {
                    Text("My Routine 1")
                        .font(TextStyles.headline)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color((UIColor.label)))
                }
                .padding(.vertical, sizeStyles.paddingXs)
                VStack(alignment: .center, spacing: 0) {
                    Capsule().fill(Color(UIColor.systemFill)).frame(width: 2)
                }
                .frame(width: 36, height: 16)
                HStack(alignment: .center, spacing: 20) {
                    HStack(alignment: .center, spacing: sizeStyles.spacingS) {
                        HStack(alignment: .center, spacing: 4) {
                            Image(systemName: "sun.max.fill")
                                .font(TextStyles.subHeadlineSemibold)
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color.white)
                        }
                        .frame(width: 36, height: 36)
                        .background(statusSleepRem)
                        .cornerRadius(sizeStyles.cornerRadiusXxl)
                        Text("Wake Up")
                            .font(TextStyles.headline)
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(uiColor: .label))
                    }
                    Spacer(minLength: 0)
                    HStack(alignment: .bottom, spacing: 0) {
                        Text("07:00 ")
                            .font(TextStyles.headline)
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.init(uiColor: .secondaryLabel))
                    }
                    .padding(.vertical, sizeStyles.paddingS)
                    .cornerRadius(sizeStyles.cornerRadiusXxl)
                }
                VStack(alignment: .center, spacing: 0) {
                    Capsule().fill(Color(UIColor.systemFill)).frame(width: 2)
                }
                .frame(width: 36, height: 16)
                HStack(alignment: .center, spacing: 20) {
                    HStack(alignment: .center, spacing: sizeStyles.spacingS) {
                        HStack(alignment: .center, spacing: 4) {
                            Image(systemName: "laptopcomputer")
                                .font(TextStyles.subHeadlineSemibold)
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color.white)
                        }
                        .frame(width: 36, height: 36)
                        .background(Color.indigo)
                        .cornerRadius(sizeStyles.cornerRadiusXxl)
                        Text("Work")
                            .font(TextStyles.headline)
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(UIColor.label))
                    }
                    Spacer(minLength: 0)
                    HStack(alignment: .bottom, spacing: 0) {
                        Text("09:00 ")
                            .font(TextStyles.headline)
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(UIColor.secondaryLabel))
                    }
                    .padding(.vertical, sizeStyles.paddingS)
                    .cornerRadius(sizeStyles.cornerRadiusXxl)
                }
                VStack(alignment: .center, spacing: 0) {
                    Capsule().fill(Color(UIColor.systemFill)).frame(width: 2)
                }
                .frame(width: 36, height: 16)
                HStack(alignment: .center, spacing: 20) {
                    HStack(alignment: .center, spacing: sizeStyles.spacingS) {
                        HStack(alignment: .center, spacing: 4) {
                            Image(systemName: "zzz")
                                .font(TextStyles.subHeadlineSemibold)
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color.white)
                        }
                        .frame(width: 36, height: 36)
                        .background(Color.green)
                        .cornerRadius(sizeStyles.cornerRadiusXxl)
                        Text("Nap")
                            .font(TextStyles.headline)
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(UIColor.label))
                    }
                    Spacer(minLength: 0)
                    HStack(alignment: .bottom, spacing: 0) {
                        Text("13:00 - 14:00 ")
                            .font(TextStyles.headline)
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(UIColor.secondaryLabel))
                    }
                    .padding(.vertical, sizeStyles.paddingS)
                    .cornerRadius(sizeStyles.cornerRadiusXxl)
                }
                VStack(alignment: .center, spacing: 0) {
                    Capsule().fill(Color(UIColor.systemFill)).frame(width: 2)
                }
                .frame(width: 36, height: 16)
                HStack(alignment: .center, spacing: 20) {
                    HStack(alignment: .center, spacing: sizeStyles.spacingS) {
                        HStack(alignment: .center, spacing: 4) {
                            Image(systemName: "house.fill")
                                .font(TextStyles.subHeadlineSemibold)
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color.white)
                        }
                        .frame(width: 36, height: 36)
                        .background(Color.purple)
                        .cornerRadius(sizeStyles.cornerRadiusXxl)
                        Text("Off Work")
                            .font(TextStyles.headline)
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(UIColor.label))
                    }
                    Spacer(minLength: 0)
                    HStack(alignment: .bottom, spacing: 0) {
                        Text("18:00 ")
                            .font(TextStyles.headline)
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(UIColor.secondaryLabel))
                    }
                    .padding(.vertical, sizeStyles.paddingS)
                    .cornerRadius(sizeStyles.cornerRadiusXxl)
                }
                VStack(alignment: .center, spacing: 0) {
                    Capsule().fill(Color(UIColor.systemFill)).frame(width: 2)
                }
                .frame(width: 36, height: 16)
                HStack(alignment: .center, spacing: 20) {
                    HStack(alignment: .center, spacing: sizeStyles.spacingS) {
                        HStack(alignment: .center, spacing: 4) {
                            Image(systemName: "book.fill")
                                .font(TextStyles.subHeadlineSemibold)
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color.white)
                        }
                        .frame(width: 36, height: 36)
                        .background(Color.brown)
                        .cornerRadius(sizeStyles.cornerRadiusXxl)
                        Text("Study")
                            .font(TextStyles.headline)
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(UIColor.label))
                    }
                    Spacer(minLength: 0)
                    HStack(alignment: .bottom, spacing: 0) {
                        Text("21:00 - 22:00")
                            .font(TextStyles.headline)
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(UIColor.secondaryLabel))
                    }
                    .padding(.vertical, sizeStyles.paddingS)
                    .cornerRadius(sizeStyles.cornerRadiusXxl)
                }
                VStack(alignment: .center, spacing: 0) {
                    Capsule().fill(Color(UIColor.systemFill)).frame(width: 2)
                }
                .frame(width: 36, height: 16)
                HStack(alignment: .center, spacing: 20) {
                    HStack(alignment: .center, spacing: sizeStyles.spacingS) {
                        HStack(alignment: .center, spacing: 4) {
                            Image(systemName: "bed.double.fill")
                                .font(TextStyles.subHeadlineSemibold)
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color.white)
                        }
                        .frame(width: 36, height: 36)
                        .background(statusSleepDeep)
                        .cornerRadius(sizeStyles.cornerRadiusXxl)
                        Text("Bedtime")
                            .font(TextStyles.headline)
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(UIColor.label))
                    }
                    Spacer(minLength: 0)
                    HStack(alignment: .bottom, spacing: 0) {
                        Text("23:00")
                            .font(TextStyles.headline)
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(UIColor.secondaryLabel))
                    }
                    .padding(.vertical, sizeStyles.paddingS)
                    .cornerRadius(sizeStyles.cornerRadiusXxl)
                }
            }
            .padding(.leading, sizeStyles.paddingXxs)
            .padding(.trailing, sizeStyles.paddingXs)
        }
        .padding(.top, sizeStyles.paddingS)
        .padding(.bottom, sizeStyles.paddingM)
        .padding(.horizontal, sizeStyles.paddingM)
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(sizeStyles.cornerRadiusL)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: sizeStyles.spacingXl) {
            VStack(alignment: .center, spacing: sizeStyles.spacingS) {
                Text("Routines")
                    .font(TextStyles.title3Bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(UIColor.label))
                    .frame(maxWidth: .infinity, alignment: .top)
                Text("Tell Moodji your routines to know you better. Don't worry, an approximate time is enough")
                    .font(TextStyles.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(UIColor.secondaryLabel))
                    .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)

            ScrollView(showsIndicators: false) {
                if mEnvBean.times.filter(\.isReal).isEmpty {
                    VStack(alignment: .leading, spacing: 0) {
                        Image(colorScheme == .dark ? "time_line_dark" : "time_line")
                            .resizable()
                            .scaledToFit()
//                            .padding(.bottom, sizeStyles.spacingS)
                        
                        Spacer()
    
                        content
                    }
                    .padding(.horizontal, sizeStyles.spacingS)
                } else {
                    VStack(spacing: sizeStyles.spacingS) {
                        ForEach($mEnvBean.times) { $element in
                            TimelinesCell(mBean: $element)
                        }

                        addBtn
                        Spacer()
                    }
                }
            }

            if !mEnvBean.findBalnkWeekidx().isEmpty && !mEnvBean.times.filter(\.isReal).isEmpty {
                HStack(alignment: .center, spacing: sizeStyles.spacingXs) {
                    Image(systemName: "exclamationmark.circle.fill")
                    Text("No Routine Set For \(mEnvBean.getBlankString(mEnvBean.findBalnkWeekidx()))")
                    Spacer()
                }
                .padding(.horizontal, sizeStyles.paddingXs)
                .font(TextStyles.subHeadlineSemibold)
                .foregroundColor(accentWarning)
            }

            VStack(alignment: .center, spacing: 0) {
                Text(mEnvBean.times.filter(\.isReal).isEmpty ? "Set Up Now" : "Next")
                    .font(TextStyles.headline)
                    .foregroundColor(Color.white)
            }
            .padding(.horizontal, sizeStyles.paddingXl)
            .padding(.vertical, sizeStyles.paddingM)
            .frame(maxWidth: .infinity)
            .background(!canNext ? Color(UIColor.systemFill) : accentScreenTime)
            .cornerRadius(sizeStyles.cornerRadiusL)
            .sheet(isPresented: $isPage) {
                TimelineEditView(isAdd: true, mBean: $mEnvBean.times.last!)
            }
            .allowsHitTesting(canNext)
            .containerShape(Rectangle())
            .onTapGesture {
                rigidDo()

                if mEnvBean.times.filter(\.isReal).isEmpty {
                    let bean = TimelineBean()
                    mEnvBean.times.append(bean)

                    isPage.toggle()
                } else {
                    UserDefaults.standard.setValue("", forKey: timeLineIntroDone)
                    path = [.kHome]
                    mEnvBean.toJsonAndUDSave()
                }
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .padding(.horizontal, sizeStyles.paddingM)
        .padding(.vertical, sizeStyles.scenePaddingBottom)
        .background(Color(UIColor.systemGroupedBackground))
        .environmentObject(mEnvBean)
        .onAppear {
//            loadStart()
        }
    }

    var canNext: Bool {
        if mEnvBean.times.filter(\.isReal).isEmpty {
            return true
        }
        return mEnvBean.findBalnkWeekidx().isEmpty
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
            let bean = TimelineBean()
            mEnvBean.times.append(bean)

            isPage.toggle()
        }
    }
}
