import { next } from "@ember/runloop";
import { apiInitializer } from "discourse/lib/api";
import getURL from "discourse/lib/get-url";
import ViewChooser from "../components/view-chooser";
import ViewPreference from "../components/view-preference";
import launchedFromApp from "../lib/launched-from-app";

// "Elige tu vista": simple (Dumbcourse), moderna (this forum) or anonist (AI chat).
//
// Only a launch at `/` is ever redirected, and only once per page load. Notification
// taps and shared links keep opening their topic, and clicking the logo from the AI
// chat stays in moderna instead of bouncing back. Group homepages are untouched:
// they only ever see moderna users, because the others have left by then.
//
// `/?vista=elegir` reopens the chooser from anywhere (Dumbcourse, a sidebar link,
// anonymous visitors who can't reach Preferences).

export default apiInitializer((api) => {
  const viewChoice = api.container.lookup("service:view-choice");
  viewChoice.views = [
    settings.view_simple_url && {
      id: "simple",
      icon: "ph-dt-article",
      url: settings.view_simple_url,
      fullLoad: true,
    },
    { id: "moderna", icon: "ph-dt-squares-four", url: "/" },
    settings.view_anonist_url && {
      id: "anonist",
      icon: "ph-dt-anonist",
      url: settings.view_anonist_url,
    },
  ].filter(Boolean);

  api.renderInOutlet("above-site-header", ViewChooser);
  api.renderInOutlet("user-preferences-interface", ViewPreference);

  const atHome = window.location.pathname === getURL("/");
  const reopen =
    new URLSearchParams(window.location.search).get("vista") === "elegir";
  // A stored view whose URL setting was cleared since counts as no choice.
  const current = viewChoice.viewFor(viewChoice.current)?.id;

  if (reopen) {
    viewChoice.chooserOpen = true;
  } else if (atHome && !current) {
    viewChoice.chooserOpen =
      !settings.view_chooser_app_only || launchedFromApp();
  } else if (atHome && current !== "moderna") {
    const view = viewChoice.viewFor(current);
    if (view.fullLoad) {
      viewChoice.go(current); // starts right away; Ember views wait for routing below
    } else {
      // Routing from inside the initial transition (e.g. onPageChange) is ignored,
      // so wait for it to settle and go on the next run loop.
      const router = api.container.lookup("service:router");
      router.one("routeDidChange", () => next(() => viewChoice.go(current)));
    }
  }
});
