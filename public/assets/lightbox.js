/* ───────────────────────────────────────────────────────────────────────────
   YouTube lightbox
   ---------------------------------------------------------------------------
   The full films are NOT hosted on this site. They live on YouTube (unlisted)
   and open in a popup player when a "Watch Now" button is clicked.

   >>> TO LINK A FILM: paste its YouTube ID below. <<<
   The ID is the part after "v=" in a normal YouTube URL, or the last path
   segment of a youtu.be link. Example:
       https://www.youtube.com/watch?v=dQw4w9WgXcQ   ->   'dQw4w9WgXcQ'
       https://youtu.be/dQw4w9WgXcQ                  ->   'dQw4w9WgXcQ'

   Each "Watch Now" button in the HTML has a  data-video="<slug>"  attribute
   that matches a key below. Leave a value '' and that button shows a friendly
   "coming soon" note instead of crashing.
─────────────────────────────────────────────────────────────────────────── */
const VIDEOS = {
  // ── Long form ───────────────────────────────────────────────
  'nw-kidney-kids-2026': '4Jw7nTOPQU8',   // Northwest Kidney Kids 2026
  'nw-kidney-kids':    'q_Q4FTNUW3I',   // Northwest Kidney Kids 2025
  'dream-build':       'd704kzscwJc',   // Chris King — Dream Build
  'ski-club-movie':    'NGnISnu97Qk',   // Gonzaga Ski Club — "Ski Club Da Movie"
  // ── Short form (vertical YouTube Shorts) ────────────────────
  'splash-reel':       '_NVJiuPBWW0',   // Chris King — "Splash" Reel
  'outdoors-reel':     't06KRDObvN4',   // Gonzaga Outdoors Reel
  'egg-cartons-reel':  'l-hOLkpKNRs',   // Chris King — Egg Cartons Reel
  'headset-reel':      'U-tI7NMlQlM',   // Chris King — Headset Reel
  // ── Passion / personal ──────────────────────────────────────
  'yankaaz':           '-1PLFcgTh7I',   // Yankaaz
  'incomplete-memory': 'wa33XkWH7uo',   // An Incomplete Memory of a High School Summer
  'costa-rica':        'Dp8oqFpv5i8',   // Costa Rica Edit
  'jazz':              'Hhq83PK2Z_4'    // Gonzaga Jazz — Live Recording Session
};

(function () {
  // Build the overlay once.
  const overlay = document.createElement('div');
  overlay.className = 'lb-overlay';
  overlay.setAttribute('aria-hidden', 'true');
  overlay.innerHTML =
    '<div class="lb-dialog" role="dialog" aria-modal="true" aria-label="Video player">' +
      '<button class="lb-close" aria-label="Close video">&times;</button>' +
      '<div class="lb-frame"></div>' +
    '</div>';
  document.body.appendChild(overlay);

  const frame = overlay.querySelector('.lb-frame');

  function open(slug) {
    const id = VIDEOS[slug];
    if (id) {
      frame.innerHTML =
        '<iframe src="https://www.youtube-nocookie.com/embed/' + encodeURIComponent(id) +
        '?autoplay=1&rel=0" title="Video player" frameborder="0" ' +
        'allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" ' +
        'allowfullscreen></iframe>';
    } else {
      frame.innerHTML =
        '<div class="lb-soon">This film hasn’t been linked yet.<br>' +
        '<small>Add its YouTube ID for &ldquo;' + slug + '&rdquo; in assets/lightbox.js</small></div>';
    }
    overlay.classList.add('is-open');
    overlay.setAttribute('aria-hidden', 'false');
    document.body.style.overflow = 'hidden';
  }

  function close() {
    overlay.classList.remove('is-open');
    overlay.setAttribute('aria-hidden', 'true');
    frame.innerHTML = '';            // stops playback
    document.body.style.overflow = '';
  }

  // Delegate clicks from any element with data-video.
  document.addEventListener('click', function (e) {
    const trigger = e.target.closest('[data-video]');
    if (trigger) {
      e.preventDefault();
      open(trigger.getAttribute('data-video'));
      return;
    }
    if (e.target === overlay || e.target.closest('.lb-close')) {
      close();
    }
  });

  document.addEventListener('keydown', function (e) {
    if (e.key === 'Escape' && overlay.classList.contains('is-open')) close();
  });
})();
