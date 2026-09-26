import { tracked } from "@glimmer/tracking";
import Service from "@ember/service";
import DiscourseURL from "discourse/lib/url";

// Which view (ligera / moderna / anonist) opens when the community is launched at `/`.
// Stored per device, like core's own interface choices: the app is one device, and
// anonymous visitors have no profile to hold it.
// ponytail: per-device only; sync through a user field if people ask for it across devices.
const KEY = "horizonView";

function stored() {
  try {
    return localStorage.getItem(KEY);
  } catch {
    return null; // storage blocked: behave as if nothing was chosen
  }
}

export default class ViewChoice extends Service {
  @tracked current = stored();
  @tracked chooserOpen = false;

  // [{ id, url, icon }], filled by the initializer from theme settings.
  views = [];

  viewFor(id) {
    return this.views.find((v) => v.id === id);
  }

  save(id) {
    this.current = id;
    try {
      localStorage.setItem(KEY, id);
    } catch {
      // storage blocked: the choice lasts until reload
    }
  }

  go(id) {
    const view = this.viewFor(id);
    if (!view?.url || view.url === "/") {
      return;
    }
    // Dumbcourse is its own app outside Ember, so it needs a real page load.
    if (view.fullLoad) {
      window.location.replace(view.url);
    } else {
      DiscourseURL.routeTo(view.url, { replaceURL: true });
    }
  }
}
