const currentPage = window.location.pathname.split("/").pop().toLowerCase();
const isHomePage = currentPage === "" || currentPage === "index.html";

if (isHomePage) {
  const loaderStartedAt = Date.now();
  document.body.classList.add("is-intro");

  const pageLoader = document.createElement("div");
  pageLoader.className = "page-loader";
  pageLoader.innerHTML = `
    <div class="page-loader__content">
      <p class="page-loader__title">NC STUDIO</p>
      <p class="page-loader__subtitle">Creative Motion</p>
    </div>
  `;

  document.body.appendChild(pageLoader);

  const closeLoader = () => {
    const elapsed = Date.now() - loaderStartedAt;
    const wait = Math.max(0, 900 - elapsed);

    setTimeout(() => {
      pageLoader.classList.add("done");
      document.body.classList.remove("is-intro");
      setTimeout(() => pageLoader.remove(), 420);
    }, wait);
  };

  if (document.readyState === "complete") {
    closeLoader();
  } else {
    window.addEventListener("load", closeLoader, { once: true });
  }
} else {
  document.body.classList.add("page-enter");
  requestAnimationFrame(() => {
    requestAnimationFrame(() => {
      document.body.classList.add("page-enter-active");
    });
  });
}

const offerSeenKey = "nc_offer_seen";
const showOfferPopup = () => {
  if (sessionStorage.getItem(offerSeenKey) === "1") return;

  const overlay = document.createElement("div");
  overlay.className = "offer-popup";
  overlay.innerHTML = `
    <div class="offer-popup__panel" role="dialog" aria-modal="true" aria-label="Offre de lancement">
      <button class="offer-popup__close" type="button" aria-label="Fermer">&times;</button>
      <p class="offer-popup__eyebrow">Offre de lancement</p>
      <h2>Les 2 premières créations sont gratuites !</h2>
      <p>Valable sur les logos et bannières.</p>
      <a class="btn btn-primary" href="https://discord.gg/3ukNzVD94q" target="_blank" rel="noopener noreferrer">J'en profite sur Discord</a>
    </div>
  `;

  const closePopup = () => {
    overlay.classList.add("hide");
    document.body.classList.remove("offer-open");
    sessionStorage.setItem(offerSeenKey, "1");
    setTimeout(() => overlay.remove(), 260);
    document.removeEventListener("keydown", onKeyDown);
  };

  const onKeyDown = (event) => {
    if (event.key === "Escape") closePopup();
  };

  overlay.addEventListener("click", (event) => {
    if (event.target === overlay) closePopup();
  });

  const closeBtn = overlay.querySelector(".offer-popup__close");
  if (closeBtn) closeBtn.addEventListener("click", closePopup);

  document.body.appendChild(overlay);
  document.body.classList.add("offer-open");
  document.addEventListener("keydown", onKeyDown);

  requestAnimationFrame(() => {
    overlay.classList.add("show");
  });
};

const popupDelay = isHomePage ? 1500 : 450;
setTimeout(showOfferPopup, popupDelay);

const toggles = document.querySelectorAll(".menu-toggle");

toggles.forEach((btn) => {
  btn.addEventListener("click", () => {
    const navId = btn.getAttribute("aria-controls");
    const nav = document.getElementById(navId);
    if (!nav) return;

    const isOpen = nav.classList.toggle("open");
    btn.setAttribute("aria-expanded", String(isOpen));
  });
});

document.querySelectorAll(".site-nav a").forEach((link) => {
  link.addEventListener("click", () => {
    const nav = link.closest(".site-nav");
    const btn = document.querySelector(".menu-toggle[aria-controls='site-nav']");
    if (!nav || !btn) return;

    nav.classList.remove("open");
    btn.setAttribute("aria-expanded", "false");
  });
});

document.querySelectorAll(".contact-form").forEach((form) => {
  form.addEventListener("submit", (event) => {
    event.preventDefault();
    alert("Merci. Votre demande Discord a bien ete envoyee.");
    form.reset();
  });
});

let typedBuffer = "";
let audioCtx = null;
let lastMusicAt = 0;
let streamAudio = null;
const STREAM_MUSIC_URL = "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3";

const playSynthFallback = () => {
  const AudioCtx = window.AudioContext || window.webkitAudioContext;
  if (!AudioCtx) return;
  if (!audioCtx) audioCtx = new AudioCtx();
  if (audioCtx.state === "suspended") audioCtx.resume();

  const gain = audioCtx.createGain();
  gain.gain.value = 0.7;
  gain.connect(audioCtx.destination);

  const notes = [
    { f: 523.25, d: 0.18 },
    { f: 659.25, d: 0.18 },
    { f: 783.99, d: 0.22 },
    { f: 659.25, d: 0.18 },
    { f: 880.0, d: 0.24 },
    { f: 987.77, d: 0.24 },
    { f: 880.0, d: 0.2 },
    { f: 783.99, d: 0.2 },
    { f: 659.25, d: 0.22 },
    { f: 698.46, d: 0.2 },
    { f: 783.99, d: 0.22 },
    { f: 880.0, d: 0.26 },
    { f: 783.99, d: 0.2 },
    { f: 659.25, d: 0.2 },
    { f: 587.33, d: 0.22 },
    { f: 523.25, d: 0.34 },
  ];

  let t = audioCtx.currentTime + 0.02;
  notes.forEach((note) => {
    const osc = audioCtx.createOscillator();
    const oscGain = audioCtx.createGain();
    osc.type = "triangle";
    osc.frequency.setValueAtTime(note.f, t);

    oscGain.gain.setValueAtTime(0.0001, t);
    oscGain.gain.exponentialRampToValueAtTime(0.16, t + 0.03);
    oscGain.gain.exponentialRampToValueAtTime(0.0001, t + note.d);

    osc.connect(oscGain);
    oscGain.connect(gain);
    osc.start(t);
    osc.stop(t + note.d + 0.02);
    t += note.d;
  });
};

const playWelcomeMusic = () => {
  const nowTs = Date.now();
  if (nowTs - lastMusicAt < 3000) return;
  lastMusicAt = nowTs;

  if (!streamAudio) {
    streamAudio = new Audio(STREAM_MUSIC_URL);
    streamAudio.preload = "none";
    streamAudio.volume = 0.45;
  }

  streamAudio.currentTime = 0;
  streamAudio.play().catch(() => {
    playSynthFallback();
  });
};

document.addEventListener("keydown", (event) => {
  if (!event.key || event.key.length !== 1) return;
  typedBuffer = (typedBuffer + event.key.toUpperCase()).slice(-7);
  if (typedBuffer === "MUSIQUE") {
    playWelcomeMusic();
    typedBuffer = "";
  }
});

