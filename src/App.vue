<script setup>
import { onMounted, onUnmounted } from 'vue'
import Lenis from '@studio-freight/lenis'
import Hero from './components/Hero.vue'
import PersonalStory from './components/PersonalStory.vue'
import About from './components/About.vue'
import Portfolio from './components/Portfolio.vue'
import Contact from './components/Contact.vue'

let lenis;

onMounted(() => {
  lenis = new Lenis({
    duration: 1.2,
    easing: (t) => Math.min(1, 1.001 - Math.pow(2, -10 * t)),
    direction: 'vertical',
    gestureDirection: 'vertical',
    smooth: true,
    mouseMultiplier: 1,
    smoothTouch: false,
    touchMultiplier: 2,
    infinite: false,
  })

  function raf(time) {
    lenis.raf(time)
    requestAnimationFrame(raf)
  }

  requestAnimationFrame(raf)
})

onUnmounted(() => {
  if (lenis) {
    lenis.destroy()
  }
})
</script>

<template>
  <main class="bg-anti-black min-h-screen text-anti-white selection:bg-anti-white selection:text-anti-black">
    <Hero />
    <PersonalStory />
    <About />
    <Portfolio />
    <Contact />
  </main>
</template>

<style>
</style>
