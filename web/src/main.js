import Vue from 'vue'
import App from './App'
import router from './router'
import ElementUI from 'element-ui'
import 'element-ui/lib/theme-chalk/index.css';
import axios from 'axios'
import store from './store'  

Vue.use(ElementUI)
Vue.config.productionTip = false
Vue.prototype.$http = axios

router.beforeEach((to, from, next) => {
  const isAuthenticated = store.getters.isAuthenticated;
  if (to.path !== '/Login' && !isAuthenticated && to.path !== '/Registry') {
    next('/Login');
  } else {
    next(); 
  }
});

new Vue({
  el: '#app',
  router,
  store,  
  components: { App },
  template: '<App/>'
});
