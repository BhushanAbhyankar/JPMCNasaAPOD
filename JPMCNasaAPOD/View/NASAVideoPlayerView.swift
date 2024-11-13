//
//  NASAVideoPlayerView.swift
//  JPMCNasaAPOD
//
//  Created by Bhushan Abhyankar on 12/11/2024.
//

import Foundation
import SwiftUI
import AVKit


struct NASAVideoPlayerView: UIViewControllerRepresentable {
    let videoURL: URL

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let playerViewController = AVPlayerViewController()
        playerViewController.player = AVPlayer(url: videoURL)
        playerViewController.player?.play()
        return playerViewController
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        // No update needed since the player URL is set initially
    }
}

