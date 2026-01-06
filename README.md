# 🚀 Lingo Master - Premium Language Learning 

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white" alt="Dart">
  <img src="https://img.shields.io/badge/SQLite-%2307405e.svg?style=for-the-badge&logo=sqlite&logoColor=white" alt="SQLite">
  <img src="https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge" alt="License">
</p>


## 🌟 Introduction

Elevate your language learning journey with **Lingo Master**, a premium Flutter-based application where cutting-edge design meets high-performance engineering. In a world of repetitive learning tools, Lingo Master stands out by merging a sophisticated **Glassmorphic UI** with a robust, **locally-persistent backend**.

This application is meticulously crafted to transform the routine of vocabulary building into an immersive, visually stunning experience. By utilizing a "Local-First" approach with SQLite, learners enjoy lightning-fast access to their data even without an internet connection. Whether you are a beginner at the **A1 level** or an expert striving for **C2 mastery**, Lingo Master's interface intelligence dynamically adapts to your proficiency, providing a personalized aesthetic and functional environment for every stage of your linguistic evolution.

---

## ✨ Key Features

* **🎨 Advanced Glassmorphism:** Sleek, frosted-glass UI elements with real-time blur effects for a modern look.
* **🎭 Context-Aware Adaptive Theming:** The app's color palette and interface dynamically adapt based on the selected CEFR level (A1 - C2).
* **🔊 High-Fidelity TTS:** Integrated Text-to-Speech engine for natural-sounding word pronunciations to master phonetics.
* **⚡ Fluid Animations:** Staggered entry animations and smooth transitions that define a premium user flow.
* **🔍 Real-time Smart Search:** Instantly filter through hundreds of words, categories, and translations with zero latency.
* **💾 Local-First Persistence:** A fully offline experience powered by a robust and optimized SQLite implementation.



---

## 🛠️ Tech Stack

- **Frontend:** Flutter SDK (Stable Channel)
- **Database:** `sqflite` (Relational Local Storage for complex word data)
- **Audio:** `flutter_tts` (Speech Synthesis)
- **Architecture:** Clean UI/Logic separation with optimized `setState` management.

---

## 📂 Project Structure

Based on the actual internal architecture:

```text
lib/
├── screens/               # Core Application Screens
│   ├── widgets/           # Screen-specific components (e.g., category_card.dart)
│   ├── add_word_screen.dart
│   ├── home_screen.dart
│   ├── level_selection_screen.dart
│   ├── quiz_level_screen.dart
│   ├── quiz_play_screen.dart
│   ├── quiz_screen.dart
│   └── vocabulary_screen.dart
├── services/              # Business Logic & Infrastructure
│   └── database_helper.dart
├── app_colors.dart        # Centralized Design System & CEFR Themes
└── main.dart              # Application Entry Point

assets/
├── fonts/                 # Custom Typography
├── Logo.png               # Brand Identity
└── *.png                  # UI Showcase Assets (0-7, main)
