<script setup>
import { onMounted, ref, onUnmounted } from 'vue'
import gsap from 'gsap'
import { Server, Cloud, Code, Database, MonitorPlay, Layers } from 'lucide-vue-next'

const sectionRef = ref(null)
const titleRef = ref(null)
const textRefs = ref([])

const orbitContainerRef = ref(null)
const coreRef = ref(null)
const innerOrbitRef = ref(null)
const outerOrbitRef = ref(null)

const handleMouseMove = (e) => {
  if (!orbitContainerRef.value) return
  
  const rect = orbitContainerRef.value.getBoundingClientRect()
  const x = (e.clientX - rect.left - rect.width / 2)
  const y = (e.clientY - rect.top - rect.height / 2)

  gsap.to(coreRef.value, { x: x * 0.02, y: y * 0.02, duration: 1, ease: "power2.out" })
  gsap.to(innerOrbitRef.value, { x: x * 0.04, y: y * 0.04, duration: 1.5, ease: "power2.out" })
  gsap.to(outerOrbitRef.value, { x: x * 0.08, y: y * 0.08, duration: 2, ease: "power2.out" })
}

const handleMouseLeave = () => {
  gsap.to([coreRef.value, innerOrbitRef.value, outerOrbitRef.value], { 
    x: 0, y: 0, duration: 1.5, ease: "elastic.out(1, 0.3)" 
  })
}

onMounted(() => {
  gsap.set(titleRef.value, { y: 50, opacity: 0 })
  gsap.set(textRefs.value, { y: 50, opacity: 0 })
  gsap.set(coreRef.value, { scale: 0, opacity: 0 })
  gsap.set(innerOrbitRef.value, { scale: 0.5, opacity: 0 })
  gsap.set(outerOrbitRef.value, { scale: 0.8, opacity: 0 })

  const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        const tl = gsap.timeline()
        
        tl.to(titleRef.value, { y: 0, opacity: 1, duration: 1, ease: "power3.out" })
        tl.to(textRefs.value, { y: 0, opacity: 1, duration: 1, stagger: 0.2, ease: "power3.out" }, "-=0.6")

        tl.to(coreRef.value, { scale: 1, opacity: 1, duration: 1, ease: "back.out(1.5)" }, "-=1.2")
        tl.to(innerOrbitRef.value, { scale: 1, opacity: 1, duration: 1.2, ease: "back.out(1.2)" }, "-=0.8")
        tl.to(outerOrbitRef.value, { scale: 1, opacity: 1, duration: 1.5, ease: "back.out(1)" }, "-=1")

        observer.unobserve(entry.target)
      }
    })
  }, { threshold: 0.2 })

  if (sectionRef.value) observer.observe(sectionRef.value)
})
</script>

<template>
  <section ref="sectionRef" class="relative w-full min-h-screen flex flex-col md:flex-row items-center justify-between px-6 md:px-24 py-24 bg-anti-dark overflow-hidden">
    
    <div class="w-full md:w-1/2 z-10">
      <h2 ref="titleRef" class="text-4xl md:text-6xl font-bold mb-8 relative z-10 w-max">
        Inti Utama.
      </h2>
      
      <div class="space-y-6 relative z-10">
        <p :ref="el => textRefs[0] = el" class="text-lg md:text-xl text-gray-400 leading-relaxed font-light">
          Seorang Technology Enthusiast dengan spesialisasi Full-Stack Development. Memiliki keahlian 
          dalam menjembatani infrastruktur Cloud, Manajemen Server, dan DevOps, hingga pengembangan aplikasi Mobile serta Web.
        </p>
        <p :ref="el => textRefs[1] = el" class="text-lg md:text-xl text-gray-400 leading-relaxed font-light">
          Saya membangun solusi digital yang tangguh dari fondasi hingga antarmuka. Dengan kemahiran mengelola orkestrasi Kubernetes, infrastruktur Proxmox, dan kontainerisasi Docker, saya memastikan setiap aplikasi berjalan di atas sistem yang 
          high-available. Di sisi pengembangan, saya mengandalkan presisi Laravel dan dinamika Vue.js serta Flutter untuk menciptakan pengalaman pengguna yang mulus dan responsif.
        </p>
      </div>
    </div>

    <div 
      ref="orbitContainerRef" 
      class="hidden md:flex w-full md:w-1/2 items-center justify-center md:mt-0 relative h-[500px] z-10"
      @mousemove="handleMouseMove"
      @mouseleave="handleMouseLeave"
    >
      
      <div ref="coreRef" class="absolute flex items-center justify-center z-30">
        <div class="absolute w-24 h-24 bg-anti-light-gray/20 rounded-full blur-xl animate-pulse"></div>
        <div class="w-24 h-24 bg-anti-light-gray rounded-full flex items-center justify-center shadow-[0_0_40px_rgba(255,255,255,0.1)] border border-gray-500 relative z-10">
          <Layers class="text-white drop-shadow-[0_0_8px_rgba(255,255,255,0.5)]" size="32" />
        </div>
      </div>

      <div ref="innerOrbitRef" class="absolute flex items-center justify-center z-20">
        <div class="w-48 h-48 rounded-full border border-gray-600/50 border-dashed animate-[spin_20s_linear_infinite_reverse] relative">
          
          <div class="absolute top-[15%] left-[15%] -translate-x-1/2 -translate-y-1/2">
            <div class="orbit-icon bg-anti-dark p-3 rounded-full border border-gray-600 transition-all hover:border-white hover:shadow-[0_0_20px_rgba(255,255,255,0.3)] hover:scale-110 group animate-[spin_20s_linear_infinite]">
              <MonitorPlay class="text-gray-400 group-hover:text-white transition-colors" size="18" />
            </div>
          </div>

        </div>
      </div>

      <div ref="outerOrbitRef" class="absolute flex items-center justify-center z-10">
        <div class="w-80 h-80 rounded-full border border-anti-light-gray/40 border-dashed animate-[spin_40s_linear_infinite] relative">
          
          <div class="absolute top-0 left-1/2 -translate-x-1/2 -translate-y-1/2">
            <div class="orbit-icon bg-anti-dark p-4 rounded-full border border-gray-600 transition-all hover:border-white hover:shadow-[0_0_20px_rgba(255,255,255,0.3)] hover:scale-110 group animate-[spin_40s_linear_infinite_reverse]">
              <Server class="text-gray-400 group-hover:text-white transition-colors" size="24" />
            </div>
          </div>
          
          <div class="absolute bottom-0 left-1/2 -translate-x-1/2 translate-y-1/2">
            <div class="orbit-icon bg-anti-dark p-4 rounded-full border border-gray-600 transition-all hover:border-white hover:shadow-[0_0_20px_rgba(255,255,255,0.3)] hover:scale-110 group animate-[spin_40s_linear_infinite_reverse]">
              <Cloud class="text-gray-400 group-hover:text-white transition-colors" size="24" />
            </div>
          </div>
          
          <div class="absolute left-0 top-1/2 -translate-x-1/2 -translate-y-1/2">
            <div class="orbit-icon bg-anti-dark p-4 rounded-full border border-gray-600 transition-all hover:border-white hover:shadow-[0_0_20px_rgba(255,255,255,0.3)] hover:scale-110 group animate-[spin_40s_linear_infinite_reverse]">
              <Code class="text-gray-400 group-hover:text-white transition-colors" size="24" />
            </div>
          </div>
          
          <div class="absolute right-0 top-1/2 translate-x-1/2 -translate-y-1/2">
            <div class="orbit-icon bg-anti-dark p-4 rounded-full border border-gray-600 transition-all hover:border-white hover:shadow-[0_0_20px_rgba(255,255,255,0.3)] hover:scale-110 group animate-[spin_40s_linear_infinite_reverse]">
              <Database class="text-gray-400 group-hover:text-white transition-colors" size="24" />
            </div>
          </div>

        </div>
      </div>

    </div>
  </section>
</template>