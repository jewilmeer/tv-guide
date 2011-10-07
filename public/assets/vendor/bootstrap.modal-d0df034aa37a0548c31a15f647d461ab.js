/* =========================================================
 * bootstrap-modal.js v1.3.0
 * http://twitter.github.com/bootstrap/javascript.html#modal
 * =========================================================
 * Copyright 2011 Twitter, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ========================================================= */
!function(a){function d(c){var d=this,e=this.$element.hasClass("fade")?"fade":"";if(this.isShown&&this.settings.backdrop){var f=a.support.transition&&e;this.$backdrop=a('<div class="modal-backdrop '+e+'" />').appendTo(document.body),this.settings.backdrop!="static"&&this.$backdrop.click(a.proxy(this.hide,this)),f&&d.$backdrop[0].offsetWidth,d.$backdrop&&d.$backdrop.addClass("in"),f?d.$backdrop.one(b,c):c()}else if(!this.isShown&&this.$backdrop){this.$backdrop.removeClass("in");function g(){d.$backdrop.remove(),d.$backdrop=null}a.support.transition&&this.$element.hasClass("fade")?this.$backdrop.one(b,g):g()}else c&&c()}function e(){var b=this;this.isShown&&this.settings.keyboard?a(document).bind("keyup.modal",function(a){a.which==27&&b.hide()}):this.isShown||a(document).unbind("keyup.modal")}var b;a(document).ready(function(){a.support.transition=function(){var a=document.body||document.documentElement,b=a.style,c=b.transition!==undefined||b.WebkitTransition!==undefined||b.MozTransition!==undefined||b.MsTransition!==undefined||b.OTransition!==undefined;return c}(),a.support.transition&&(b="TransitionEnd",a.browser.webkit?b="webkitTransitionEnd":a.browser.mozilla?b="transitionend":a.browser.opera&&(b="oTransitionEnd"))});var c=function(b,c){return this.settings=a.extend({},a.fn.modal.defaults),this.$element=a(b).delegate(".close","click.modal",a.proxy(this.hide,this)),c&&(a.extend(this.settings,c),c.show&&this.show()),this};c.prototype={toggle:function(){return this[this.isShown?"hide":"show"]()},show:function(){var b=this;return this.isShown=!0,this.$element.trigger("show"),e.call(this),d.call(this,function(){b.$element.appendTo(document.body).show(),a.support.transition&&b.$element.hasClass("fade")&&b.$backdrop[0].offsetWidth,b.$element.addClass("in").trigger("shown")}),this},hide:function(c){function g(){f.$element.hide().trigger("hidden"),d.call(f)}c&&c.preventDefault();var f=this;return this.isShown=!1,e.call(this),this.$element.trigger("hide").removeClass("in"),a.support.transition&&this.$element.hasClass("fade")?this.$element.one(b,g):g(),this}},a.fn.modal=function(b){var d=this.data("modal");return d?b===!0?d:(typeof b=="string"?d[b]():d&&d.toggle(),this):(typeof b=="string"&&(b={show:/show|toggle/.test(b)}),this.each(function(){a(this).data("modal",new c(this,b))}))},a.fn.modal.Modal=c,a.fn.modal.defaults={backdrop:!1,keyboard:!1,show:!0},a(document).ready(function(){a("body").delegate("[data-controls-modal]","click",function(b){b.preventDefault();var c=a(this).data("show",!0);a("#"+c.attr("data-controls-modal")).modal(c.data())})})}(window.jQuery||window.ender)