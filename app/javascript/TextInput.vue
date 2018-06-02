<template lang="pug">
  input(type="text" :value="value" v-on:input="updateValue")
</template>

<script>
export default {
  props: {
    value: {
      required: true
    },
    required: {
      default: false
    },
  },

  computed: {
    valid() { return !this.required || !!this.value },
  },

  mounted: function() { this.updateValidity() },

  watch: {
    value() { this.updateValidity() }
  },

  methods: {
    updateValue(e) { this.$emit('input', e.target.value) },
    updateValidity() { this.$emit('update-validity', this.valid) }
  }
}
</script>
