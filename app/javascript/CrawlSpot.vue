<template lang="pug">
.py-4
  .flex.flex-wrap.items-stretch.shadow-md.bg-white.border-t-4.border-blue(class="rounded-b md:rounded-bl-none")
    div(class="w-1/2 md:w-1/3")
      .h-full(v-if="spot.imageUrl" :style="imageStyle" style="position: relative; min-height: 8rem;")
        a(v-if="spot.imageAttribution" :href="spot.imageAttributionUrl || spot.url" target="_blank" rel="noopener noreferrer" style="position: absolute; left: 0; right: 0; bottom: 0; padding: 2px 6px; font-size: 11px; line-height: 1.2; background: rgba(255,255,255,0.92); color: #1F1F1F; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;")
          | {{ spot.imageAttribution }}
      .h-full(v-else style="min-height: 8rem; background: #f5f5f5;")
    .p-4.pb-0(class="w-1/2")
      .font-medium.text-blue.uppercase.tracking-wide.pb-1(class="text-sm md:text-base")
        | {{ spot.name }}
      .text-sm.pb-2 {{ address }}
      .text-center
        .pb-1(v-if="spot.rating != null" :aria-label="'Rated ' + spot.rating + ' out of 5'" style="position: relative; display: inline-block; font-size: 18px; line-height: 1; letter-spacing: 2px;")
          span(aria-hidden="true" style="color: #e0e0e0;") ★★★★★
          span(aria-hidden="true" :style="filledStarsStyle") ★★★★★
        .text-sm.text-grey-darker(v-if="spot.reviewCount != null") Based on {{ spot.reviewCount }} reviews
        .pt-2
          a.inline-block.font-sans.font-normal.text-xs.text-grey-darker.tracking-normal.whitespace-no-wrap.no-underline(:href="spot.url" target="_blank" rel="noopener noreferrer" translate="no") Google Maps
    .flex.flex-wrap.pr-4.text-center(class="w-full md:w-1/6 pt-4 md:pt-0 my-0 md:my-6")
      .pb-3(class="w-1/3 md:w-full")
        .text-xl.font-medium
          | {{ votesCount }}
        .text-xs.uppercase.tracking-wide
          | {{ 'vote' | pluralize(votesCount) }}
      div(class="w-2/3 md:w-full")
        button.w-full.py-2.px-2.rounded.font-light.bg-green.text-white.cursor-pointer.text-lg(v-if="currentUserVoted" v-on:click.prevent="deleteVote" class="hover:opacity-50")
          | ✔
        button.w-full.py-2.px-2.rounded.font-light.bg-grey.text-white.cursor-pointer.opacity-50.text-lg(v-else v-on:click.prevent="vote" class="hover:bg-green")
          | ✔
</template>

<script>
import _ from 'lodash'

export default {
  props: {
    crawlSpot: {
      required: true
    }
  },

  computed: {
    spot: function() { return this.crawlSpot.spot },
    address: function() {
      return _.join(_.compact([this.spot.address1, this.spot.city, this.spot.state]), ', ')
    },
    imageStyle: function() {
      var url = String(this.spot.imageUrl).replace(/\\/g, '%5C').replace(/"/g, '%22')
      return {
        backgroundImage: 'url("' + url + '")',
        backgroundRepeat: 'no-repeat',
        backgroundPosition: '50% 50%',
        backgroundSize: 'cover'
      }
    },
    filledStarsStyle: function() {
      var percent = Math.min(Math.max(Number(this.spot.rating) / 5, 0), 1) * 100
      return {
        position: 'absolute',
        left: '0',
        top: '0',
        overflow: 'hidden',
        whiteSpace: 'nowrap',
        width: percent + '%',
        color: '#fbbc04'
      }
    }
  },

  data: function() {
    return {
      currentUserVoted: this.crawlSpot.votes.areAnyByCurrentUser,
      votesCount: this.crawlSpot.votes.totalCount
    }
  },

  watch: {
    crawlSpot: function() {
      this.currentUserVoted = this.crawlSpot.votes.areAnyByCurrentUser
      this.votesCount = this.crawlSpot.votes.totalCount
    }
  },

  methods: {
    vote: function() {
      this.$emit('vote', this.crawlSpot.id)
      this.currentUserVoted = true
      this.votesCount += 1
    },

    deleteVote: function() {
      this.$emit('deleteVote', this.crawlSpot.id)
      this.currentUserVoted = false
      this.votesCount -= 1
    }
  },

  filters: {
    pluralize: function(word, count) {
      if (count == 1) {
        return word
      } else {
        return word + 's'
      }
    }
  }
}
</script>
