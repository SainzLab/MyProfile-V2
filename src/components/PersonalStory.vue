<script setup>
import { onMounted, onUnmounted, ref } from 'vue'
import gsap from 'gsap'
import { ScrollTrigger } from 'gsap/ScrollTrigger'

gsap.registerPlugin(ScrollTrigger)

const sectionRef = ref(null)
const imageContainerRef = ref(null)
const imageRef = ref(null)
const titleRef = ref(null)
const textRefs = ref([])
const canvasRef = ref(null)

let hoverActive = false

const handleMouseMove = (e) => {
  if (!imageContainerRef.value || !hoverActive) return
  const rect = imageContainerRef.value.getBoundingClientRect()
  const x = (e.clientX - rect.left - rect.width / 2) * 0.05
  const y = (e.clientY - rect.top - rect.height / 2) * 0.05
  gsap.to(imageRef.value, { x, y, duration: 1, ease: 'power2.out' })
}

const handleMouseEnter = () => hoverActive = true
const handleMouseLeave = () => {
  hoverActive = false
  gsap.to(imageRef.value, { x: 0, y: 0, duration: 1, ease: 'elastic.out(1, 0.3)' })
}

let particles = []
let animationFrameId
let mouse = { x: -1000, y: -1000 }

class Particle {
  constructor(canvasWidth, canvasHeight) {
    this.x = Math.random() * canvasWidth
    this.y = Math.random() * canvasHeight
    this.vx = (Math.random() - 0.5) * 1.5 
    this.vy = (Math.random() - 0.5) * 1.5
    this.size = Math.random() * 2 + 0.5
    this.color = 'rgba(100, 100, 100, 0.6)' 
  }

  update(canvasWidth, canvasHeight) {
    if (this.x < 0 || this.x > canvasWidth) this.vx *= -1
    if (this.y < 0 || this.y > canvasHeight) this.vy *= -1

    let dx = mouse.x - this.x
    let dy = mouse.y - this.y
    let dist = Math.sqrt(dx * dx + dy * dy)
    let minDist = 150

    if (dist < minDist) {
      let angle = Math.atan2(dy, dx)
      this.x -= Math.cos(angle) * 0.5
      this.y -= Math.sin(angle) * 0.5
    }

    this.x += this.vx
    this.y += this.vy
  }

  draw(ctx) {
    ctx.beginPath()
    ctx.arc(this.x, this.y, this.size, 0, Math.PI * 2)
    ctx.fillStyle = this.color
    ctx.fill()
  }
}

const updateMousePosition = (e) => {
  mouse.x = e.clientX
  mouse.y = e.clientY
}

const handleMouseOut = () => {
  mouse.x = -1000
  mouse.y = -1000
}

onMounted(() => {
  gsap.to('main', {
    backgroundColor: '#ffffff',
    scrollTrigger: {
      trigger: sectionRef.value,
      start: 'top bottom', 
      end: 'top 20%',      
      scrub: 1,            
    }
  })

  gsap.set(imageContainerRef.value, { clipPath: 'inset(100% 0% 0% 0%)' })
  gsap.set(imageRef.value, { scale: 1.2 })
  gsap.set(titleRef.value, { y: 100, opacity: 0 })
  gsap.set(textRefs.value, { y: 50, opacity: 0 })

  const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        const tl = gsap.timeline()
        tl.to(imageContainerRef.value, { clipPath: 'inset(0% 0% 0% 0%)', duration: 1.5, ease: 'power4.inOut' }, 0)
        tl.to(imageRef.value, { scale: 1, duration: 1.5, ease: 'power4.inOut' }, 0)
        tl.to(titleRef.value, { y: 0, opacity: 1, duration: 1, ease: 'power3.out' }, 0.5)
        tl.to(textRefs.value, { y: 0, opacity: 1, duration: 1, stagger: 0.2, ease: 'power3.out' }, 0.7)
        observer.unobserve(entry.target)
      }
    })
  }, { threshold: 0.2 })

  if (sectionRef.value) observer.observe(sectionRef.value)

  const canvas = canvasRef.value
  const ctx = canvas.getContext('2d')
  
  const initParticles = () => {
    canvas.width = window.innerWidth
    canvas.height = window.innerHeight
    particles = []
    
    const particleCount = window.innerWidth < 768 ? 50 : 150 
    for (let i = 0; i < particleCount; i++) {
      particles.push(new Particle(canvas.width, canvas.height))
    }
  }

  const animateParticles = () => {
    ctx.clearRect(0, 0, canvas.width, canvas.height)
    
    for (let i = 0; i < particles.length; i++) {
      particles[i].update(canvas.width, canvas.height)
      particles[i].draw(ctx)

      for (let j = i; j < particles.length; j++) {
        let dx = particles[i].x - particles[j].x
        let dy = particles[i].y - particles[j].y
        let distance = Math.sqrt(dx * dx + dy * dy)

        if (distance < 100) {
          ctx.beginPath()
          ctx.strokeStyle = `rgba(150, 150, 150, ${0.4 - distance / 250})`
          ctx.lineWidth = 0.5
          ctx.moveTo(particles[i].x, particles[i].y)
          ctx.lineTo(particles[j].x, particles[j].y)
          ctx.stroke()
        }
      }

      let dxMouse = particles[i].x - mouse.x
      let dyMouse = particles[i].y - mouse.y
      let distMouse = Math.sqrt(dxMouse * dxMouse + dyMouse * dyMouse)
      
      if (distMouse < 150) {
        ctx.beginPath()
        ctx.strokeStyle = `rgba(100, 100, 100, ${0.5 - distMouse / 300})`
        ctx.lineWidth = 0.8
        ctx.moveTo(particles[i].x, particles[i].y)
        ctx.lineTo(mouse.x, mouse.y)
        ctx.stroke()
      }
    }

    animationFrameId = requestAnimationFrame(animateParticles)
  }

  initParticles()
  animateParticles()

  window.addEventListener('resize', initParticles)
  window.addEventListener('mousemove', updateMousePosition)
  window.addEventListener('mouseout', handleMouseOut)
})

onUnmounted(() => {
  window.removeEventListener('resize', () => {})
  window.removeEventListener('mousemove', updateMousePosition)
  window.removeEventListener('mouseout', handleMouseOut)
  cancelAnimationFrame(animationFrameId)
})
</script>

<template>
  <section 
    ref="sectionRef" 
    class="w-full min-h-screen flex flex-col md:flex-row items-center justify-center p-8 md:p-24 bg-transparent text-anti-black relative overflow-hidden"
  >
    <canvas 
      ref="canvasRef" 
      class="absolute inset-0 w-full h-full pointer-events-none z-0"
    ></canvas>

    <div class="w-full md:w-1/2 flex justify-center mb-16 md:mb-0 relative z-10">
      <div 
        class="relative w-72 md:w-96 rounded-2xl cursor-crosshair"
        @mousemove="handleMouseMove" 
        @mouseenter="handleMouseEnter" 
        @mouseleave="handleMouseLeave"
      >
        <div class="absolute -inset-6 bg-gray-200/50 rounded-3xl blur-2xl -z-10"></div>
        
        <div ref="imageContainerRef" class="overflow-hidden rounded-2xl shadow-2xl relative bg-gray-100 aspect-[3/4]">
          <img 
            ref="imageRef"
            src="/img_my2.jpeg" 
            alt="Profil Saya" 
            class="absolute inset-0 w-full h-full object-cover origin-center contrast-125"
          />
          <div class="absolute inset-0 bg-black/5 mix-blend-overlay pointer-events-none"></div>
        </div>
      </div>
    </div>

    <div class="w-full md:w-1/2 md:pl-16 relative z-10">
      <div class="overflow-hidden pb-4">
        <h2 ref="titleRef" class="text-5xl md:text-7xl font-bold tracking-tight text-gray-900 leading-[1.1]">
           Saya Fazli <br> Mewujudkan <br/>
          <span class="text-gray-400">Ide anda.</span>
        </h2>
      </div>
      
      <div class="mt-8 space-y-6">
        <div class="overflow-hidden">
          <p :ref="el => textRefs[0] = el" class="text-xl md:text-2xl font-light leading-relaxed text-gray-700">
            Di balik setiap layar putih yang kosong, terdapat potensi tak terbatas. Saya percaya bahwa teknologi bukan sekedar rentetan kode, melainkan medium untuk <strong>bercerita</strong> dan <strong>memberikan solusi</strong>.
          </p>
        </div>
        <div class="overflow-hidden">
          <p :ref="el => textRefs[1] = el" class="text-lg md:text-xl font-light leading-relaxed text-gray-500">
            Keindahan dari sebuah karya tidak hanya terlihat pada desain visualnya yang memukau, tetapi juga terletak pada arsitektur di baliknya yang kokoh dan efisien.
          </p>
        </div>
      </div>
    </div>
  </section>
</template>