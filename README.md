# Delusions: Anti-Affirmations

> "Affirmations for people who hate affirmations."

A cynical take on self-improvement — swipe through sarcastic affirmations delivered by personas like "Overthinker", "ADHD Brain", and "Burned Out".

## Screenshots

| Home | Profile | Settings |
|------|---------|----------|
| *(Add screenshots)* | *(Add screenshots)* | *(Add screenshots)* |

## Features

- **Swipeable Affirmation Cards** — Swipe right to save, swipe left to skip
- **Multiple Personas** — Overthinker, ADHD Brain, Burned Out, Anxiety, etc.
- **Custom Themes** — Brutalist, Pastel, Vaporwave, Cyberpunk color palettes
- **Premium/Subscription** — Unlimited swipes, custom affirmations, history
- **Home Screen Widgets** — iOS and Android support
- **Daily Notifications** — Sarcastic "reality checks"
- **Share as Image** — Watermarked cards for social sharing
- **Accessibility** — VoiceOver/TalkBack support throughout
- **Streak Tracking** — "System uptime" counter

## Tech Stack

| Category | Technology |
|----------|------------|
| **Framework** | Flutter 3.10+ |
| **State Management** | Riverpod |
| **Local Database** | Isar (NoSQL) |
| **Payments** | RevenueCat |
| **Animations** | flutter_animate |
| **Gestures** | flutter_card_swiper |
| **Notifications** | flutter_local_notifications |
| **Fonts** | google_fonts |

## Getting Started

### Prerequisites

- Flutter SDK 3.10.7 or higher
- Dart 3.0 or higher
- iOS: Xcode 15+ (for iOS development)
- Android: Android Studio (for Android development)

### Installation

```bash
# Clone the repo
git clone <repo-url>
cd affirmations_app

# Install dependencies
flutter pub get

# Setup environment variables (see USAGE.md)
cp .env.example .env
# Edit .env with your keys

# Run the app
./run.sh
```

### Environment Setup

See [USAGE.md](USAGE.md) for complete environment setup guide including:
- API keys (RevenueCat, Firebase)
- Development vs production configs
- CI/CD setup
- Troubleshooting

## Project Structure

```
lib/
├── models/           # Data models (Affirmation, UserPreferences)
├── screens/          # UI screens (Home, Profile, Settings, etc.)
├── services/         # Business logic (AffirmationsService, NotificationService)
├── widgets/          # Reusable components (SwipeCard)
├── theme.dart        # Color palettes and theming
├── main.dart         # App entry point
└── locator.dart      # Dependency injection (get_it)
```

## Roadmap

See [ROADMAP.md](ROADMAP.md) for strategic phases.

### Current Priorities

- [ ] Firebase Analytics + Crashlytics
- [ ] Rate/review prompts
- [ ] Share deep links
- [ ] Referral/invite system

## Success Assessment

### The Numbers Game

| Metric | Reality |
|--------|---------|
| Mental wellness apps | 10,000+ on App Store, saturated |
| Successful indie apps | ~1% ever cross 10K users |
| Your differentiator | Unique voice, but niche appeal |

### Strengths ✅

1. **Strong brand identity** — Memorable, stands out in a sea of toxic positivity
2. **Polarizing content** — People who love it will *share* it (virality potential)
3. **Solid foundation** — Flutter, RevenueCat, widgets, notifications working
4. **Satirical edge** — Resonates with younger demographics

### Weaknesses ❌

| Issue | Impact |
|-------|--------|
| No analytics | Flying blind on retention, conversion |
| No account system | Users lose data = churn |
| No crash reporting | Bad reviews go unnoticed |
| Aggressive paywall (5 swipes) | Low conversion if value isn't clear |
| No marketing strategy | "Build it and they will come" = 0 users |

### Probability

```
Mainstream success     <5%  (competing with venture-backed apps)
Niche success        20-40% (100K users possible with marketing)
```

### What Actually Moves the Needle

```
Building features        ~5% of success
Marketing/distribution  ~60% of success
Timing/luck             ~35% of success
```

The app is **built well enough**. The question is: can you get people to see it?

### Quick Win to Boost Odds

Post 1-2 reels/day of your funniest anti-affirmations with a watermark:
- "Delusions app — link in bio"
- Use trending audio
- Cross-post to Reddit (r/ADHD, r/anxiety, r/2meirl4meirl would eat this up)

If you get 100K views per reel consistently, you have a shot.

## License

[Add your license here]

## Contributing

[Add contribution guidelines]
