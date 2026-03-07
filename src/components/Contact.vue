<script setup>
import { onMounted, onUnmounted, ref, nextTick } from 'vue'
import MagneticButton from './MagneticButton.vue'

const canvasRef = ref(null)
const contentRef = ref(null)

let particles = []
let animationFrameId
let mouse = { x: -1000, y: -1000 }
let isHoveringContent = false 

class Particle {
  constructor(destX, destY, canvasWidth, canvasHeight) {
    this.destX = destX 
    this.destY = destY
    this.x = Math.random() * canvasWidth
    this.y = Math.random() * canvasHeight
    this.wanderVx = (Math.random() - 0.5) * 2
    this.wanderVy = (Math.random() - 0.5) * 2
    
    this.vx = 0
    this.vy = 0
    this.size = Math.random() * 1.5 + 0.5
    this.color = 'rgba(136, 208, 209, 0.8)' 
    this.friction = 0.92
    this.spring = 0.006
  }

  update(canvasWidth, canvasHeight) {
    if (isHoveringContent) {
      let dx = this.destX - this.x
      let dy = this.destY - this.y
      
      this.vx += dx * this.spring
      this.vy += dy * this.spring

      let mdx = mouse.x - this.x
      let mdy = mouse.y - this.y
      let dist = Math.sqrt(mdx * mdx + mdy * mdy)
      let minDist = 120

      if (dist < minDist) {
        let force = (minDist - dist) / minDist
        this.vx -= (mdx / dist) * force * 15
        this.vy -= (mdy / dist) * force * 15
      }

      this.vx *= this.friction
      this.vy *= this.friction

    } else {
      this.vx += (this.wanderVx - this.vx) * 0.05
      this.vy += (this.wanderVy - this.vy) * 0.05

      if (this.x < 0) this.x = canvasWidth
      if (this.x > canvasWidth) this.x = 0
      if (this.y < 0) this.y = canvasHeight
      if (this.y > canvasHeight) this.y = 0

      let mdx = mouse.x - this.x
      let mdy = mouse.y - this.y
      let dist = Math.sqrt(mdx * mdx + mdy * mdy)
      
      if (dist < 100) {
        this.vx -= (mdx / dist) * 0.5
        this.vy -= (mdy / dist) * 0.5
      }
    }

    this.x += this.vx
    this.y += this.vy
  }

  draw(ctx) {
    ctx.fillStyle = this.color
    ctx.beginPath()
    ctx.arc(this.x, this.y, this.size, 0, Math.PI * 2)
    ctx.fill()
  }
}

const updateMousePosition = (e) => {
  if (!canvasRef.value) return
  const rect = canvasRef.value.getBoundingClientRect()
  mouse.x = e.clientX - rect.left
  mouse.y = e.clientY - rect.top
}

const handleMouseOut = () => {
  mouse.x = -1000
  mouse.y = -1000
}

onMounted(() => {
  nextTick(() => {
    const canvas = canvasRef.value
    if (!canvas) return
    
    const ctx = canvas.getContext('2d', { willReadFrequently: true })
    const section = canvas.parentElement
    
    const initParticles = () => {
      // 1. Dapatkan ukuran asli elemen secara akurat
      const rect = section.getBoundingClientRect()
      const width = rect.width || window.innerWidth
      const height = rect.height || window.innerHeight

      // 2. Tangani resolusi layar tajam (Retina/Mobile DPI)
      const dpr = window.devicePixelRatio || 1
      
      // 3. Set ukuran internal canvas (dikalikan DPR agar tajam)
      canvas.width = width * dpr
      canvas.height = height * dpr
      
      // Normalisasi skala agar kita tetap menggambar pakai koordinat normal
      ctx.scale(dpr, dpr)
      
      particles = []

      // Offscreen canvas (untuk mendeteksi teks) cukup pakai resolusi normal agar ringan
      const offCanvas = document.createElement('canvas')
      offCanvas.width = width
      offCanvas.height = height
      const offCtx = offCanvas.getContext('2d', { willReadFrequently: true })

      const isMobile = window.innerWidth < 768
      const fontSize = isMobile ? height * 0.5 : height * 0.9
      
      offCtx.font = `300 ${fontSize}px sans-serif`
      offCtx.fillStyle = 'white'
      offCtx.textAlign = 'center'
      offCtx.textBaseline = 'middle'

      const centerY = height / 2
      const gap = isMobile ? width * 0.42 : width * 0.3

      offCtx.fillText('{', width / 2 - gap, centerY)
      offCtx.fillText('}', width / 2 + gap, centerY)

      const data = offCtx.getImageData(0, 0, width, height).data
      const step = isMobile ? 8 : 6 
      
      for (let y = 0; y < height; y += step) {
        for (let x = 0; x < width; x += step) {
          const index = (y * width + x) * 4
          const alpha = data[index + 3]
          
          if (alpha > 128) {
            particles.push(new Particle(x, y, width, height))
          }
        }
      }
    }

    const animateParticles = () => {
      // Gunakan ukuran aslinya untuk clearRect (karena ctx sudah di-scale dpr)
      const rect = section.getBoundingClientRect()
      ctx.clearRect(0, 0, rect.width, rect.height)
      
      particles.forEach(p => {
        p.update(rect.width, rect.height)
        p.draw(ctx)
      })

      particles.forEach(p => {
        let dx = mouse.x - p.x
        let dy = mouse.y - p.y
        let dist = Math.sqrt(dx * dx + dy * dy)
        
        if (dist < 150) {
          ctx.beginPath()
          ctx.strokeStyle = `rgba(136, 208, 209, ${0.4 - dist / 375})`
          ctx.lineWidth = 0.5
          ctx.moveTo(p.x, p.y)
          ctx.lineTo(mouse.x, mouse.y)
          ctx.stroke()
        }
      })

      animationFrameId = requestAnimationFrame(animateParticles)
    }

    // Inisialisasi awal
    initParticles()
    animateParticles()

    // 4. Gunakan ResizeObserver agar update ukuran selalu akurat 100%
    const resizeObserver = new ResizeObserver(() => {
      initParticles()
    })
    resizeObserver.observe(section)
    
    // Simpan referensi observer ke object canvas agar bisa dibersihkan nanti
    canvas._resizeObserver = resizeObserver

    section.addEventListener('mousemove', updateMousePosition)
    section.addEventListener('mouseout', handleMouseOut)

    if (contentRef.value) {
      contentRef.value.addEventListener('mouseenter', () => isHoveringContent = true)
      contentRef.value.addEventListener('mouseleave', () => isHoveringContent = false)
    }
  })
})

onUnmounted(() => {
  if (canvasRef.value) {
    const section = canvasRef.value.parentElement
    if(section) {
        section.removeEventListener('mousemove', updateMousePosition)
        section.removeEventListener('mouseout', handleMouseOut)
    }

    if (canvasRef.value._resizeObserver) {
      canvasRef.value._resizeObserver.disconnect()
    }
  }
  if (contentRef.value) {
    contentRef.value.removeEventListener('mouseenter', () => {})
    contentRef.value.removeEventListener('mouseleave', () => {})
  }
  cancelAnimationFrame(animationFrameId)
})

onUnmounted(() => {
  window.removeEventListener('resize', () => {})
  if (canvasRef.value) {
    const section = canvasRef.value.parentElement
    if(section) {
        section.removeEventListener('mousemove', updateMousePosition)
        section.removeEventListener('mouseout', handleMouseOut)
    }
  }
  if (contentRef.value) {
    contentRef.value.removeEventListener('mouseenter', () => {})
    contentRef.value.removeEventListener('mouseleave', () => {})
  }
  cancelAnimationFrame(animationFrameId)
})
</script>

<template>
  <section class="relative w-full min-h-[80vh] flex flex-col items-center justify-center px-6 py-24 bg-transparent border-t border-anti-light-gray/30">
    
    <canvas 
      ref="canvasRef" 
      class="absolute inset-0 w-full h-full pointer-events-none z-0"
    ></canvas>

    <div ref="contentRef" class="relative z-10 flex flex-col items-center w-full px-8 py-12 rounded-3xl transition-all duration-500">
      <h2 class="text-5xl md:text-7xl font-bold mb-8 text-center text-white">Mari Terhubung</h2>
      
      <p class="text-xl text-gray-400 max-w-2xl text-center mb-16 font-light drop-shadow-md pointer-events-none">
        Apakah Anda mencari arsitek cloud, devops engineer, atau full-stack developer, 
        saya selalu terbuka untuk mendiskusikan proyek dan peluang baru.
      </p>

      <a href="mailto:hello@example.com" class="inline-block relative group">
        <div class="absolute -inset-1 bg-cyan-500/20 rounded-full blur-xl opacity-0 group-hover:opacity-100 transition-opacity duration-500"></div>
        
        <MagneticButton relative z-10>
          <span class="text-sm sm:text-lg md:text-3xl px-6 sm:px-8 py-3 md:py-4 block text-white font-medium tracking-wide">muhammadfazli@sainzlab.my.id</span>
        </MagneticButton>
      </a>

      <div class="mt-32 flex gap-8 text-gray-500 text-sm tracking-widest uppercase">
        <a href="https://github.com/Sainzlab" class="hover:text-white hover:text-shadow-[0_0_8px_rgba(255,255,255,0.5)] transition-all">GitHub</a>
        <a href="https://www.instagram.com/makkanbang_" class="hover:text-white hover:text-shadow-[0_0_8px_rgba(255,255,255,0.5)] transition-all">Instagram</a>
        <a href="https://discord.com/users/.internetpositif" class="hover:text-white hover:text-shadow-[0_0_8px_rgba(255,255,255,0.5)] transition-all">Discord</a>
      </div>
    </div>

  </section>
</template>

<style scoped>

section {
  background-color: #000000;
  background: radial-gradient(
    circle at center, 
    rgba(10, 10, 10, 1) 0%, 
    rgba(0, 0, 0, 1) 100%
  );

  background-attachment: fixed;
  outline: none;
  border: none;
}

canvas {
  display: block;
  mix-blend-mode: screen;
}

.transition-all {
  transition-property: all;
  transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);
  transition-duration: 500ms;
}
</style>