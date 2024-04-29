<template>
  <v-main>  
  </v-main>
</template>

<script>
// import FeatureCards from '@/components/layout/FeatureCards'
// import TheTopBanner from '@/components/layout/TheTopBanner'
// import TheBottomBanner from '@/components/layout/TheBottomBanner'

export default {
  components: {
    // FeatureCards,
    // TheTopBanner,
    // TheBottomBanner
  },
  mounted() {
   // 打开projects页面localePath('/zh/projects')
   window.open(this.localePath('/projects'), '_self')
  }
}
</script>
