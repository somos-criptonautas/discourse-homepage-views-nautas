import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { fn } from "@ember/helper";
import { on } from "@ember/modifier";
import { action } from "@ember/object";
import { service } from "@ember/service";
import icon from "discourse/helpers/d-icon";
import { i18n } from "discourse-i18n";
import { eq } from "truth-helpers";
import { themePrefix } from "virtual:theme";

const t = (key) => i18n(themePrefix(`view_chooser.${key}`));

// Full-screen "Elige tu vista" shown on first launch (see view-chooser initializer).
// Real radio inputs, so keyboard and screen readers get a native radio group; the
// selected card is styled from :has(:checked), not from JS.
export default class ViewChooser extends Component {
  @service viewChoice;
  @service siteSettings;
  @service currentUser;

  @tracked selected = this.viewChoice.current || "moderna";

  get options() {
    return this.viewChoice.views.map((view) => ({
      ...view,
      name: t(`${view.id}.name`),
      description: t(`${view.id}.description`),
    }));
  }

  get logoUrl() {
    return (
      this.siteSettings.site_logo_small_url || this.siteSettings.site_logo_url
    );
  }

  @action
  select(id) {
    this.selected = id;
  }

  @action
  submit(event) {
    event.preventDefault();
    this.viewChoice.save(this.selected);
    this.viewChoice.chooserOpen = false;
    this.viewChoice.go(this.selected);
  }

  <template>
    {{#if this.viewChoice.chooserOpen}}
      <div
        class="view-chooser"
        role="dialog"
        aria-modal="true"
        aria-labelledby="view-chooser-title"
      >
        <form class="view-chooser__panel" {{on "submit" this.submit}}>
          <header class="view-chooser__header">
            {{#if this.logoUrl}}
              <img class="view-chooser__logo" src={{this.logoUrl}} alt="" />
            {{/if}}
            <div>
              <h1 id="view-chooser-title" class="view-chooser__title">
                {{t "title"}}
              </h1>
              <p class="view-chooser__subtitle">{{t "subtitle"}}</p>
            </div>
          </header>

          <fieldset class="view-chooser__options">
            <legend class="sr-only">{{t "title"}}</legend>
            {{#each this.options as |choice|}}
              <label class="view-chooser__option">
                <input
                  class="view-chooser__radio"
                  type="radio"
                  name="view-chooser"
                  value={{choice.id}}
                  checked={{eq this.selected choice.id}}
                  {{on "change" (fn this.select choice.id)}}
                />
                <span
                  class="view-chooser__preview --{{choice.id}}"
                  aria-hidden="true"
                >
                  <span></span><span></span><span></span>
                  <span></span><span></span><span></span>
                </span>
                <span class="view-chooser__text">
                  <span class="view-chooser__name">
                    {{icon choice.icon}}
                    {{choice.name}}
                  </span>
                  <span
                    class="view-chooser__description"
                  >{{choice.description}}</span>
                </span>
                <span class="view-chooser__check" aria-hidden="true"></span>
              </label>
            {{/each}}
          </fieldset>

          <button type="submit" class="btn btn-primary view-chooser__continue">
            {{t "continue"}}
          </button>

          {{#if this.currentUser}}
            <p class="view-chooser__hint">{{t "hint"}}</p>
          {{/if}}
        </form>
      </div>
    {{/if}}
  </template>
}
