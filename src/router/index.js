import Vue from 'vue'
import Router from 'vue-router'
import Home from '@/components/Home'
import Future from '@/components/Future'


Vue.use(Router)


export default new Router({
  routes: [
    {
      path: '/',
      name: 'Home',
      component: Home
    },
    {
      path: '/future',
      name: 'future',
      component: Future
    }
  ]
})
