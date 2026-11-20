# Imposter

A pass-the-phone party game for iPhone. Most players get the same secret word; the imposter gets a different word from the same category — and doesn't know it. Players ask each other questions in person to find the odd one out.

## Features

- Dark charcoal & red card-deck design: tap a card to flip it and see your secret word, tap again to pass it on
- 8 built-in categories (Food, Places, Animals, Jobs, Sports, Household Objects, Transportation, Countries)
- Create your own categories and words, or edit the built-in ones
- Choose the number of imposters and the round timer length
- Countdown timer, random first questioner, reveal screen showing the imposter(s) and both words
- Players, settings and custom categories are saved on the phone

## Project layout

```
project.yml                 XcodeGen spec (the .xcodeproj is generated on CI)
ImposterGame/               Swift sources + asset catalog
.github/workflows/build.yml GitHub Actions: builds an unsigned .ipa
```

## Build the IPA on GitHub (no Mac needed)

1. Create an empty repository on github.com (private is fine), e.g. `ImposterGame`.
2. From this folder, push the code:

   ```bash
   git init -b main
   git add .
   git commit -m "Initial commit"
   git remote add origin https://github.com/<your-username>/ImposterGame.git
   git push -u origin main
   ```

3. On GitHub, open the **Actions** tab. The **Build unsigned IPA** workflow runs on every push to `main` (or click **Run workflow**). It takes ~5–10 minutes.
4. When it finishes, open the run and download the **ImposterGame-ipa** artifact. Unzip it to get `ImposterGame.ipa`.

## Install on your iPhone with Impactor

1. Open Impactor on your PC, connect your iPhone by USB and sign in with your Apple ID.
2. Drag `ImposterGame.ipa` into Impactor and install.
3. On the iPhone:
   - **Settings → Privacy & Security → Developer Mode** → turn on (restart required, first time only).
   - **Settings → General → VPN & Device Management** → trust your Apple ID profile.

With a free Apple ID, sideloaded apps expire after 7 days — just reinstall the same `.ipa` with Impactor.

## Updating the app

Edit the code, commit and push. GitHub builds a new `.ipa`; install it the same way. Your saved players and categories stay as long as the bundle ID (`com.eliemedawar.impostergame`) doesn't change.
