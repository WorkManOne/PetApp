import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var userService: UserService
    @State private var selectedIndex = 0

    var body: some View {
        VStack {
            Button {
                userService.isFirstLaunch = false
            } label: {
                Text("Skip")
                    .foregroundStyle(.white)
                    .font(.system(size: 12, weight: .semibold))
                    .padding(.horizontal, 30)
                    .padding(5)
                    .background(.blueMain)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.horizontal, 20)
            }
            TabView (selection: $selectedIndex) {
                TipView(image: Image("onboardingControl"), title: "Pet Control", description: "Manage your pets' procedures and health in one place. Keep track of reminders and don't miss important tasks.")
                .tag(0)
                TipView(image: Image("onboardingList"), title: "Care List", description: "Reminders about procedures and convenient records for each pet. Add new events and monitor their completion on time.")
                .tag(1)
                TipView(image: Image("onboardingPlan"), title: "Pet Planner", description: "Plan your care routine, add pets, and mark completed tasks. Organize all procedures simply and conveniently every day.")
                .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            VStack {
                Button {
                    if selectedIndex == 2 {
                        userService.isFirstLaunch = false
                    } else {
                        withAnimation {
                            selectedIndex = selectedIndex + 1
                        }

                    }
                } label: {
                    Text(selectedIndex == 2 ? "Start" : "Next")
                        .foregroundStyle(.white)
                        .font(.system(size: 24, weight: .semibold))
                        .padding(.horizontal, 50)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .background(.blueMain)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.horizontal, 20)
                }
                .padding(.bottom, 20)
            }
        }
        .background(Color.whiteMain.ignoresSafeArea())
    }
}

struct TipView: View {
    let image: Image
    let title: String
    let description: String

    var body: some View {
        VStack (spacing: 30) {
            image
                .resizable()
                .scaledToFit()
                .frame(height: 300)
            Text(title)
                .foregroundStyle(.blueMain)
                .font(.system(size: 41, weight: .semibold))
                .multilineTextAlignment(.center)
            Text(description)
                .foregroundStyle(.textDark)
                .font(.system(size: 22, weight: .semibold))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    OnboardingView()
        .background(.black)
        .environmentObject(UserService())
}
