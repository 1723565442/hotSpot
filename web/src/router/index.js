import Vue from 'vue'
import Router from 'vue-router'
import HelloWorld from '@/components/HelloWorld'
import Login from '@/components/Login'
import Registry from '@/components/Registry'
import BookManage from '@/components/BookManage'


Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'HelloWorld',
      component: HelloWorld,
      redirect: 'BookManage',
      children: [
        {
          path: 'BookManage',
          name: 'BookManage',
          component: BookManage
        }
      ]
    },
    {
      path: '/Login',
      name: 'Login',
      component: Login
    },
    {
      path: '/Registry',
      name: 'Registry',
      component: Registry
    }
  ]
})
