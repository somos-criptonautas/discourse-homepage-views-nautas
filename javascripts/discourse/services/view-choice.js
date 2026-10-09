import { tracked } from "@glimmer/tracking";
import Service, { service } from "@ember/service";
import getURL from "discourse/lib/get-url";
import DiscourseURL from "discourse/lib/url";

// Which view (simple / moderna / anonist) opens when the community is launched at `/`.
// Stored per device, like core's own interface choices: the app is one device, and
// anonymous visitors have no profile to hold it.
// Per-device only; sync through a user field if people ask for it across devices.
const KEY = "horizonView";

// Discourse's own "not found" / "no access" pages.
const ERROR_ROUTE = /^(unknown|exception)/;

function stored() {
  try {
    return localStorage.getItem(KEY);
  } catch {
    return null; // storage blocked: behave as if nothing was chosen
  }
}

async function reachable(url) {
  try {
    const response = await fetch(url, {
      method: "HEAD",
      credentials: "same-origin",
    });
    return response.ok;
  } catch {
    return false;
  }
}

export default class ViewChoice extends Service {
  @service router;

  @tracked current = stored();
  @tracked chooserOpen = false;
  // The view that just failed to open, so the chooser can say so and disable it.
  @tracked failed = null;

  // [{ id, url, icon }], filled by the initializer from theme settings.
  views = [];

  viewFor(id) {
    return this.views.find((v) => v.id === id);
  }

  save(id) {
    this.current = id;
    try {
      if (id) {
        localStorage.setItem(KEY, id);
      } else {
        localStorage.removeItem(KEY);
      }
    } catch {
      // storage blocked: the choice lasts until reload
    }
  }

  // A view that can't open (plugin off, no access, gone) must never trap anyone on
  // every launch: forget it and ask again.
  fail(id) {
    this.save(null);
    this.failed = id;
    this.chooserOpen = true;
  }

  async go(id) {
    const view = this.viewFor(id);
    if (!view) {
      return;
    }
    if (view.url === "/") {
      // Picked after a failure, from an error page: take them home.
      if (window.location.pathname !== getURL("/")) {
        DiscourseURL.routeTo("/");
      }
      return;
    }

    if (!(await reachable(view.url))) {
      this.fail(id);
      return;
    }

    // Dumbcourse is its own app outside Ember, so it needs a real page load.
    if (view.fullLoad) {
      window.location.replace(view.url);
      return;
    }

    // Some failures only show once Ember renders (e.g. no access to the AI bot).
    this.router.one("routeDidChange", () => {
      if (ERROR_ROUTE.test(this.router.currentRouteName)) {
        this.fail(id);
      }
    });
    DiscourseURL.routeTo(view.url, { replaceURL: true });
  }
}
