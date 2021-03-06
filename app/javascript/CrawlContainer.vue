<template lang="pug">
.max-w-md.mx-auto.p-2.text-black
  .pb-4
    div(v-if="crawl.crawlSpots.areFetched")
      transition-group(v-if="crawl.crawlSpots.nodes.length > 0" name="crawl-spot-list")
        crawl-spot(v-for="crawlSpot in crawl.crawlSpots.nodes"
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
    token: {
      required: true
    },
    term: {
      required: true
    },
    location: {
      required: true
    },
    userUuid: {
      required: true
    }
  },

  data: function() {
    return {
      crawl: {
        token: this.token,
        term: this.term,
        location: this.location,
        crawlSpots: {
          areFetched: false
        },
      },
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

    deleteVote: function(crawlSpotId) {
      fetch('/graphql', {
        body: JSON.stringify({
          query: `
            mutation DeleteVote($crawlSpotId: ID!) {
              deleteVote(input: { crawlSpotId: $crawlSpotId }) {
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
                token
                crawlSpots {
                  areFetched
                  nodes {
                    id
                    votes {
                      totalCount
                      areAnyByCurrentUser
                    }
                    spot {
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
