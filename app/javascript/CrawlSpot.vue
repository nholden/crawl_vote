<template lang="pug">
.py-4
  .flex.items-center
    .pr-2
     | {{ voteCount }}
    .pr-2
      img(:src="spot.image_url" width="auto" height="auto" style="max-width: 100px;")
    div
      .font-medium.text-blue.text-lg.uppercase.tracking-wide.pb-2 {{ spot.name }}
      .pb-1 {{ address }}
      .flex.items-center
        .pr-2
          .pb-1: img.inline-block.align-middle(:src="yelpStarsPath" width="auto" height="24")
          .text-sm.text-grey-darker Based on {{ spot.review_count }} reviews
        div
          a(:href="spot.url" target="_blank")
            img.inline-block.align-middle(src="./images/yelp_logo.png" width="auto" height="68")
  .py-1
    button.btn.btn--disabled(v-if="currentUserVoted" disabled)
      | Voted
    button.btn.btn--active(v-else v-on:click.prevent="vote")
      | Vote
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
      currentUserVoted: this.crawlSpot.current_user_vote_count > 0,
      voteCount: this.crawlSpot.vote_count
    }
  },

  watch: {
    crawlSpot: function() {
      this.currentUserVoted = this.crawlSpot.current_user_vote_count > 0
      this.voteCount = this.crawlSpot.vote_count
    }
  },

  methods: {
    vote: function() {
      this.$emit('vote', this.crawlSpot.id)
      this.currentUserVoted = true
      this.voteCount += 1
    }
  },
}
</script>
