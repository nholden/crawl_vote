import TurbolinksAdapter from 'vue-turbolinks';
import Vue from 'vue/dist/vue.esm'
import CrawlContainer from '../CrawlContainer'
import VueClipboard from 'vue-clipboard2'

Vue.use(TurbolinksAdapter)
Vue.use(VueClipboard)

document.addEventListener('turbolinks:load', () => {
  const app = new Vue({
    el: '#app',
    components: { CrawlContainer }
  })
})
