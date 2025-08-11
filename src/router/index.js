// src/router/index.js
import { createRouter, createWebHistory } from 'vue-router'
import ListeJoueurs from '@/views/ListeJoueur.vue'
import InsertionJoueur from '@/views/InsertionJoueur.vue'
import ListeSeance from '@/views/ListeSeance.vue'
import InsertionSeance from '@/views/InsertionSeance.vue'
import ListePresence from '@/views/ListePresence.vue'
import ListeMatch from '@/views/ListeMatch.vue'
import ListeComposition from '@/views/ListeComposition.vue'

const routes = [
  {
    path: '/',
    name: 'liste',
    component: ListeJoueurs
  },
  {
    path: '/insertion',
    name: 'insertion',
    component: InsertionJoueur
  },
  {
    path: '/liste-seance',
    name: 'listeSeance',
    component: ListeSeance
  },
  {
    path: '/insertion-seance',
    name: 'insertionSeance',
    component: InsertionSeance
  },
  {
    path:'/presence',
    name:'ListePresence',
    component:ListePresence
  },
  {
    path:'/match',
    name:'listeMatch',
    component:ListeMatch
  },
  {path: '/composition',
  name:'listeComposition',
  component:ListeComposition
  }
]

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes
})

export default router