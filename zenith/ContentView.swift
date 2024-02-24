//
//  ContentView.swift
//  zenith
//
//  Created by AkkeyLab on 2024/02/24.
//

import SwiftUI
import RealityKit

struct Girl {
    let fileName: String
    let contentName: String
    let authorName: String
    let authorLink: URL
    let licensesName: String
    let licensesLink: URL
}

extension Girl {
    static let serene1 = Girl(
        fileName: "serene_girl_1",
        contentName: "3D Anime Character girl for Blender C1",
        authorName: "CGCOOL",
        authorLink: URL(string: "https://skfb.ly/oyACQ")!,
        licensesName: "Creative Commons",
        licensesLink: URL(string: "http://creativecommons.org/licenses/by/4.0/")!
    )
    static let serene2 = Girl(
        fileName: "serene_girl_2",
        contentName: "Just a girl",
        authorName: "腱鞘炎の人",
        authorLink: URL(string: "https://skfb.ly/6UCJW")!,
        licensesName: "Creative Commons",
        licensesLink: URL(string: "http://creativecommons.org/licenses/by/4.0/")!
    )
    static let animated = Girl(
        fileName: "animated_girl",
        contentName: "Shibahu",
        authorName: "腱鞘炎の人",
        authorLink: URL(string: "https://skfb.ly/ovSrM")!,
        licensesName: "Creative Commons",
        licensesLink: URL(string: "http://creativecommons.org/licenses/by/4.0/")!
    )
}

struct ContentView: View {
    var body: some View {
        TabView {
            SerenePageView()
                .tabItem {
                    Label("Serene", systemImage: "face.smiling")
                }
            AnimatedView(girl: .animated)
                .tabItem {
                    Label("Animated", systemImage: "figure.run.square.stack")
                }
        }
    }
}

struct SerenePageView: View {
    private let girls: [Girl] = [.serene1, .serene2]

    var body: some View {
        TabView {
            ForEach(girls.indices, id: \.self) { index in
                SereneView(girl: girls[index])
            }
        }
        .tabViewStyle(PageTabViewStyle())
    }
}

struct AnimatedView: View {
    @State private var animations: [AnimationResource] = [] {
        didSet {
            if let animation = animations.first {
                modelEntity?.playAnimation(animation.repeat(), startsPaused: false)
            }
        }
    }
    @State private var modelEntity: Entity? {
        didSet {
            if let modelEntity {
                modelEntity.scale = .init(repeating: 0.002)
                modelEntity.position = .init(x: .zero, y: -0.2, z: .zero)
                animations = modelEntity.availableAnimations
            }
        }
    }
    let girl: Girl

    var body: some View {
        VStack {
            RealityView { content in
                modelEntity = try? await ModelEntity(named: girl.fileName)
                if let modelEntity {
                    content.add(modelEntity)
                }
            }
            CreditsView(girl: girl)
            HStack {
                ForEach(animations.indices, id: \.self) { index in
                    Button("play \(index + 1)", systemImage: "play.circle") {
                        modelEntity?.playAnimation(animations[index].repeat(), startsPaused: false)
                    }
                }
            }
        }
        .padding()
    }
}

struct SereneView: View {
    let girl: Girl

    var body: some View {
        VStack {
            Model3D(named: girl.fileName) { model in
                model
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 400, height: 400)
            } placeholder: {
                ProgressView()
            }
            CreditsView(girl: girl)
        }
        .padding()
    }
}

struct CreditsView: View {
    let girl: Girl

    var body: some View {
        Link(destination: girl.authorLink) {
            Text(girl.contentName)
                .font(.caption)
                .foregroundStyle(.pink)
        }
        HStack(spacing: .zero) {
            Text("by \(girl.authorName) is licensed under")
                .font(.caption)
            Link(destination: girl.licensesLink) {
                Text("\(girl.licensesName) Attribution")
                    .font(.caption)
                    .foregroundStyle(.pink)
            }
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
