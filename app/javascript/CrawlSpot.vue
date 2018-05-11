<template lang="pug">
div
  | {{ crawlSpot.spot.name }} ({{ voteCount }} {{ 'vote' | pluralize(voteCount) }})
  |
  span(v-if="currentUserVoted") Voted
  span(v-else): a(href="#" v-on:click.prevent="vote") Vote
</template>

<script>
export default {
  props: {
    crawlSpot: {
      required: true
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

  filters: {
    pluralize: function(name, count) {
      if (count === 1) {
        return name
      } else {
        return name + 's'
      }
    }
  }
}
</script>
