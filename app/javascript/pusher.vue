<template>
  <div id="pusher">
  </div>
</template>

<script>
import Pusher from 'pusher-js';

export default {
  props: {
    channel: {
      required: true
    },
    event: {
      required: true
    }
  },

  mounted: function() {
    if (process.env.PUSHER_LOG_TO_CONSOLE == 'true') {
      Pusher.logToConsole = true;
    }

    var pusher = new Pusher(process.env.PUSHER_KEY, {
      cluster: process.env.PUSHER_CLUSTER,
      encrypted: true
    });

    var channel = pusher.subscribe(this.channel);
    channel.bind(this.event, function(data) {
      alert(data.message);
    });
  }
}
</script>
