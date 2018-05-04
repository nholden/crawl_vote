<template>
  <div>
    <div v-if="crawlSpotsLoaded">
      <crawl-spot v-for="crawlSpot in crawlSpots" :key="crawlSpot.id" :crawlSpot="crawlSpot" />
    </div>
    <div v-else>
      Finding {{ crawl.term }} in {{ crawl.location }}
    </div>
  </div>
</template>

<script>
import Pusher from 'pusher-js';
import _ from 'lodash';
import CrawlSpot from 'CrawlSpot'

export default {
  props: {
    crawlInitial: {
      required: true
    }
  },

  data: function() {
    return {
      crawl: _.cloneDeep(this.crawlInitial)
    }
  },

  computed: {
    pusherChannelName: function() { return 'crawl-' + this.crawl.id },
    crawlSpots: function() { return this.crawl.crawl_spots },
    crawlSpotsLoaded: function() { return this.crawlSpots.length > 0 },
  },

  mounted: function() {
    if (process.env.PUSHER_LOG_TO_CONSOLE == 'true') {
      Pusher.logToConsole = true;
    }

    var pusher = new Pusher(process.env.PUSHER_KEY, {
      cluster: process.env.PUSHER_CLUSTER,
      encrypted: true
    });

    var channel = pusher.subscribe(this.pusherChannelName);
    channel.bind('crawl-updated', (data) => {
      this.crawl = JSON.parse(data.message);
    });
  },

  components: {
    CrawlSpot
  }
}
</script>
