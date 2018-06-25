<template lang="pug">
form(v-on:submit.prevent="joinCrawl")
  .pb-4
    label.block.pb-1.font-medium.text-sm.text-blue-light.uppercase.tracking-wide(for="token") Code
    input.shadow.appearance-none.border.rounded.w-full.py-2.px-3(
      type="text"
      id="token"
      v-model="token"
      :class="{ 'border-red': tokenNotFound }")
    .pt-1.text-sm.text-red(v-if="tokenNotFound")
      | Couldn’t find a crawl with that token. Check your spelling and try again.
  .pt-2
    input.btn.btn--active.w-full(type="submit" value="Join Crawl")
</template>

<script>
export default {
  data: function() {
    return {
      token: '',
      tokenNotFound: false,
    }
  },

  methods: {
    joinCrawl: function() {
      var url = '/crawls/' + this.token.toLowerCase()

      fetch(url).then((response) => {
        if(response.ok) {
          this.tokenNotFound = false
          return window.location.href = url
        }
        throw new Error('Network response was not ok.')
      }).catch((error) => {
        this.tokenNotFound = true
      })
    }
  }
}
</script>
