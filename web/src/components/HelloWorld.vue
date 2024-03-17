<template>
  <div class="helloworld">
    <el-container style="margin: 0%;padding: 0">
      <el-header height="10vh" style="margin: 0; padding: 0">
        <Header></Header>
      </el-header>
      <el-main style="margin: 0; padding: 0;">
        <router-view></router-view>
      </el-main>
      <el-footer height="10vh" style="margin: 0%;padding: 0">
        <Footer></Footer>
      </el-footer>
    </el-container>
  </div>
</template>

<script>
import Header from "@/components/Header.vue";
import Footer from "@/components/Footer.vue";
export default {
  name: 'HelloWorld',
  data () {
    return {
      msg: 'Welcome to Your Vue.js App'
    }
  },
  components: {
    Header,
    Footer
    }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
.el-main {
  text-align: center;
  height: 94vh;
}

.header{
  background-color:cadetblue;
}
</style>
