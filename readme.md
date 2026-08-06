# ECG Signal Analysis and Arrhythmia Classification using MATLAB

A Digital Signal Processing (DSP) project that analyzes Electrocardiogram (ECG) signals from the MIT-BIH Arrhythmia Database. The project performs signal preprocessing, feature extraction, and machine learning-based classification of heartbeats.

---

## Project Overview

Electrocardiogram (ECG) signals are widely used for diagnosing cardiovascular diseases. This project implements a complete ECG processing pipeline in MATLAB, including:

- ECG signal preprocessing
- Noise removal using digital filters
- Frequency-domain analysis using FFT
- Wavelet-based denoising
- R-peak detection
- Feature extraction
- Dataset preparation
- Machine learning-based heartbeat classification

---

## Features

- Butterworth Bandpass Filtering
- Fast Fourier Transform (FFT) Analysis
- Wavelet Denoising
- R-Peak Detection
- Beat Segmentation
- Statistical Feature Extraction
- Dataset Normalization
- Machine Learning Classification
- MATLAB + Python Integration

---

## Project Structure

```
ecg-signal-analysis-matlab/
│
├── matlab/             # MATLAB source code
├── python/             # Python scripts for preprocessing
├── data/               # Sample data (optional)
├── images/             # Figures and output plots
├── output/             # Generated results
├── README.md
├── LICENSE
└── .gitignore
```

---

## Signal Processing Pipeline

```
Raw ECG Signal
      │
      ▼
Bandpass Filtering
      │
      ▼
FFT Analysis
      │
      ▼
Wavelet Denoising
      │
      ▼
R-Peak Detection
      │
      ▼
Beat Segmentation
      │
      ▼
Feature Extraction
      │
      ▼
Normalization
      │
      ▼
Machine Learning Classification
```

---

## Dataset

This project uses the **MIT-BIH Arrhythmia Database**.

Download the dataset from:

https://physionet.org/content/mitdb/1.0.0/

Due to licensing and repository size limitations, the dataset is **not included** in this repository.

---

## Technologies Used

- MATLAB
- Signal Processing Toolbox
- Wavelet Toolbox
- Statistics and Machine Learning Toolbox
- Python (for data preprocessing)

---

## Results

The project includes:

- Filtered ECG Signals
- FFT Spectrum
- Wavelet Denoised Signal
- Detected R-Peaks
- Extracted Features
- Classification Results

Example outputs can be found in the `images/` folder.

---

## Getting Started

### Clone the repository

```bash
git clone https://github.com/yourusername/ecg-signal-analysis-matlab.git
```

### Open MATLAB

Navigate to the `matlab` folder and run:

```matlab
main.m
```

---

## Future Improvements

- Deep Learning (CNN/LSTM) Classification
- Real-Time ECG Monitoring
- Graphical User Interface (GUI)
- Support for Additional ECG Datasets
- Deployment as a MATLAB App

---

## Repository Status

🚧 Work in Progress

This repository is actively being developed. New features and improvements will be added over time.

---

## Acknowledgements

- PhysioNet
- MIT-BIH Arrhythmia Database
- MATLAB Documentation

---

## License

This project is licensed under the MIT License.

---

## Author

**Ronit Vishwakarma and Pushkar Kaura**

Electronics and Communication Engineering  
VIT Chennai