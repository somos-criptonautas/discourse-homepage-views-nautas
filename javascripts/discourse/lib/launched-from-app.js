const KEY = "comunidadApp";

// True inside the installed app (the Android app or an installed PWA). Android only
// marks the first page load with an android-app:// referrer, so the answer is kept
// for the rest of the visit.
export default function launchedFromApp() {
  try {
    if (sessionStorage.getItem(KEY)) {
      return true;
    }
  } catch {
    // storage blocked: fall back to detecting every time
  }

  const inApp =
    window.matchMedia("(display-mode: standalone)").matches ||
    document.referrer.startsWith("android-app://");

  if (inApp) {
    try {
      sessionStorage.setItem(KEY, "1");
    } catch {
      // storage blocked: detection still works on this page
    }
  }
  return inApp;
}
