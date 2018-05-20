import Rails from 'rails-ujs'
import Turbolinks from 'turbolinks'
import TurbolinksAdapter from 'vue-turbolinks'
import Vue from 'vue/dist/vue.esm'
import CrawlContainer from '../CrawlContainer'
import TwoTabs from '../TwoTabs'
import JoinCrawlForm from '../JoinCrawlForm'
import VueClipboard from 'vue-clipboard2'
import '../stylesheets/application.scss'

Rails.start()
Turbolinks.start()

Vue.use(TurbolinksAdapter)
Vue.use(VueClipboard)

document.addEventListener('turbolinks:load', () => {
  const app = new Vue({
    el: '#app',
    components: {
      CrawlContainer,
      TwoTabs,
      JoinCrawlForm
    }
  })
})
