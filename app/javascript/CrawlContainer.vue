<template lang="pug">
.max-w-md.mx-auto.p-2.text-black
  .pb-4
    div(v-if="crawl.spotsFetched")
      transition-group(v-if="crawl.crawlSpots.length > 0" name="crawl-spot-list")
        crawl-spot(v-for="crawlSpot in crawl.crawlSpots"
                   :key="crawlSpot.id"
                   :crawlSpot="crawlSpot"
                   v-on:vote="createCrawlSpotVote"
                   v-on:deleteVote="deleteVote")
      div(v-else)
        | Couldn’t find {{ crawl.term }} in {{ crawl.location }}
    div(v-else)
      | Finding {{ crawl.term }} in {{ crawl.location }}
  .flex.flex-wrap.p-4.shadow.bg-white.rounded.text-center.border
    div(class="w-full md:w-1/2 pb-6 md:pb-0")
      | Invite friends to vote using code
      .pt-2.text-lg.text-blue.tracking-wide {{ crawl.token }}
    button.btn.btn--active(class="w-full md:w-1/2" type="button" v-clipboard:copy="shareUrl")
      | Copy share link
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
    shareUrl: function() { return window.env.BASE_URL + '/crawls/' + this.crawl.token }
  },

  methods: {
    createCrawlSpotVote: function(crawlSpotId) {
      fetch('/graphql', {
        body: JSON.stringify({
          query: `
            mutation CreateVote($crawlSpotId: ID!) {
              createVote(input: { crawlSpotId: $crawlSpotId }) {
                id
                errors
              }
            }
          `,
          variables: { crawlSpotId: crawlSpotId }
        }),
        headers: {
          'content-type': 'application/json',
          Authorization: 'Bearer ' + this.userUuid
        },
        method: 'POST'
      })
    },

    deleteVote: function(id) {
      fetch('/graphql', {
        body: JSON.stringify({
          query: `
            mutation DeleteVote($id: ID!) {
              deleteVote(input: { id: $id }) {
                errors
              }
            }
          `,
          variables: { id: id }
        }),
        headers: {
          'content-type': 'application/json',
          Authorization: 'Bearer ' + this.userUuid
        },
        method: 'POST'
      })
    },

    refreshCrawl: function() {
      fetch('/graphql', {
        headers: {
          'content-type': 'application/json',
          Authorization: 'Bearer ' + this.userUuid
        },
        body: JSON.stringify({
          query: `
            query Crawl($token: String!) {
              crawl(token: $token) {
                term
                location
                spotsFetched
                token
                crawlSpots {
                  id
                  votesCount
                  currentUserVoteId
                  spot {
                    id
                    name
                    rating
                    reviewCount
                    url
                    imageUrl
                    address1
                    city
                    state
                  }
                }
              }
            }
          `,
          variables: {
            token: this.crawl.token
          },
        }),
        method: 'POST'
      }).then((response) => {
        return response.json()
      }).then((parsedResponse) => {
        this.crawl = parsedResponse.data.crawl
      })
    }
  },

  mounted: function() {
    if (window.env.PUSHER_LOG_TO_CONSOLE === 'true') {
      Pusher.logToConsole = true
    }

    var pusher = new Pusher(window.env.PUSHER_KEY, {
      cluster: window.env.PUSHER_CLUSTER,
      encrypted: true
    })

    var channel = pusher.subscribe(this.pusherChannelName)
    channel.bind('crawl-updated', (data) => {
      this.refreshCrawl()
    })

    this.refreshCrawl()
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
