import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var userService: UserService
    var body: some View {
        VStack (alignment: .leading, spacing: 15) {
            Text("Settings")
                .foregroundStyle(.blueMain)
                .font(.system(size: 41, weight: .semibold))
                .padding(.horizontal, 20)
            ScrollView {
                VStack (alignment: .leading, spacing: 15) {

                    Text("Threshold soon")
                        .foregroundStyle(.textDark)
                        .font(.system(size: 17, weight: .semibold))
                    HStack {
                        TextField("", text: Binding(get: {
                            String(userService.threshold)
                        }, set: { newValue in
                            userService.threshold = Int(newValue) ?? 0
                        })
                        )
                        Menu {
                            ForEach(IntervalType.allCases, id: \.self) { interval in
                                Button {
                                    withAnimation {
                                        userService.thresholdType = interval
                                    }
                                } label: {
                                    Text(interval.rawValue)
                                }
                            }
                        } label: {
                            Text(userService.thresholdType.rawValue)
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                                .background(.grayMain)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                                .foregroundStyle(.textDark)
                        }

                    }
                    .lightFramed()
                    .padding(.bottom, 40)
                    Text("Time format")
                        .foregroundStyle(.textDark)
                        .font(.system(size: 17, weight: .semibold))
                    HStack (spacing: 10) {
                        Button {
                            userService.isFullHours = false
                        } label: {
                            Text("12 hour")
                                .font(.system(size: 16))
                                .foregroundStyle(userService.isFullHours ? .gray : .whiteMain)
                                .padding(10)
                                .padding(.horizontal)
                                .background(userService.isFullHours ? .whiteMain : .blueMain)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(userService.isFullHours ? .blueMain : .whiteMain, lineWidth: 1)
                                }
                        }
                        Button {
                            userService.isFullHours = true
                        } label: {
                            Text("24 hour")
                                .font(.system(size: 16))
                                .foregroundStyle(!userService.isFullHours ? .gray : .whiteMain)
                                .padding(10)
                                .padding(.horizontal)
                                .background(!userService.isFullHours ? .whiteMain : .blueMain)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(!userService.isFullHours ? .blueMain : .whiteMain, lineWidth: 1)
                                }
                        }
                    }
                    Text("Date format")
                        .foregroundStyle(.textDark)
                        .font(.system(size: 17, weight: .semibold))
                    HStack (spacing: 10) {
                        Button {
                            userService.dateFormat = 0
                        } label: {
                            Text("DD.MM.YYYY")
                                .font(.system(size: 12))
                                .foregroundStyle(userService.dateFormat == 0 ? .whiteMain : .gray)
                                .padding(10)
                                .background(userService.dateFormat == 0 ? .blueMain : .whiteMain)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(userService.dateFormat == 0 ? .whiteMain : .blueMain, lineWidth: 1)
                                }
                        }
                        Button {
                            userService.dateFormat = 1
                        } label: {
                            Text("YYYY-MM-DD")
                                .font(.system(size: 12))
                                .foregroundStyle(userService.dateFormat == 1 ? .whiteMain : .gray)
                                .padding(10)
                                .background(userService.dateFormat == 1 ? .blueMain : .whiteMain)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(userService.dateFormat == 1 ? .whiteMain : .blueMain, lineWidth: 1)
                                }
                        }
                        Button {
                            userService.dateFormat = 2
                        } label: {
                            Text("DD MMM YYYY")
                                .font(.system(size: 12))
                                .foregroundStyle(userService.dateFormat == 2 ? .whiteMain : .gray)
                                .padding(10)
                                .background(userService.dateFormat == 2 ? .blueMain : .whiteMain)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(userService.dateFormat == 2 ? .whiteMain : .blueMain, lineWidth: 1)
                                }
                        }
                    }
                    Button {
                        userService.dateFormat = 3
                    } label: {
                        Text("DD/MM/YYYY")
                            .font(.system(size: 12))
                            .foregroundStyle(userService.dateFormat == 3 ? .whiteMain : .gray)
                            .padding(10)
                            .background(userService.dateFormat == 3 ? .blueMain : .whiteMain)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .overlay {
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(userService.dateFormat == 3 ? .whiteMain : .blueMain, lineWidth: 1)
                            }
                    }
                    .padding(.bottom, 40)
                    Button {
                        if let url = URL(string: "example.com") {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        Text("ABOUT")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 20)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(.whiteMain)
                            .blueFramed()
                    }
                    Button {
                        if let url = URL(string: "example.com") {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        Text("PRIVACY POLICY")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 20)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(.whiteMain)
                            .blueFramed()
                    }
                    Button {
                        if let url = URL(string: "example.com") {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        Text("SUPPORT")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 20)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(.whiteMain)
                            .blueFramed()
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)

            }
            .padding(.bottom, getSafeAreaBottom() + 40)
        }
        .background(.grayMain)
        .navigationBarBackButtonHidden(true)
        .navigationTitle("")
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                            to: nil, from: nil, for: nil)
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(UserService())
        .background(.grayMain)
}
