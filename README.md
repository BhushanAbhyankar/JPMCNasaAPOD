# JPMCNasaAPOD
Astronomy Picture of the Day App


This is an iOS app that displays NASA's current day's APOD (Astronomy Picture of the Day). The app is written in Swift and uses Offline Caching for persistence and following MVVM architecture with the Repository pattern.

## Project Description 

Explore the wonders of the universe every day with the NASA APOD App! This app brings you the latest astronomy image or video from NASA’s Astronomy Picture of the Day (APOD) program, along with a detailed explanation of the day's content. Here’s what you can do with the app:

Key Features:
Daily Astronomy Updates: Automatically loads the current day’s APOD, including the date, title, image or video, and an insightful explanation. Some days feature embedded videos, and the app seamlessly handles these cases.

Browse By Date: Want to explore past discoveries? Select any date to view the APOD for that day and dive into NASA’s archived images and videos.

Offline Access: The last loaded APOD is cached, allowing you to revisit it even when offline. If a network request fails, the app will automatically display the cached content, ensuring uninterrupted access to your favorite APODs.

Optimized for iPhone and iPad: Enjoy a responsive design that works seamlessly across different screen sizes and orientations, providing a beautiful and consistent experience on both iPhones and iPads.

Dark Mode Support: The app supports Dark Mode, adapting its appearance to match your device’s settings for a comfortable viewing experience at any time of the day or night.

Dynamic Type Accessibility: Designed with accessibility in mind, the app supports Dynamic Type, allowing users to adjust text size based on their preferences. This ensures that the content is accessible to all users, including those who prefer larger or smaller text sizes.

With the NASA APOD App, space exploration is just a tap away. Discover the beauty and mystery of our universe daily, right from your device!

 All details are fetched from API (https://api.nasa.gov)

## Table of Contents

In the structure files contains: Model, View, ViewModel, Network, Repository and tests part. Tests contains ViewModelTests, RepositoryTests with Test JSON file and its data.


# Installation
Can be used with Xcode 16 and above. Compatible with iPhone and iPad with minimum iOS version 16.0.

# Framework
SwiftUI, AVKit 

# Architecture
This application uses MVVM + Repository pattern (Clean architecture).

# Offline Storage
File storage and NSCache is used.

# Design Patterns
Async await.

# Testing
Units tests for success and failure situations. Mocked responses using FakeNetworkManager, MockCacheManager, MockPicOfDayRepository

# Screenshots


- List of JPMCNasaAPOD Screens

Home Screen 
-
![Simulator Screenshot - iPhone 16 Pro Max - 2024-11-13 at 02 12 41](https://github.com/user-attachments/assets/1e793b1b-dca0-44f9-9530-90162b538e4a)

Date Selection Screen
-
![Simulator Screenshot - iPhone 16 Pro Max - 2024-11-13 at 02 12 47](https://github.com/user-attachments/assets/ded28382-8c8c-45a0-ad47-103f536ef647)
