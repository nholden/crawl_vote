<template lang="pug">
.py-4
  .flex.flex-wrap.items-stretch.shadow-md.bg-white.border-t-4.border-blue(class="rounded-b md:rounded-bl-none")
    div(class="w-1/2 md:w-1/3")
      .h-full(:style="{ 'background-image': 'url(' + spot.imageUrl + ')' }"
                 style="background-repeat: no-repeat; background-position: 50% 50%; background-size: cover;")
    .p-4.pb-0(class="w-1/2")
      .font-medium.text-blue.uppercase.tracking-wide.pb-1(class="text-sm md:text-base")
        | {{ spot.name }}
      .text-sm.pb-2 {{ address }}
      .flex.flex-wrap.items-center.justify-center
        div
          a(:href="spot.url" target="_blank")
            img.inline-block.align-middle(src="./images/yelp_logo.png" width="106" height="68")
        .text-center
          .pb-1: img.inline-block.align-middle(:src="yelpStarsPath" width="132" height="24")
          .text-sm.text-grey-darker Based on {{ spot.reviewCount }} reviews
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
const yelpStarsContextModule = require.context('./images/yelp_stars', true, /\.png$/)

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
    yelpStarsPath: function() {
      return yelpStarsContextModule('./' + this.spot.rating.toString().replace('.', '_') + '.png')
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
