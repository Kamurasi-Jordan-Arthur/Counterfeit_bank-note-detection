# Bank Note Checker

## Overview
The Bank Note Checker is a mobile application designed to detect counterfeit banknotes using AI and deep learning. The app leverages a pre-trained ResNet152V2 model to classify banknotes as genuine or counterfeit. The application is optimized for both Android and iOS platforms, providing a user-friendly interface for seamless operation.

## Features
- **Image Capture/Upload:** Users can capture banknote images using their device camera or upload images from the gallery.
- **Counterfeit Detection:** The app processes the image and classifies the banknote as genuine or counterfeit with a confidence level.
- **User-Friendly Interface:** Intuitive and accessible design for ease of use.
- **Platform Compatibility:** Supports both Android and iOS devices.

## Installation

1. **Clone the Repository**
   ```bash
   git clone git@github.com:Kamurasi-Jordan-Arthur/Counterfeit_bank-note-detection.git
   cd note_detection
   ```

2. **Set Up the Environment**
   - Ensure you have Flutter and Dart installed. Follow the official [Flutter installation guide](https://flutter.dev/docs/get-started/install) if you don't have it set up.

3. **Run the Application**
   - For Android:
     ```bash
     flutter run
     ```
   - For iOS:
     ```bash
     flutter run
     ```
## Model Integration
The ResNet152V2 model has been converted to TensorFlow Lite (TFLite) for mobile optimization. Note that the model file is not included in this repository due to its large size. You can download the TFLite model from [this link](#) and place it in the appropriate directory.

## System Architecture
The application follows a layered architecture:
- **Frontend:** Built using Flutter, it handles user interactions and displays results.
- **Logic Layer:** Contains the business logic for processing the images and interfacing with the model.
- **Data Layer:** Manages data storage, retrieval, and preprocessing required for model inference.
