import Component from "@glimmer/component";
import { on } from "@ember/modifier";
import { action } from "@ember/object";
import { service } from "@ember/service";
import { i18n } from "discourse-i18n";
import { eq } from "truth-helpers";
import { themePrefix } from "virtual:theme";

const t = (key) => i18n(themePrefix(`view_chooser.${key}`));

// "Vista" select in Preferences → Interface. Saves on change, like core's per-device
// interface options, and never navigates: the new view applies on the next launch.
export default class ViewPreference extends Component {
  @service viewChoice;

  get options() {
    return this.viewChoice.views.map((view) => ({
      id: view.id,
      name: t(`${view.id}.name`),
    }));
  }

  get current() {
    return this.viewChoice.current || "moderna";
  }

  @action
  change(event) {
    this.viewChoice.save(event.target.value);
  }

  <template>
    <div class="control-group view-preference">
      <label class="control-label" for="view-preference">
        {{t "preference"}}
      </label>
      <div class="controls">
        <select id="view-preference" {{on "change" this.change}}>
          {{#each this.options as |view|}}
            <option
              value={{view.id}}
              selected={{eq this.current view.id}}
            >{{view.name}}</option>
          {{/each}}
        </select>
      </div>
      <div class="instructions">{{t "preference_instructions"}}</div>
    </div>
  </template>
}
