(() => {
  'use strict';

  // ---------- Built-in categories ----------

  const BUILT_IN_PREFIX = 'builtin.';
  const builtIn = (id, name, words) => ({ id: BUILT_IN_PREFIX + id, name, words });

  const BUILT_INS = [
    builtIn('food', 'Food', [
      'Pizza', 'Burger', 'Sushi', 'Pasta', 'Tacos', 'Shawarma', 'Falafel', 'Hummus',
      'Manakish', 'Tabbouleh', 'Ice Cream', 'Pancakes', 'Croissant', 'Salad', 'Steak',
      'Fried Chicken', 'French Fries', 'Hot Dog', 'Sandwich', 'Soup', 'Chocolate',
      'Cake', 'Donut', 'Popcorn', 'Omelette', 'Waffles',
    ]),
    builtIn('places', 'Places', [
      'Beach', 'Airport', 'Hospital', 'School', 'Library', 'Cinema', 'Restaurant',
      'Supermarket', 'Gym', 'Bank', 'Museum', 'Zoo', 'Park', 'Hotel', 'Mall', 'Stadium',
      'Police Station', 'Train Station', 'Swimming Pool', 'Office', 'Farm', 'Desert',
      'Mountain', 'Nightclub', 'Bakery', 'Pharmacy', 'Prison', 'Space Station',
    ]),
    builtIn('animals', 'Animals', [
      'Dog', 'Cat', 'Lion', 'Tiger', 'Elephant', 'Giraffe', 'Monkey', 'Horse', 'Cow',
      'Sheep', 'Chicken', 'Eagle', 'Penguin', 'Dolphin', 'Shark', 'Whale', 'Snake',
      'Crocodile', 'Frog', 'Bear', 'Rabbit', 'Camel', 'Kangaroo', 'Owl', 'Bee', 'Spider',
    ]),
    builtIn('jobs', 'Jobs', [
      'Doctor', 'Teacher', 'Chef', 'Pilot', 'Police Officer', 'Firefighter', 'Lawyer',
      'Engineer', 'Dentist', 'Nurse', 'Farmer', 'Mechanic', 'Barber', 'Photographer',
      'Singer', 'Actor', 'Waiter', 'Taxi Driver', 'Astronaut', 'Programmer', 'Plumber',
      'Architect', 'Journalist', 'Soldier', 'Banker',
    ]),
    builtIn('sports', 'Sports', [
      'Football', 'Basketball', 'Tennis', 'Swimming', 'Boxing', 'Volleyball', 'Golf',
      'Baseball', 'Skiing', 'Cycling', 'Running', 'Karate', 'Surfing', 'Table Tennis',
      'Badminton', 'Rugby', 'Ice Hockey', 'Wrestling', 'Gymnastics', 'Bowling',
      'Formula 1', 'Horse Riding', 'Fencing', 'Rock Climbing',
    ]),
    builtIn('objects', 'Household', [
      'Chair', 'Table', 'Bed', 'Lamp', 'Mirror', 'Fridge', 'Oven', 'Microwave',
      'Television', 'Sofa', 'Pillow', 'Blanket', 'Toothbrush', 'Towel', 'Umbrella',
      'Clock', 'Key', 'Phone', 'Laptop', 'Remote Control', 'Washing Machine', 'Fan',
      'Vacuum Cleaner', 'Candle', 'Scissors',
    ]),
    builtIn('transport', 'Transport', [
      'Car', 'Bus', 'Train', 'Airplane', 'Helicopter', 'Bicycle', 'Motorcycle', 'Boat',
      'Submarine', 'Taxi', 'Truck', 'Scooter', 'Skateboard', 'Tram', 'Rocket',
      'Cruise Ship', 'Hot Air Balloon', 'Ambulance', 'Tractor', 'Cable Car', 'Jet Ski',
    ]),
    builtIn('countries', 'Countries', [
      'Lebanon', 'France', 'Italy', 'USA', 'Brazil', 'Japan', 'China', 'Egypt', 'Mexico',
      'Spain', 'Germany', 'United Kingdom', 'Canada', 'Australia', 'India', 'Russia',
      'Turkey', 'Greece', 'Argentina', 'South Korea', 'Saudi Arabia', 'UAE',
      'Switzerland', 'Morocco', 'Portugal',
    ]),
  ];

  // ---------- Artwork ----------

  const SPY = (extra = '') => `<svg class="sticker ${extra}" viewBox="0 0 100 100" aria-hidden="true">
    <g fill="#F4F4F6" stroke="#F4F4F6" stroke-width="9" stroke-linejoin="round"><path d="M20 90c0-17 13-27 30-27s30 10 30 27z"/><circle cx="50" cy="44" r="24"/></g>
    <path d="M20 90c0-17 13-27 30-27s30 10 30 27z" fill="#C8343A" stroke="#121214" stroke-width="3" stroke-linejoin="round"/>
    <circle cx="50" cy="44" r="24" fill="#2B2D33" stroke="#121214" stroke-width="3"/>
    <circle cx="50" cy="47" r="16" fill="#474A53" stroke="#121214" stroke-width="3"/>
    <path d="M31 42c6-4 32-4 38 0v7c-6 4-32 4-38 0z" fill="#E5484D" stroke="#121214" stroke-width="3" stroke-linejoin="round"/>
    <ellipse cx="42" cy="45.5" rx="3.6" ry="2.4" fill="#F4F4F6"/>
    <ellipse cx="58" cy="45.5" rx="3.6" ry="2.4" fill="#F4F4F6"/>
    <path d="M44 66v9M56 66v9" stroke="#F4F4F6" stroke-width="3" stroke-linecap="round"/>
  </svg>`;

  const BUBBLE_PATH = 'M16 22a12 12 0 0 1 12-12h44a12 12 0 0 1 12 12v32a12 12 0 0 1-12 12H48L32 82V66h-4a12 12 0 0 1-12-12z';
  const BUBBLE = `<svg class="sticker" viewBox="0 0 100 100" aria-hidden="true">
    <path d="${BUBBLE_PATH}" fill="#F4F4F6" stroke="#F4F4F6" stroke-width="10" stroke-linejoin="round"/>
    <path d="${BUBBLE_PATH}" fill="#5B606B" stroke="#121214" stroke-width="3" stroke-linejoin="round"/>
    <circle cx="50" cy="38" r="17" fill="#ECECEF" stroke="#121214" stroke-width="3"/>
    <path d="M44 33a6 6 0 1 1 9 5.2c-2 1.2-3 2.4-3 4.6" fill="none" stroke="#D7373D" stroke-width="4.5" stroke-linecap="round"/>
    <circle cx="50" cy="48.5" r="2.6" fill="#D7373D"/>
  </svg>`;

  const icon = (d, width = 2.6) =>
    `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="${width}" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">${d}</svg>`;

  const ICONS = {
    back: icon('<path d="M15 5l-7 7 7 7"/>', 2.8),
    chevron: icon('<path d="M9 6l6 6-6 6"/>', 2.8),
    question: icon('<path d="M9 9a3 3 0 1 1 4.2 2.8c-.8.4-1.2 1-1.2 1.9v.6"/><path d="M12 18h.01"/>', 2.6),
    refresh: icon('<path d="M3 12a9 9 0 0 1 15.5-6.2L21 8"/><path d="M21 3v5h-5"/><path d="M21 12a9 9 0 0 1-15.5 6.2L3 16"/><path d="M3 21v-5h5"/>', 2.4),
    trash: icon('<path d="M4 7h16"/><path d="M9 7V4.5h6V7"/><path d="M6 7l1 13h10l1-13"/><path d="M10 11v6M14 11v6"/>', 2.2),
    plus: icon('<path d="M12 5v14M5 12h14"/>', 2.8),
    minus: icon('<path d="M5 12h14"/>', 2.8),
    close: icon('<path d="M6 6l12 12M18 6L6 18"/>', 2.6),
    check: icon('<path d="M5 12.5l4.5 4.5L19 7.5"/>', 3.4),
    pencil: icon('<path d="M4 20h4L19 9l-4-4L4 16z"/><path d="M13.5 6.5l4 4"/>', 2.2),
    play: '<svg viewBox="0 0 24 24" fill="currentColor" aria-hidden="true"><path d="M7 4.5v15a1 1 0 0 0 1.5.86l12-7.5a1 1 0 0 0 0-1.72l-12-7.5A1 1 0 0 0 7 4.5z"/></svg>',
    people: icon('<circle cx="9" cy="8" r="3.2"/><path d="M3 19c0-3.3 2.7-5.5 6-5.5s6 2.2 6 5.5"/><circle cx="17" cy="9" r="2.6"/><path d="M16.5 13.6c2.6.2 4.5 2.1 4.5 4.9"/>', 2.2),
    grid: icon('<rect x="4" y="4" width="7" height="7" rx="2"/><rect x="13" y="4" width="7" height="7" rx="2"/><rect x="4" y="13" width="7" height="7" rx="2"/><rect x="13" y="13" width="7" height="7" rx="2"/>', 2.2),
    mask: icon('<path d="M3 8c6 2.5 12 2.5 18 0v3.5c0 3.6-3 6.5-6.5 6.5-1.3 0-2-.9-2.5-1.8-.5.9-1.2 1.8-2.5 1.8C6 18 3 15.1 3 11.5z"/><path d="M7.5 11.5h2M14.5 11.5h2"/>', 2.2),
    timer: icon('<circle cx="12" cy="13.5" r="7.5"/><path d="M12 9.5v4l2.5 2"/><path d="M10 3h4"/>', 2.2),
  };

  // ---------- Saved settings ----------

  const STORAGE_KEY = 'imposter.web.v1';
  const newId = () =>
    typeof crypto !== 'undefined' && crypto.randomUUID
      ? crypto.randomUUID()
      : Math.random().toString(36).slice(2) + Date.now().toString(36);

  const defaultSettings = () => ({
    playerCount: 5,
    imposterCount: 1,
    roundMinutes: 5,
    customCategories: [], // user categories, plus edited copies of built-in ones (same id)
    hiddenBuiltIns: [],
    selected: BUILT_INS.map((c) => c.id),
  });

  function loadSettings() {
    try {
      const raw = localStorage.getItem(STORAGE_KEY);
      if (raw) {
        const saved = JSON.parse(raw);
        // Older versions kept a list of named players.
        if (saved.playerCount == null && Array.isArray(saved.players)) saved.playerCount = saved.players.length;
        delete saved.players;
        return Object.assign(defaultSettings(), saved);
      }
    } catch (e) { /* storage unavailable: start fresh */ }
    return defaultSettings();
  }

  const settings = loadSettings();

  function persist() {
    try { localStorage.setItem(STORAGE_KEY, JSON.stringify(settings)); } catch (e) { /* ignore */ }
  }

  /** Saves, and makes the deck deal fresh cards the next time it shows. */
  function settingsChanged() {
    game.stale = true;
    persist();
  }

  // ---------- Helpers ----------

  const trim = (s) => String(s == null ? '' : s).trim();
  const esc = (s) => String(s).replace(/[&<>"']/g, (ch) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[ch]));
  const pick = (list) => list[Math.floor(Math.random() * list.length)];
  const shuffle = (list) => {
    const a = list.slice();
    for (let i = a.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      [a[i], a[j]] = [a[j], a[i]];
    }
    return a;
  };

  /** Trimmed, non-empty, case-insensitively unique words. */
  function cleanWords(words) {
    const seen = new Set();
    return words.map(trim).filter((w) => {
      const key = w.toLowerCase();
      if (!w || seen.has(key)) return false;
      seen.add(key);
      return true;
    });
  }

  // ---------- Categories ----------

  const isBuiltIn = (id) => id.startsWith(BUILT_IN_PREFIX);

  function allCategories() {
    const edited = new Map(settings.customCategories.map((c) => [c.id, c]));
    const builtIns = BUILT_INS.filter((c) => !settings.hiddenBuiltIns.includes(c.id)).map((c) => edited.get(c.id) || c);
    return builtIns.concat(settings.customCategories.filter((c) => !isBuiltIn(c.id)));
  }

  const findCategory = (id) => allCategories().find((c) => c.id === id);
  const isSelected = (id) => settings.selected.includes(id);
  const allSelected = () => allCategories().every((c) => isSelected(c.id));
  const playableSelected = () => allCategories().filter((c) => isSelected(c.id) && cleanWords(c.words).length >= 2);

  function setSelected(id, on) {
    const ids = new Set(settings.selected);
    if (on) ids.add(id); else ids.delete(id);
    settings.selected = [...ids];
    settingsChanged();
  }

  /** Changes a category; editing a built-in one saves an edited copy of it. */
  function updateCategory(id, change) {
    let category = settings.customCategories.find((c) => c.id === id);
    if (!category) {
      const original = BUILT_INS.find((c) => c.id === id);
      if (!original) return;
      category = { id: original.id, name: original.name, words: original.words.slice() };
      settings.customCategories.push(category);
    }
    change(category);
    settingsChanged();
  }

  function createCategory(name) {
    const category = { id: newId(), name, words: [] };
    settings.customCategories.push(category);
    settings.selected.push(category.id);
    settingsChanged();
    return category.id;
  }

  /** Adds words separated by commas or new lines, skipping ones already in the category. */
  function addWords(id, text) {
    updateCategory(id, (category) => {
      const known = new Set(category.words.map((w) => w.toLowerCase()));
      const incoming = text.split(/[,\n]/).map(trim).filter((w) => {
        const key = w.toLowerCase();
        if (!w || known.has(key)) return false;
        known.add(key);
        return true;
      });
      category.words = incoming.concat(category.words);
    });
  }

  function deleteCategory(id) {
    if (BUILT_INS.some((c) => c.id === id) && !settings.hiddenBuiltIns.includes(id)) {
      settings.hiddenBuiltIns.push(id);
    }
    settings.customCategories = settings.customCategories.filter((c) => c.id !== id);
    settings.selected = settings.selected.filter((x) => x !== id);
    settingsChanged();
  }

  // ---------- Dealing ----------

  /** Imposters must be outnumbered by everyone else. */
  const MIN_PLAYERS = 3;
  const MAX_PLAYERS = 20;
  const playerCount = () => Math.min(MAX_PLAYERS, Math.max(MIN_PLAYERS, settings.playerCount || MIN_PLAYERS));
  const maxImposters = () => Math.max(1, Math.floor((playerCount() - 1) / 2));
  const imposterCount = () => Math.min(Math.max(settings.imposterCount, 1), maxImposters());

  function startProblem() {
    if (!playableSelected().length) return 'Choose a category';
    return null;
  }

  const game = { round: null, index: 0, revealed: false, done: false, stale: true };
  const recentWords = [];

  /**
   * Picks k of n seats so no two imposters sit next to each other around the table
   * (the last player counts as next to Player 1). Splits the other players into k
   * random gaps of at least one, then rotates the whole table by a random amount.
   */
  function pickImposterSeats(n, k) {
    const others = n - k;
    const cuts = shuffle(Array.from({ length: others - 1 }, (_, i) => i + 1)).slice(0, k - 1).sort((a, b) => a - b);
    const bounds = [0, ...cuts, others];
    let seat = Math.floor(Math.random() * n);
    const seats = [];
    for (let i = 0; i < k; i++) {
      seats.push(seat % n);
      seat += 1 + (bounds[i + 1] - bounds[i]);
    }
    return seats;
  }

  function makeRound() {
    if (startProblem()) return null;
    const category = pick(playableSelected());
    const words = cleanWords(category.words);
    let candidates = words.filter((w) => !recentWords.includes(w.toLowerCase()));
    if (!candidates.length) candidates = words;
    const civilianWord = pick(candidates);
    const imposterWord = pick(words.filter((w) => w !== civilianWord));

    recentWords.push(civilianWord.toLowerCase());
    if (recentWords.length > 20) recentWords.shift();

    const players = Array.from({ length: playerCount() }, (_, i) => ({ id: i, name: `Player ${i + 1}` }));
    const imposterIds = new Set(pickImposterSeats(players.length, imposterCount()));
    return { categoryName: category.name, civilianWord, imposterWord, players, imposterIds, starter: pick(players) };
  }

  function dealNow() {
    Object.assign(game, { round: makeRound(), index: 0, revealed: false, done: false, stale: false });
  }

  function dealIfNeeded() {
    if (game.stale || !game.round) dealNow();
  }

  const wordFor = (round, i) => (round.imposterIds.has(round.players[i].id) ? round.imposterWord : round.civilianWord);

  // ---------- Timer ----------

  const RING = 2 * Math.PI * 120;
  const timer = { total: 60, remaining: 60, running: false, endAt: 0, handle: null, wakeLock: null };

  function startTimer() {
    timer.total = settings.roundMinutes * 60;
    timer.remaining = timer.total;
    timer.running = true;
    timer.endAt = Date.now() + timer.total * 1000;
    clearInterval(timer.handle);
    timer.handle = setInterval(tick, 250);
    requestWakeLock();
  }

  function tick() {
    if (!timer.running) return;
    const left = Math.max(0, Math.ceil((timer.endAt - Date.now()) / 1000));
    if (left === timer.remaining) return;
    timer.remaining = left;
    if (left === 0) {
      timer.running = false;
      if (navigator.vibrate) navigator.vibrate([200, 100, 200]);
    }
    updateTimerUI();
  }

  function toggleTimer() {
    if (timer.remaining === 0) return;
    timer.running = !timer.running;
    if (timer.running) timer.endAt = Date.now() + timer.remaining * 1000;
    updateTimerUI();
  }

  function stopTimer() {
    clearInterval(timer.handle);
    timer.handle = null;
    timer.running = false;
    releaseWakeLock();
  }

  function updateTimerUI() {
    const clock = document.getElementById('clock');
    if (!clock) return;
    const minutes = Math.floor(timer.remaining / 60);
    const seconds = String(timer.remaining % 60).padStart(2, '0');
    clock.textContent = `${minutes}:${seconds}`;
    document.getElementById('timer-status').textContent =
      timer.remaining === 0 ? 'Time is up · vote!' : timer.running ? 'Time left' : 'Paused';
    document.getElementById('ring-progress').style.strokeDashoffset = String(RING * (1 - timer.remaining / timer.total));
    document.getElementById('pause-btn').textContent = timer.running || timer.remaining === 0 ? 'Pause' : 'Resume';
  }

  async function requestWakeLock() {
    try {
      if ('wakeLock' in navigator) timer.wakeLock = await navigator.wakeLock.request('screen');
    } catch (e) { /* not allowed right now */ }
  }

  function releaseWakeLock() {
    try { if (timer.wakeLock) timer.wakeLock.release(); } catch (e) { /* ignore */ }
    timer.wakeLock = null;
  }

  document.addEventListener('visibilitychange', () => {
    if (document.visibilityState === 'visible' && timer.handle) {
      requestWakeLock();
      tick();
    }
  });

  // ---------- Navigation ----------

  const app = document.getElementById('app');
  const modalRoot = document.getElementById('modal-root');
  const stack = [{ name: 'menu', params: {} }];
  const current = () => stack[stack.length - 1];

  function afterNavigate() {
    if (!stack.some((s) => s.name === 'timer')) stopTimer();
    if (current().name === 'deck') dealIfNeeded();
  }

  function push(name, params = {}) {
    stack.push({ name, params });
    afterNavigate();
    render('enter');
  }

  function pop() {
    if (stack.length > 1) stack.pop();
    afterNavigate();
    render('back');
  }

  /** Goes back to the menu, then opens the given screens on top of it. */
  function resetTo(...names) {
    stack.length = 1;
    names.forEach((name) => stack.push({ name, params: {} }));
    afterNavigate();
    render('back');
  }

  function render(transition = '') {
    const screen = current();
    let html;
    switch (screen.name) {
      case 'menu': html = menuScreen(); break;
      case 'deck': html = deckScreen(); break;
      case 'categories': html = categoriesScreen(); break;
      case 'words': html = wordsScreen(screen.params.id); break;
      case 'timer': html = timerScreen(); break;
      case 'result': html = resultScreen(); break;
      default: html = menuScreen();
    }
    if (html == null) { pop(); return; }

    const oldScroll = app.querySelector('.scroll');
    const keepScroll = !transition && oldScroll ? oldScroll.scrollTop : 0;

    app.innerHTML = `<section class="screen ${transition}">${html}</section>`;

    const newScroll = app.querySelector('.scroll');
    if (newScroll && keepScroll) newScroll.scrollTop = keepScroll;
    if (screen.name === 'timer') updateTimerUI();
  }

  // ---------- Shared pieces ----------

  const iconButton = (action, svg, label) =>
    `<button class="icon-btn" data-action="${action}" aria-label="${label}">${svg}</button>`;
  const backButton = () => iconButton('back', ICONS.back, 'Back');

  const topBar = (titleHtml, start = '', end = '') => `
    <header class="topbar">
      <div>${start}</div>
      <h1>${titleHtml}</h1>
      <div class="tb-end">${end}</div>
    </header>`;

  // ---------- Menu ----------

  const gameInProgress = () => !game.stale && game.round && (game.index > 0 || game.revealed || game.done);

  function menuScreen() {
    const selectedCount = playableSelected().length;
    const totalCount = allCategories().length;
    const minutes = settings.roundMinutes;
    return `
      <div class="scroll menu">
        <div class="menu-top">
          ${iconButton('help', ICONS.question, 'How to play')}
        </div>
        <div class="hero" aria-hidden="true">
          <span class="hero-card left"><span class="stripes"></span></span>
          <span class="hero-card right"><span class="stripes"></span></span>
          <span class="hero-card middle">${SPY()}<span class="hero-q">?</span></span>
        </div>
        <h1 class="logo">Imposter</h1>
        <p class="tagline">One word is not like the others</p>

        <div class="menu-actions">
          <button class="btn-red play" data-action="play">${ICONS.play}<span>${gameInProgress() ? 'Continue' : 'Play'}</span></button>
          ${gameInProgress() ? '<button class="new-game" data-action="new-game">New game</button>' : ''}
        </div>

        <div class="menu-grid">
          <div class="menu-tile raised">
            <span class="tile-icon">${ICONS.people}</span>
            <span class="tile-stepper">
              <button class="mini-step" data-action="step" data-key="players" data-delta="-1" ${playerCount() <= MIN_PLAYERS ? 'disabled' : ''} aria-label="Fewer players">${ICONS.minus}</button>
              <span class="tile-value">${playerCount()}</span>
              <button class="mini-step" data-action="step" data-key="players" data-delta="1" ${playerCount() >= MAX_PLAYERS ? 'disabled' : ''} aria-label="More players">${ICONS.plus}</button>
            </span>
            <span class="tile-label">Players</span>
          </div>
          <button class="menu-tile raised" data-action="go" data-to="categories">
            <span class="tile-icon">${ICONS.grid}</span>
            <span class="tile-value">${selectedCount}<small>/${totalCount}</small></span>
            <span class="tile-label">Categories</span>
            <span class="tile-go">${ICONS.chevron}</span>
          </button>
          <div class="menu-tile raised">
            <span class="tile-icon">${ICONS.mask}</span>
            <span class="tile-stepper">
              <button class="mini-step" data-action="step" data-key="imposters" data-delta="-1" ${imposterCount() <= 1 ? 'disabled' : ''} aria-label="Fewer imposters">${ICONS.minus}</button>
              <span class="tile-value">${imposterCount()}</span>
              <button class="mini-step" data-action="step" data-key="imposters" data-delta="1" ${imposterCount() >= maxImposters() ? 'disabled' : ''} aria-label="More imposters">${ICONS.plus}</button>
            </span>
            <span class="tile-label">${imposterCount() === 1 ? 'Imposter' : 'Imposters'}</span>
          </div>
          <div class="menu-tile raised">
            <span class="tile-icon">${ICONS.timer}</span>
            <span class="tile-stepper">
              <button class="mini-step" data-action="step" data-key="minutes" data-delta="-1" ${minutes <= 1 ? 'disabled' : ''} aria-label="Shorter rounds">${ICONS.minus}</button>
              <span class="tile-value">${minutes}<small>m</small></span>
              <button class="mini-step" data-action="step" data-key="minutes" data-delta="1" ${minutes >= 15 ? 'disabled' : ''} aria-label="Longer rounds">${ICONS.plus}</button>
            </span>
            <span class="tile-label">Round timer</span>
          </div>
        </div>
      </div>`;
  }

  // ---------- Deck ----------

  function deckScreen() {
    const r = game.round;
    const title = !r ? 'Imposter' : game.done ? 'Ready' : `Card ${game.index + 1} of ${r.players.length}`;
    const remaining = r ? r.players.length - game.index : 1;
    return `
      ${topBar(esc(title), iconButton('back', ICONS.back, 'Menu'), iconButton('redeal', ICONS.refresh, 'Deal new cards'))}
      <div class="deck-area">
        <div class="deck">
          ${game.done || remaining >= 3 ? '<div class="card-back b2"></div>' : ''}
          ${game.done || remaining >= 2 ? '<div class="card-back b1"></div>' : ''}
          <button class="card" data-action="card" aria-label="${cardLabel()}">${cardFace()}</button>
        </div>
      </div>
      <div class="deck-controls">${deckControls()}</div>`;
  }

  function cardLabel() {
    if (!game.round) return 'Fix the game setup';
    if (game.done) return 'Everyone has a word';
    return game.revealed ? 'Hide word and pass the phone' : 'Show my word';
  }

  function cardFace() {
    const r = game.round;
    if (!r) {
      return `<span class="stripes"></span>
        <span class="face center">${SPY('small')}<span class="problem">${esc(startProblem() || '')}</span><span class="hint">Tap to fix it</span></span>`;
    }
    if (game.done) {
      return `<span class="face center">${SPY()}<span class="ready-title">Everyone has a word</span><span class="hint">${esc(r.starter.name)} asks first</span></span>`;
    }
    if (game.revealed) {
      return `<span class="face word-face">
          ${BUBBLE}
          <span class="label">Secret word</span>
          <span class="secret">${esc(wordFor(r, game.index))}</span>
          <span class="rule"></span>
          <span class="explain">Everyone got a secret word, but one of you got a different one and doesn't know it. Ask questions to find out who.</span>
          <span class="grow"></span>
          <span class="footnote">Tap to hide · pass the phone</span>
        </span>`;
    }
    return `<span class="stripes"></span>
      <span class="face center"><span class="player-name">${esc(r.players[game.index].name)}</span><span class="hint">Tap to see your word</span></span>`;
  }

  function deckControls() {
    if (game.done) return '<button class="btn-red" data-action="start-round">Start round</button>';
    const names = playableSelected().map((c) => c.name);
    const summary = !names.length
      ? 'Choose categories'
      : names.length <= 3 ? names.join(', ') : `${names.slice(0, 3).join(', ')} +${names.length - 3}`;
    return `
      <div class="controls ${game.revealed ? 'dimmed' : ''}">
        <div class="pill-row">
          <button class="btn-dark" data-action="back">Players · ${playerCount()}</button>
          <button class="btn-dark" data-action="back">Imposters · ${imposterCount()}</button>
        </div>
        <button class="btn-dark summary" data-action="go" data-to="categories"><span>${esc(summary)}</span>${ICONS.chevron}</button>
      </div>`;
  }

  let animating = false;
  const wait = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

  /** Runs an animation, but never waits longer than its duration (backgrounded pages can stall them). */
  function play(el, keyframes, options) {
    const animation = el.animate(keyframes, options);
    return Promise.race([animation.finished.catch(() => {}), wait(options.duration + 80)]);
  }

  /** Flips the card edge-on (or throws it aside), applies the change, then brings the new face in. */
  async function animateCard(kind, change) {
    const card = app.querySelector('.card');
    if (animating) return;
    if (!card || !card.animate) { change(); render(); return; }
    animating = true;
    try {
      if (kind === 'slide') {
        await play(card, [{ transform: 'translateX(0) rotate(0deg)' }, { transform: 'translateX(-130%) rotate(-14deg)' }],
          { duration: 220, easing: 'ease-in', fill: 'forwards' });
        change();
        render();
        const next = app.querySelector('.card');
        if (next) await play(next, [{ transform: 'scale(0.92)' }, { transform: 'scale(1)' }], { duration: 280, easing: 'cubic-bezier(.2,1.4,.4,1)' });
      } else {
        await play(card, [{ transform: 'rotateY(0deg)' }, { transform: 'rotateY(90deg)' }], { duration: 140, easing: 'ease-in', fill: 'forwards' });
        change();
        render();
        const next = app.querySelector('.card');
        if (next) await play(next, [{ transform: 'rotateY(-90deg)' }, { transform: 'rotateY(0deg)' }], { duration: 180, easing: 'ease-out' });
      }
    } finally {
      animating = false;
    }
  }

  // ---------- Categories ----------

  function categoriesScreen() {
    const tiles = allCategories().map((c) => {
      const selected = isSelected(c.id);
      const count = cleanWords(c.words).length;
      return `
        <div class="cat-wrap">
          <button class="cat-tile ${selected ? 'selected' : ''}" data-action="toggle-cat" data-id="${esc(c.id)}" aria-pressed="${selected}">
            ${SPY()}
            <span class="cat-name">${esc(c.name)}</span>
            <span class="cat-count ${count < 2 ? 'warn' : ''}">${count < 2 ? 'Needs words' : count}</span>
          </button>
          <button class="cat-open" data-action="open-cat" data-id="${esc(c.id)}" aria-label="Edit words in ${esc(c.name)}">${ICONS.chevron}</button>
          ${selected ? `<span class="check">${ICONS.check}</span>` : ''}
        </div>`;
    }).join('');

    return `
      ${topBar('Categories', backButton(), `<button class="text-btn" data-action="toggle-all">${allSelected() ? 'None' : 'Select all'}</button>`)}
      <div class="scroll">
        <div class="grid3">
          ${tiles}
          <button class="add-tile cat dashed" data-action="new-cat">${ICONS.plus}<span>New<br>category</span></button>
        </div>
        ${settings.hiddenBuiltIns.length ? '<div class="pad"><button class="btn-dark wide" data-action="restore">Restore built-in categories</button></div>' : ''}
        <p class="note">Tap to select. Each round picks one of the selected categories at random. Use the arrow to see or edit its words.</p>
      </div>`;
  }

  function wordsScreen(id) {
    const category = findCategory(id);
    if (!category) return null;
    const tiles = category.words.map((w, i) => `
      <div class="word-tile raised">
        ${BUBBLE}
        <span class="word-text">${esc(w)}</span>
        <button class="word-x" data-action="remove-word" data-index="${i}" aria-label="Remove ${esc(w)}">${ICONS.close}</button>
      </div>`).join('');
    const title = `<button class="title-btn" data-action="rename-cat" aria-label="Rename ${esc(category.name)}"><span>${esc(category.name)}</span>${ICONS.pencil}</button>`;

    return `
      ${topBar(title, backButton(), iconButton('delete-cat', ICONS.trash, 'Delete category'))}
      <div class="scroll">
        ${cleanWords(category.words).length < 2 ? '<p class="warn-line">Add at least 2 words to play this category</p>' : ''}
        <div class="grid3">
          <button class="add-tile word dashed" data-action="add-words">${ICONS.plus}<span>Add a<br>new word</span></button>
          ${tiles}
        </div>
      </div>
      <div class="footer">
        ${isSelected(id)
          ? '<button class="btn-dark wide big" data-action="deselect-cat">Deselect</button>'
          : '<button class="btn-red" data-action="select-cat">Select</button>'}
      </div>`;
  }

  // ---------- Timer & result ----------

  function timerScreen() {
    const r = game.round;
    return `
      ${topBar('Round', backButton())}
      <div class="timer-body">
        <div class="ring">
          <svg viewBox="0 0 264 264" aria-hidden="true">
            <circle class="ring-track" cx="132" cy="132" r="120"/>
            <circle id="ring-progress" class="ring-progress" cx="132" cy="132" r="120" stroke-dasharray="${RING}"/>
          </svg>
          <div class="ring-text">
            <span id="clock" class="clock" role="timer">0:00</span>
            <span id="timer-status" class="timer-status"></span>
          </div>
        </div>
        <p class="timer-copy">Start asking questions! Find the imposter before the time runs out.</p>
        ${r ? `<p class="starter-chip"><span class="dot"></span>${esc(r.starter.name)} asks first</p>` : ''}
      </div>
      <div class="footer row">
        <button id="pause-btn" class="btn-dark tall" data-action="toggle-timer">Pause</button>
        <button class="btn-red auto" data-action="end-round">End round</button>
      </div>`;
  }

  function resultScreen() {
    const r = game.round;
    if (!r) return null;
    const imposters = r.players.filter((p) => r.imposterIds.has(p.id));
    const several = imposters.length > 1;
    return `
      ${topBar('Results', backButton())}
      <div class="scroll">
        <div class="result-card">
          <span class="chip">Category · ${esc(r.categoryName)}</span>
          ${SPY()}
          <span class="result-label">${several ? 'The imposters were' : 'The imposter was'}</span>
          <span class="result-names">${imposters.map((p) => esc(p.name)).join(' &amp; ')}</span>
          <span class="rule"></span>
          <div class="word-boxes">
            <div class="word-box"><span class="word-box-title">Everyone's word</span><span class="word-box-word">${esc(r.civilianWord)}</span></div>
            <div class="word-box imp"><span class="word-box-title">${several ? "Imposters' word" : "Imposter's word"}</span><span class="word-box-word">${esc(r.imposterWord)}</span></div>
          </div>
        </div>
      </div>
      <div class="footer two">
        <button class="btn-red" data-action="play-again">Play again</button>
        <button class="btn-dark wide" data-action="menu">Menu</button>
      </div>`;
  }

  // ---------- Dialogs ----------

  function openDialog({ title, message, input, placeholder = '', value = '', confirm, onConfirm }) {
    modalRoot.innerHTML = `
      <div class="backdrop">
        <div class="dialog" role="dialog" aria-modal="true" aria-labelledby="dialog-title">
          <h2 id="dialog-title">${esc(title)}</h2>
          ${message ? `<p class="dialog-msg">${esc(message)}</p>` : ''}
          ${input ? `<input id="dialog-input" class="dialog-input" type="text" placeholder="${esc(placeholder)}" value="${esc(value)}"
            aria-label="${esc(title)}" autocomplete="off" autocapitalize="words" spellcheck="false" enterkeyhint="done">` : ''}
          <div class="dialog-actions">
            <button class="btn-dark" data-dialog="cancel">Cancel</button>
            <button class="btn-red" data-dialog="ok">${esc(confirm)}</button>
          </div>
        </div>
      </div>`;
    const field = document.getElementById('dialog-input');
    const close = () => { modalRoot.innerHTML = ''; };
    const ok = () => {
      const result = field ? field.value : '';
      close();
      onConfirm(result);
    };
    modalRoot.querySelector('[data-dialog="ok"]').addEventListener('click', ok);
    modalRoot.querySelector('[data-dialog="cancel"]').addEventListener('click', close);
    modalRoot.querySelector('.backdrop').addEventListener('click', (e) => { if (e.target === e.currentTarget) close(); });
    if (field) {
      field.focus();
      field.addEventListener('keydown', (e) => { if (e.key === 'Enter') { e.preventDefault(); ok(); } });
    }
  }

  const HELP_STEPS = [
    ['Set up', 'Choose how many players and imposters, and pick your categories.'],
    ['Pass the deck', 'Each player taps the card to see their secret word, memorizes it, then taps again to hide it and passes the phone on.'],
    ['The twist', "Most players get the same word. The imposter gets a different word from the same category, and doesn't know they're the imposter."],
    ['Ask questions', "Start the timer and take turns asking each other questions out loud. Never say your word. Listen for answers that don't quite fit."],
    ['Vote', 'When you\'re ready, everyone points at who they think the imposter is.'],
    ['Reveal', 'End the round to see who the imposter really was, and both words.'],
  ];

  function openHelp() {
    const steps = HELP_STEPS.map(([title, text], i) => `
      <div class="step raised"><span class="badge">${i + 1}</span><div><div class="step-title">${title}</div><div class="step-text">${esc(text)}</div></div></div>`).join('');
    modalRoot.innerHTML = `
      <div class="sheet" role="dialog" aria-modal="true" aria-label="How to play">
        ${topBar('How to play', '', `<button class="icon-btn" data-sheet="close" aria-label="Close">${ICONS.close}</button>`)}
        <div class="scroll"><div class="stack">${steps}</div></div>
      </div>`;
    modalRoot.querySelector('[data-sheet="close"]').addEventListener('click', () => { modalRoot.innerHTML = ''; });
  }

  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape' && modalRoot.innerHTML) modalRoot.innerHTML = '';
  });

  // ---------- Actions ----------

  const currentCategoryId = () => current().params.id;

  const actions = {
    back: () => pop(),
    go: (el) => push(el.dataset.to),
    help: () => openHelp(),

    card: () => {
      if (animating) return;
      const r = game.round;
      if (!r) { push('categories'); return; }
      if (game.done) return;
      if (!game.revealed) {
        animateCard('flip', () => { game.revealed = true; });
      } else if (game.index < r.players.length - 1) {
        animateCard('slide', () => { game.revealed = false; game.index += 1; });
      } else {
        animateCard('flip', () => { game.revealed = false; game.done = true; });
      }
    },
    redeal: () => { if (!animating) animateCard('flip', dealNow); },
    'start-round': () => { startTimer(); push('timer'); },

    step: (el) => {
      const delta = Number(el.dataset.delta);
      if (el.dataset.key === 'players') {
        settings.playerCount = Math.min(MAX_PLAYERS, Math.max(MIN_PLAYERS, playerCount() + delta));
        settings.imposterCount = Math.min(settings.imposterCount, maxImposters());
        settingsChanged();
      } else if (el.dataset.key === 'imposters') {
        settings.imposterCount = Math.min(maxImposters(), Math.max(1, imposterCount() + delta));
        settingsChanged();
      } else {
        settings.roundMinutes = Math.min(15, Math.max(1, settings.roundMinutes + delta));
        persist();
      }
      render();
    },

    'toggle-cat': (el) => { setSelected(el.dataset.id, !isSelected(el.dataset.id)); render(); },
    'open-cat': (el) => push('words', { id: el.dataset.id }),
    'toggle-all': () => {
      settings.selected = allSelected() ? [] : allCategories().map((c) => c.id);
      settingsChanged();
      render();
    },
    restore: () => { settings.hiddenBuiltIns = []; settingsChanged(); render(); },
    'new-cat': () => openDialog({
      title: 'New category',
      message: 'Then add the words for it.',
      input: true,
      placeholder: 'Name',
      confirm: 'Create',
      onConfirm: (value) => {
        const name = trim(value);
        if (name) push('words', { id: createCategory(name) });
      },
    }),

    'add-words': () => openDialog({
      title: 'Add words',
      message: 'Separate several words with commas.',
      input: true,
      placeholder: 'Pizza, Burger, Sushi',
      confirm: 'Add',
      onConfirm: (value) => { addWords(currentCategoryId(), value); render(); },
    }),
    'remove-word': (el) => {
      const index = Number(el.dataset.index);
      updateCategory(currentCategoryId(), (c) => { c.words.splice(index, 1); });
      render();
    },
    'rename-cat': () => {
      const category = findCategory(currentCategoryId());
      if (!category) return;
      openDialog({
        title: 'Rename category',
        input: true,
        value: category.name,
        confirm: 'Save',
        onConfirm: (value) => {
          const name = trim(value);
          if (name) { updateCategory(category.id, (c) => { c.name = name; }); render(); }
        },
      });
    },
    'delete-cat': () => {
      const id = currentCategoryId();
      openDialog({
        title: 'Delete this category?',
        message: isBuiltIn(id) ? 'You can restore built-in categories later.' : "This can't be undone.",
        confirm: 'Delete',
        onConfirm: () => { deleteCategory(id); pop(); },
      });
    },
    'select-cat': () => { setSelected(currentCategoryId(), true); pop(); },
    'deselect-cat': () => { setSelected(currentCategoryId(), false); pop(); },

    'toggle-timer': () => toggleTimer(),
    'end-round': () => push('result'),
    play: () => push('deck'),
    'new-game': () => { game.stale = true; push('deck'); },
    'play-again': () => { game.stale = true; resetTo('deck'); },
    menu: () => { game.stale = true; resetTo(); },
  };

  app.addEventListener('click', (e) => {
    const el = e.target.closest('[data-action]');
    if (!el || el.disabled) return;
    const action = actions[el.dataset.action];
    if (action) action(el, e);
  });

  // Stop iOS from pinch-zooming the game.
  document.addEventListener('gesturestart', (e) => e.preventDefault());

  // ---------- Start ----------

  dealIfNeeded();
  render();

  if ('serviceWorker' in navigator && location.protocol === 'https:') {
    navigator.serviceWorker.register('sw.js').catch(() => {});
  }
})();
