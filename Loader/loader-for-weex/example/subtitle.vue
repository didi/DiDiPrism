<template>
  <div @click="onClick">This is a subtitle.</div>
</template>
<script>
export default {
  data: () => ({

  }),
  methods: {
    onClick() {
      console.log('---click the subtitle---')
    }
  }
}
</script>
<style lang="less" scoped>

</style>
