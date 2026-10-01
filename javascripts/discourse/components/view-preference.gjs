import Component from "@glimmer/component";
import { action } from "@ember/object";
import { service } from "@ember/service";
import { i18n } from "discourse-i18n";
import ComboBox from "select-kit/components/combo-box";
import { themePrefix } from "virtual:theme";

const t = (key) => i18n(themePrefix(`view_chooser.${key}`));

// "Vista" dropdown in Preferences → Interface, using core's ComboBox so it matches the
// other options on that page. Saves on change, like core's per-device interface
// options, and never navigates: the new view applies on the next launch.
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
  change(id) {
    this.viewChoice.save(id);
  }

  <template>
    <div class="control-group view-preference">
      <label class="control-label">{{t "preference"}}</label>
      <div class="controls">
        <ComboBox
          @content={{this.options}}
          @value={{this.current}}
          @onChange={{this.change}}
          class="view-preference__select"
        />
      </div>
      <div class="instructions">{{t "preference_instructions"}}</div>
    </div>
  </template>
}
