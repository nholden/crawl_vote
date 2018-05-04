<template>
  <div>
    {{ crawlSpot.spot.name }}
    <a href="#" v-on:click.prevent="vote">Vote</a>
  </div>
</template>

<script>
export default {
  props: {
    crawlSpot: {
      required: true
    }
  },

  methods: {
    vote: function() { this.$emit('vote', this.crawlSpot.id) }
  }
}
</script>
