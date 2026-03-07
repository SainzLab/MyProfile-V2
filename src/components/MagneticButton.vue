<script setup>
import { ref, onMounted, onUnmounted } from 'vue'
import gsap from 'gsap'

const buttonRef = ref(null)
const textRef = ref(null)

let hoverActive = false

const handleMouseMove = (e) => {
  if (!buttonRef.value || !hoverActive) return
  
  const rect = buttonRef.value.getBoundingClientRect()
  const x = (e.clientX - rect.left - rect.width / 2) * 0.4
  const y = (e.clientY - rect.top - rect.height / 2) * 0.4
  
  gsap.to(buttonRef.value, { x, y, duration: 0.6, ease: "power3.out" })
  gsap.to(textRef.value, { x: x * 0.5, y: y * 0.5, duration: 0.6, ease: "power3.out" })
}

const handleMouseEnter = () => {
  hoverActive = true
}

const handleMouseLeave = () => {
  hoverActive = false
  gsap.to(buttonRef.value, { x: 0, y: 0, duration: 0.8, ease: "elastic.out(1, 0.3)" })
  gsap.to(textRef.value, { x: 0, y: 0, duration: 0.8, ease: "elastic.out(1, 0.3)" })
}
</script>

<template>
  <div class="inline-block p-4" @mousemove="handleMouseMove" @mouseenter="handleMouseEnter" @mouseleave="handleMouseLeave">
    <button ref="buttonRef" class="relative px-8 py-4 bg-transparent border border-anti-light-gray rounded-full text-anti-white overflow-hidden group hover:border-anti-white transition-colors duration-300">
      <!-- Glow effect on hover -->
      <div class="absolute inset-0 bg-white opacity-0 group-hover:opacity-5 transition-opacity duration-300"></div>
      <span ref="textRef" class="relative z-10 block font-medium tracking-wide">
        <slot></slot>
      </span>
    </button>
  </div>
</template>
