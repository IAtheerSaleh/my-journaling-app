//
//  splase view.swift
//  my journaling app
//
//  Created by ATHEER SALEH ALZHRANI on 28/05/1448 AH.
//

import SwiftUI

struct SplashScreen: View {

    @State private var showHome = false

    var body: some View {

        ZStack {

            // Background
            Color(red: 0.03, green: 0.03, blue: 0.04)
                .ignoresSafeArea()

            if showHome {

                ContentView()

            } else {

                VStack(spacing: 15) {

                    // App Logo
                    Image("LogoApp")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 110, height: 110)

                    // App Name
                    Text("Journali")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)

                    // Subtitle
                    Text("Your thoughts, your story")
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(.white.opacity(0.75))
                }
            }
        }
        .onAppear {

            DispatchQueue.main.asyncAfter(
                deadline: .now() + 2
            ) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    showHome = true
                }
            }
        }
    }
}
#Preview {
   SplashScreen()
}
