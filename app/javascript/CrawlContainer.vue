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
  .flex.flex-wrap.items-center.p-4.shadow.bg-white.rounded.text-center.border
    div(class="w-full md:w-1/2 pb-6 md:pb-0")
      | Invite friends to vote using code
      .pt-2.text-lg.text-blue.tracking-wide {{ crawl.token }}
    div(class="w-full md:w-1/2")
      button.btn.btn--active.w-full(type="button" v-clipboard:copy="shareUrl" v-clipboard:success="onShareLinkCopied" v-clipboard:error="onShareLinkCopyFailed" :data-share-url="shareUrl" aria-live="polite")
        | {{ shareLinkStatus || 'Copy share link' }}
      button.btn.btn--quiet.w-full.mt-2(type="button" command="show-modal" :commandfor="shareQrId")
        | Show QR code
  dialog.share-qr(
    :id="shareQrId"
    closedby="any"
    aria-label="QR code for the share link"
    v-on:click="dismissShareQr")
    img(v-if="qrDataUrl" :src="qrDataUrl" alt="" width="480" height="480")
    p.share-qr__status.text-sm.text-red(v-else-if="qrError" role="alert") {{ qrError }}
    p.share-qr__status.text-sm.text-grey-darker(v-else) Preparing QR code…
</template>

<script>
import Pusher from 'pusher-js'
import _ from 'lodash'
import QRCode from 'qrcode/lib/browser'
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
      shareLinkStatus: null,
      shareLinkStatusTimer: null,
      qrDataUrl: null,
      qrError: null,
      qrRequest: null
    }
  },

  computed: {
    pusherChannelName: function() { return 'crawl-' + this.crawl.token },
    shareUrl: function() {
      var base = window.location.origin.replace(/\/$/, '')
      return base + '/crawls/' + this.crawl.token
    },
    shareQrId: function() { return 'share-qr-' + this.crawl.token }
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

    onShareLinkCopied: function() {
      this.showShareLinkStatus('Copied!')
    },

    onShareLinkCopyFailed: function() {
      this.showShareLinkStatus('Couldn’t copy link')
    },

    showShareLinkStatus: function(message) {
      this.shareLinkStatus = message
      clearTimeout(this.shareLinkStatusTimer)
      var self = this
      this.shareLinkStatusTimer = setTimeout(function() {
        self.shareLinkStatus = null
      }, 2000)
    },

    dismissShareQr: function(event) {
      if (event.target !== event.currentTarget) return
      event.currentTarget.close()
    },

    ensureShareQr: function() {
      if (this.qrDataUrl || this.qrRequest) return
      var self = this
      this.qrRequest = QRCode.toDataURL(this.shareUrl, {
        errorCorrectionLevel: 'M',
        margin: 2,
        width: 480,
        color: {
          dark: '#22292f',
          light: '#ffffff'
        }
      }).then(function(dataUrl) {
        self.qrDataUrl = dataUrl
        self.qrError = null
      }).catch(function() {
        self.qrRequest = null
        self.qrError = 'Couldn’t create a QR code. Copy the link instead.'
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
                      imageAttribution
                      imageAttributionUrl
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

  beforeDestroy: function() {
    clearTimeout(this.shareLinkStatusTimer)
  },

  mounted: function() {
    this.ensureShareQr()

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

.share-qr {
  width: fit-content;
  height: fit-content;
  max-width: calc(100vw - 2rem);
  max-height: calc(100vh - 2rem);
  margin: auto;
  padding: 0.75rem;
  border: none;
  border-radius: 0.25rem;
  background: #fff;
  box-shadow: 0 15px 30px rgba(0, 0, 0, 0.18);
  color: #22292f;
}

.share-qr::backdrop {
  background: rgba(34, 41, 47, 0.55);
}

.share-qr img {
  display: block;
  width: auto;
  height: auto;
  max-width: min(16rem, calc(100vw - 4rem));
  max-height: calc(100vh - 4rem);
}

.share-qr__status {
  margin: 0;
  max-width: 16rem;
}
</style>
