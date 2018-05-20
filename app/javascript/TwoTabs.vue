<template lang="pug">
div
  ul.list-reset.flex
    li.-mb-px.mr-1
      a.tab(href="#" v-on:click.prevent="tab = 1" :class="{ 'tab--selected': tab == 1 }")
        slot(name="firstTabTitle")
    li.-mb-px.mr-1
      a.tab(href="#" v-on:click.prevent="tab = 2" :class="{ 'tab--selected': tab == 2 }")
        slot(name="secondTabTitle")
  div.p-4.border.rounded(:class = "{ 'rounded-tl-none': tab == 1 }")
    slot(v-if="tab == 1" name="firstTabContent")
    slot(v-if="tab == 2" name="secondTabContent")
</template>

<script>
export default {
  data: function() {
    return {
      tab: 1
    }
  }
}
</script>
