
<template>
  <div class="wrapper" @click="onWrapperClick">
    <span class="content" @click="onContentClick">This is a test text.</span>
    <sub-title />
  </div>
</template>

<script>
import SubTitle from './subtitle';
export default {
  components: {  SubTitle },
  data: () => ({

  }),
  methods: {
    onWrapperClick() {
      console.log('---click the wrapper---')
    },
    onContentClick() {
      console.log('---click the content---')
    }
  }
}
</script>
<style lang="less" scoped>

</style>
