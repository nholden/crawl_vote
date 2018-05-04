<template>
  <div>
    {{ crawlSpot.spot.name }}
  </div>
</template>

<script>
export default {
  props: {
    crawlSpot: {
      required: true
    }
  }
}
</script>
