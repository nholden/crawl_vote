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
      button.btn.btn--quiet.w-full.mt-2(type="button" v-on:click="openShareQr" aria-haspopup="dialog" :aria-controls="shareQrId" :aria-expanded="shareQrOpen ? 'true' : 'false'")
        | Show QR code
  dialog.share-qr(
    ref="shareQrDialog"
    :id="shareQrId"
    closedby="any"
    :aria-labelledby="shareQrTitleId"
    :aria-describedby="shareQrHintId"
    v-on:click="onShareQrDialogClick"
    v-on:close="onShareQrClosed")
    .share-qr__panel.bg-white.rounded.shadow-lg.p-4.text-center.border-t-4.border-blue(v-on:click.stop)
      .flex.items-center.justify-between
        h2.m-0.text-left.text-lg.font-medium.text-blue.tracking-wide(:id="shareQrTitleId") Share this crawl
        button.share-qr__close(type="button" v-on:click="closeShareQr") Close
      .pt-2.text-sm.text-grey-darker(:id="shareQrHintId") Scan this code to join the vote.
      .share-qr__code(:aria-busy="qrBusy ? 'true' : 'false'")
        img(v-if="qrDataUrl" :src="qrDataUrl" alt="QR code for the share link" width="480" height="480")
        .text-sm.text-red(v-else-if="qrError" role="alert") {{ qrError }}
        .text-sm.text-grey-darker(v-else) Preparing QR code…
      .share-qr__url.pt-3.text-xs.text-grey-darker {{ shareUrl }}
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
      shareQrOpen: false,
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
    shareQrId: function() { return 'share-qr-' + this.crawl.token },
    shareQrTitleId: function() { return 'share-qr-title-' + this.crawl.token },
    shareQrHintId: function() { return 'share-qr-hint-' + this.crawl.token },
    qrBusy: function() { return !this.qrDataUrl && !this.qrError }
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

    openShareQr: function() {
      var dialog = this.$refs.shareQrDialog
      if (!dialog) return
      this.ensureShareQr()
      if (typeof dialog.showModal === 'function') {
        if (!dialog.open) dialog.showModal()
      } else if (!dialog.hasAttribute('open')) {
        dialog.setAttribute('open', 'open')
      }
      this.shareQrOpen = true
    },

    closeShareQr: function() {
      var dialog = this.$refs.shareQrDialog
      if (!dialog) return
      if (typeof dialog.close === 'function') {
        if (dialog.open) dialog.close()
      } else {
        dialog.removeAttribute('open')
        this.shareQrOpen = false
      }
    },

    onShareQrDialogClick: function(event) {
      if (event.target !== this.$refs.shareQrDialog) return
      event.preventDefault()
      event.stopPropagation()
      this.closeShareQr()
    },

    onShareQrClosed: function() {
      this.shareQrOpen = false
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
    this.closeShareQr()
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

.share-qr {
  width: min(24rem, calc(100vw - 2rem));
  max-width: calc(100vw - 2rem);
  padding: 0;
  border: none;
  background: transparent;
  color: #22292f;
}

.share-qr::backdrop {
  background: rgba(34, 41, 47, 0.55);
}

.share-qr__panel {
  width: 100%;
}

.share-qr__close {
  border: 0;
  background: transparent;
  color: #2779bd;
  cursor: pointer;
  font-size: 0.75rem;
  letter-spacing: 0.05em;
  line-height: 1;
  min-height: 2.75rem;
  padding: 0 0.25rem;
  text-transform: uppercase;
}

.share-qr__close:hover,
.share-qr__close:focus {
  color: #1c3d5a;
}

.share-qr__code {
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 12rem;
  margin-top: 1rem;
}

.share-qr__code img {
  display: block;
  width: 16rem;
  max-width: 100%;
  height: auto;
}

.share-qr__url {
  word-break: break-all;
}
</style>
