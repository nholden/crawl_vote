<template lang="pug">
.max-w-md.mx-auto.p-2.text-black
  div(v-if="crawlSpotsLoaded")
    transition-group(name="crawl-spot-list")
      crawl-spot(v-for="crawlSpot in crawlSpots"
                 :key="crawlSpot.id"
                 :crawlSpot="crawlSpot"
                 v-on:vote="createCrawlSpotVote"
                 v-on:deleteVote="deleteVote")
  div(v-else)
    | Finding {{ crawl.term }} in {{ crawl.location }}
  hr
  .text-center
    .py-4
      | Invite friends to vote using token <strong>{{ crawl.token }}</strong>
    button.btn.btn--active.w-full(type="button" v-clipboard:copy="shareUrl")
      | Copy voting share link
</template>

<script>
import Pusher from 'pusher-js'
import _ from 'lodash'
import CrawlSpot from 'CrawlSpot'

export default {
  props: {
    crawlInitial: {
      required: true
    },
    userUuid: {
      required: true
    }
  },

  data: function() {
    return {
      crawl: _.cloneDeep(this.crawlInitial)
    }
  },

  computed: {
    pusherChannelName: function() { return 'crawl-' + this.crawl.token },
    crawlSpots: function() { return this.crawl.crawl_spots },
    crawlSpotsLoaded: function() { return this.crawlSpots.length > 0 },
    shareUrl: function() { return process.env.BASE_URL + '/crawls/' + this.crawl.token }
  },

  methods: {
    createCrawlSpotVote: function(id) {
      fetch('/votes', {
        body: JSON.stringify({ vote: { crawl_spot_id: id } }),
        headers: {
          'content-type': 'application/json',
          Authorization: 'Bearer ' + this.userUuid
        },
        method: 'POST'
      })
    },

    deleteVote: function(id) {
      fetch('/votes/' + id, {
        headers: {
          'content-type': 'application/json',
          Authorization: 'Bearer ' + this.userUuid
        },
        method: 'DELETE'
      })
    },

    refreshCrawl: function() {
      fetch('/crawls/' + this.crawl.token + '.json', {
        headers: {
          'content-type': 'application/json',
          Authorization: 'Bearer ' + this.userUuid
        }
      }).then((response) => {
        return response.json()
      }).then((data) => {
        this.crawl = data
      })
    }
  },

  mounted: function() {
    if (process.env.PUSHER_LOG_TO_CONSOLE == 'true') {
      Pusher.logToConsole = true
    }

    var pusher = new Pusher(process.env.PUSHER_KEY, {
      cluster: process.env.PUSHER_CLUSTER,
      encrypted: true
    })

    var channel = pusher.subscribe(this.pusherChannelName)
    channel.bind('crawl-updated', (data) => {
      this.refreshCrawl()
    })
  },

  components: {
    CrawlSpot
  }
}
</script>

<style scoped>
.crawl-spot-list-move {
  transition: transform 1s;
}
</style>
