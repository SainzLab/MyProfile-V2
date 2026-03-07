<script setup>
import { onMounted, ref, onUnmounted } from 'vue'
import gsap from 'gsap'
import MagneticButton from './MagneticButton.vue'

const containerRef = ref(null)
const titleRef = ref(null)
const shapesRef = ref([])
const bgWrapperRef = ref(null)

const floatingElements = [
  { id: 1, type: 'text', content: '</>', class: 'text-4xl md:text-5xl text-gray-700/30 font-mono top-[10%] left-[5%] md:top-[15%] md:left-[10%]' },
  { id: 2, type: 'shape', class: 'w-32 h-32 md:w-48 md:h-48 border border-gray-800/50 rounded-lg rotate-12 top-[65%] right-[5%] md:top-[60%] md:right-[10%]' },
  { id: 3, type: 'text', content: '{  }', class: 'text-5xl md:text-7xl text-gray-800/30 font-mono top-[15%] right-[10%] md:top-[20%] md:right-[25%]' },
  { id: 4, type: 'text', content: 'sudo', class: 'text-2xl md:text-3xl text-gray-600/20 font-mono bottom-[10%] left-[10%] md:bottom-[15%] md:left-[20%]' },
  { id: 5, type: 'text', content: '10101', class: 'text-lg md:text-xl text-gray-500/20 font-mono top-[40%] left-[2%] md:left-[5%] rotate-90' },
  { id: 6, type: 'shape', class: 'w-16 h-16 md:w-24 md:h-24 border border-gray-600/30 rounded-full bottom-[20%] right-[20%] md:bottom-[30%] md:right-[30%]' },
  { id: 7, type: 'text', content: '~/', class: 'text-3xl md:text-4xl text-gray-700/30 font-mono top-[85%] right-[30%] md:top-[80%] md:right-[45%]' }
]

const handleMouseMove = (e) => {
  if (!bgWrapperRef.value) return
  const x = (e.clientX / window.innerWidth - 0.5) * 40
  const y = (e.clientY / window.innerHeight - 0.5) * 40
  gsap.to(bgWrapperRef.value, { x: -x, y: -y, duration: 1.5, ease: "power2.out" })
}

onMounted(() => {
  gsap.fromTo(titleRef.value.children, 
    { y: 100, opacity: 0 },
    { y: 0, opacity: 1, duration: 1.5, stagger: 0.2, ease: "power4.out", delay: 0.2 }
  )

  shapesRef.value.forEach((shape, index) => {
    gsap.to(shape, {
      y: `+=${Math.random() * 40 + 30}`,
      x: `+=${Math.random() * 30 - 15}`,
      rotation: `+=${Math.random() * 45}`,
      duration: Math.random() * 5 + 5,
      repeat: -1, yoyo: true, ease: "sine.inOut", delay: index * 0.3
    })
  })
  window.addEventListener('mousemove', handleMouseMove)
})

onUnmounted(() => window.removeEventListener('mousemove', handleMouseMove))
</script>

<template>
  <section ref="containerRef" class="relative w-full h-screen flex flex-col items-center justify-center overflow-hidden bg-transparent">
    <div class="absolute inset-0 pointer-events-none overflow-hidden z-0" style="mask-image: linear-gradient(to bottom, black 70%, transparent 100%); -webkit-mask-image: linear-gradient(to bottom, black 70%, transparent 100%);">
      <div class="absolute top-[-20%] left-[-10%] w-[50vw] h-[50vw] bg-white/5 blur-[120px] rounded-full mix-blend-screen"></div>
      <div class="absolute bottom-[-20%] right-[-10%] w-[40vw] h-[40vw] bg-gray-800/40 blur-[100px] rounded-full mix-blend-screen"></div>
    </div>

    <div ref="bgWrapperRef" class="absolute inset-0 pointer-events-none z-0" style="mask-image: linear-gradient(to bottom, black 80%, transparent 100%); -webkit-mask-image: linear-gradient(to bottom, black 80%, transparent 100%);">
      <div v-for="(item, index) in floatingElements" :key="item.id" :class="['absolute select-none', item.class]" :ref="el => { if (el) shapesRef[index] = el }">
        <template v-if="item.type === 'text'">{{ item.content }}</template>
      </div>
    </div>

    <div class="relative z-10 text-center px-6 max-w-5xl">
      <h1 ref="titleRef" class="text-4xl sm:text-5xl md:text-7xl lg:text-8xl font-bold leading-tight tracking-tighter mb-8">
        <span class="block overflow-hidden"><span class="block text-white">Merekayasa</span></span>
        <span class="block overflow-hidden"><span class="block text-gray-400">Sistem Teknologi</span></span>
        <span class="block overflow-hidden text-2xl md:text-4xl mt-6 font-normal tracking-wide text-gray-300">Dari Bare Metal hingga Piksel.</span>
      </h1>
      <div class="mt-12 opacity-0 flex flex-col sm:flex-row justify-center gap-6" style="animation: fade-in 1s ease-out 1.5s forwards;">
        <MagneticButton><span class="px-6 py-3 block text-white bg-white/5 border border-white/10 rounded-full">Lihat Karya</span></MagneticButton>
        <MagneticButton><span class="px-6 py-3 block text-gray-300">Hubungi Saya</span></MagneticButton>
      </div>
    </div>
  </section>
</template>

<style scoped>
@keyframes fade-in { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
</style>