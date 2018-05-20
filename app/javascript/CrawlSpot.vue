<template lang="pug">
.py-6
  .flex.items-center
    .flex-no-shrink.w-16.text-center
      .pb-3
        .text-xl.font-medium
          | {{ votesCount }}
        .text-xs.uppercase.tracking-wide
          | {{ 'vote' | pluralize(votesCount) }}
      div
        button.py-2.px-2.rounded.font-light.bg-green.text-white.cursor-pointer.text-lg(v-if="currentUserVoted" v-on:click.prevent="deleteVote" class="hover:opacity-50")
          | ✔
        button.py-2.px-2.rounded.font-light.bg-grey.text-white.cursor-pointer.opacity-50.text-lg(v-else v-on:click.prevent="vote" class="hover:bg-green")
          | ✔
    .flex-no-shrink.pr-4
      .h-32.w-32(:style="{ 'background-image': 'url(' + spot.image_url + ')' }"
                 style="background-repeat: no-repeat; background-position: 50% 50%; background-size: cover;")
    .flex-grow
      .font-medium.text-blue.uppercase.tracking-wide.pb-1 {{ spot.name }}
      .text-sm.pb-2 {{ address }}
      .flex.flex-wrap.items-center.justify-center
        div
          a(:href="spot.url" target="_blank")
            img.inline-block.align-middle(src="./images/yelp_logo.png" width="106" height="68")
        .text-center
          .pb-1: img.inline-block.align-middle(:src="yelpStarsPath" width="132" height="24")
          .text-sm.text-grey-darker Based on {{ spot.review_count }} reviews
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
      currentUserVoted: !!(this.crawlSpot.current_user_vote),
      votesCount: this.crawlSpot.votes_count
    }
  },

  watch: {
    crawlSpot: function() {
      this.currentUserVoted = !!(this.crawlSpot.current_user_vote)
      this.votesCount = this.crawlSpot.votes_count
    }
  },

  methods: {
    vote: function() {
      this.$emit('vote', this.crawlSpot.id)
      this.currentUserVoted = true
      this.votesCount += 1
    },

    deleteVote: function() {
      this.$emit('deleteVote', this.crawlSpot.current_user_vote.id)
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
