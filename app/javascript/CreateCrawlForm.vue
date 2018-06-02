<template lang="pug">
form(v-on:submit.prevent="createCrawl")
  .pb-4
    label.block.pb-1.font-medium.text-sm.text-blue-light.uppercase.tracking-wide(for="term")
      | Find
    text-input.shadow.appearance-none.border.rounded.w-full.py-2.px-3(
      v-model="fields.term.value"
      v-on:update-validity="fields.term.valid = $event"
      :required="true"
      :class="{ 'border-red': hasValidationError(fields.term) }"
      id="term"
      type="text"
      placeholder="e.g. tacos"
    )
    .pt-1.text-sm.text-red(v-if="hasValidationError(fields.term)")
      | A search term is required (try "tacos").
  .pb-4
    label.block.pb-1.font-medium.text-sm.text-blue-light.uppercase.tracking-wide(for="location")
      | Near
    text-input.shadow.appearance-none.border.rounded.w-full.py-2.px-3(
      v-model="fields.location.value"
      v-on:update-validity="fields.location.valid = $event"
      :required="true"
      :class="{ 'border-red': hasValidationError(fields.location) }"
      id="location"
      type="text"
      placeholder="e.g. Barrio Logan, San Diego"
    )
    .pt-1.text-sm.text-red(v-if="hasValidationError(fields.location)")
      | A location is required (try "Barrio Logan, San Diego").
  .pt-2
    input.btn.btn--active.w-full(type="submit" value="Create Crawl")
</template>

<script>
import _ from 'lodash'
import TextInput from 'TextInput'

export default {
  data: function() {
    return {
      fields: {
        term: {
          value: null,
          valid: null,
        },
        location: {
          value: null,
          valid: null,
        },
      },
      validateFields: false,
    }
  },

  computed: {
    valid() { return !_.some(this.fields, function(field) { return !field.valid }) }
  },

  methods: {
    createCrawl() {
      if (this.valid) {
        fetch('/crawls', {
          body: JSON.stringify({ crawl: _.mapValues(this.fields, function(field) { return field.value }) }),
          headers: { 'content-type': 'application/json' },
          method: 'POST'
        }).then((response) => {
          return response.json()
        }).then((data) => {
          window.location.href = '/crawls/' + data.token
        })
      } else {
        this.validateFields = true
      }
    },
    hasValidationError(field) { return this.validateFields && !field.valid },
  },

  components: {
    TextInput,
  }
}
</script>
