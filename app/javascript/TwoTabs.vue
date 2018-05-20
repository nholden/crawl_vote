<template lang="pug">
div
  ul.list-reset.flex.border-b
    li.-mb-px.mr-1
      a.tab(href="#" v-on:click.prevent="tab = 1" :class="{ 'tab--selected': tab == 1 }")
        slot(name="firstTabTitle")
    li.-mb-px.mr-1
      a.tab(href="#" v-on:click.prevent="tab = 2" :class="{ 'tab--selected': tab == 2 }")
        slot(name="secondTabTitle")
  div.pt-4(v-show="tab == 1")
    slot(name="firstTabContent")
  div.pt-4(v-show="tab == 2")
    slot(name="secondTabContent")
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
