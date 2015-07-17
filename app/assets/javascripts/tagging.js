(function() {
  "use strict";
  window.Hacks = window.Hacks || {};

  function SuggestedTags(options) {
    this.$el = options.$el;
    this.$inputEl = options.$inputEl;

    this.bindEvents();
  }

  SuggestedTags.prototype.bindEvents = function bindEvents() {
    this.$el.find('li .tag').on('click', $.proxy(this.insertTag, this));
  }

  SuggestedTags.prototype.insertTag = function insertTag(event) {
    var $item = $(event.target);
    var newValue = this.$inputEl.val();

    if (newValue.length > 0) {
      newValue += " "
    }
    newValue += $item.text();

    this.$inputEl.val(newValue);
    $item.parent('li').remove();
  }

  Hacks.SuggestedTags = SuggestedTags;
}());
