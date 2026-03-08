<script setup>
import { onMounted, ref } from 'vue'
import gsap from 'gsap'

const sectionRef = ref(null)
const cardsRef = ref([])

const softwareProjects = [
  { id: 1, title: 'Sistem Cuaca Terpadu', category: 'Web App', image: 'public/porto/Cuaca.png', description: 'Dashboard monitoring cuaca real-time.', link: 'https://weather.sainzlab.my.id/' },
  { id: 2, title: 'Mini Game Retro', category: 'Web App', image: 'public/porto/MiniGame.png', description: 'Eksplorasi nostalgia klasik dibalut dengan teknologi Web modern.', link: 'https://minigame.sainz.fun/' },
  { id: 3, title: 'Qibla', category: 'Mobile App', image: 'public/porto/Qibla.png', description: 'Aplikasi berbasis Flutter dengan keakuratan kompas tinggi.', link: 'https://github.com/SainzLab/Kompas-Kiblat/' },
  { id: 4, title: 'MyGudang', category: 'Mobile App', image: 'public/porto/MyGudang.png', description: 'Sistem manajemen gudang digital.', link: 'https://github.com/SainzLab/MyGudang/' },
  { id: 5, title: 'SiGaji', category: 'Mobile App', image: 'public/porto/SiGaji.png', description: 'Slip gaji digital dengan chatbot AI.', link: 'https://github.com/SainzLab/mobile-slipgaji/' },
  { id: 6, title: 'Katalog Korporat', category: 'Web App', image: 'public/porto/Enp.png', description: 'Profile UMKM sederhana dengan katalog sederhana.', link: 'http://enp.sainzlab.my.id/' },
  { id: 7, title: 'SainzLab', category: 'Web App', image: 'public/porto/SainzLab.jpg', description: 'Profile Perusahaan dengan katalog cerdas.', link: 'https://sainzlab.my.id/' },
  { id: 8, title: 'MyProfile', category: 'Web App', image: 'public/porto/Profile.png', description: 'Personal Profile sederhana.', link: 'https://profile.sainzlab.my.id/' },
  { id: 9, title: 'eSip', category: 'Web App', image: 'https://placehold.co/600x800/5a67d8/FFFFFF?text=coming soon', description: 'Earsip enterprise terintegrasi dengan kecerdasan buatan.', link: 'https://github.com/SainzLab/eSIP-FE' }
]

const devopsProjects = [
  { id: 101, title: 'Cluster Kubernetes', category: 'Cloud ', image: 'public/porto/Kubernetes-logo.jpg', description: 'Orkestrasi microservices pada cluster kubernetes.', link: '#' },
  { id: 102, title: 'Proxmox Virtual Environment', category: 'Server Admin', image: 'public/porto/Proxmox-logo.jpg', description: 'Manajemen server lokal dengan VM dan LXC.', link: '#' },
  { id: 103, title: 'Docker Container', category: 'Cloud', image: 'public/porto/Docker-Logo.png', description: 'Manajemen Container.', link: '#' },
  { id: 104, title: 'VM Terraform Automation', category: 'IaC', image: 'public/porto/terraform-logo.jpg', description: 'Setup VM dengan terraform.', link: 'https://github.com/SainzLab/terraform-vm/' },
  { id: 105, title: 'LXC Terraform Automation', category: 'IaC', image: 'public/porto/terraform-logo.jpg', description: 'Setup LXC dengan terraform.', link: 'https://github.com/SainzLab/terraform-lxc/' },
  { id: 106, title: 'Bot AFK Discord', category: 'Script', image: 'public/porto/discord_logo.jpg', description: 'Bot Discord.', link: 'https://github.com/SainzLab/script-afk-discord/' },
  { id: 104, title: 'Automation setup Wazuh', category: 'IaC', image: 'https://placehold.co/600x800/5a67d8/FFFFFF?text=coming soon', description: 'Setup Wazuh server menggunakan ansible dan terraform.', link: '#' },
  { id: 105, title: 'Automation setup Docker', category: 'IaC', image: 'https://placehold.co/600x800/5a67d8/FFFFFF?text=coming soon', description: 'Setup Docker container menggunakan ansible dan terraform.', link: '#' }
]

onMounted(() => {

})
</script>

<template>
  <section class="w-full min-h-screen relative py-32 px-6 md:px-24 text-anti-black flex flex-col justify-center bg-black">
    
    <div class="mb-16">
      <h2 class="text-4xl md:text-6xl font-bold mb-4 text-white">
        Pusat Gravitasi.
      </h2>
      <p class="text-xl text-gray-400 font-light">Portfolio & Proyek.</p>
    </div>

    <div class="mb-8">
      <h3 class="text-2xl font-semibold mb-6 flex items-center gap-3 text-white">
        <svg class="w-6 h-6 text-cyan-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 20l4-16m4 4l4 4-4 4M6 16l-4-4 4-4" />
        </svg>
        Software Development
      </h3>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 relative z-10 mb-20">
      <a 
        v-for="project in softwareProjects" 
        :key="project.id" 
        :href="project.link"
        target="_blank"
        rel="noopener noreferrer"
        class="group relative overflow-hidden rounded-2xl bg-gray-900 border border-white/5 transition-all duration-500 hover:-translate-y-2 hover:shadow-[0_20px_40px_-10px_rgba(255,255,255,0.05)] cursor-pointer block"
      >
      
        <div class="relative w-full aspect-[4/3] overflow-hidden">
          <div class="absolute inset-0 bg-black/20 group-hover:bg-transparent transition-colors duration-500 z-10"></div>
          <img 
            :src="project.image" 
            :alt="project.title" 
            class="w-full h-full object-cover origin-center transform group-hover:scale-105 transition-transform duration-700 ease-out"
          />
        </div>

        <div class="absolute inset-x-0 bottom-0 h-1/2 bg-gradient-to-t from-black via-black/80 to-transparent z-10 opacity-90 group-hover:opacity-100 transition-opacity duration-500 pointer-events-none"></div>

        <div class="absolute bottom-0 left-0 p-6 z-20 transform translate-y-4 group-hover:translate-y-0 transition-transform duration-500">
          <span class="text-cyan-400 font-semibold text-xs tracking-wider uppercase mb-1 block">{{ project.category }}</span>
          <h3 class="text-xl font-bold text-white mb-2 flex items-center gap-2">
            {{ project.title }}
            <svg class="w-4 h-4 text-gray-400 opacity-0 group-hover:opacity-100 -translate-x-2 group-hover:translate-x-0 transition-all duration-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14" />
            </svg>
          </h3>
          <p class="text-sm text-gray-300 font-light opacity-0 group-hover:opacity-100 transition-opacity duration-500 delay-100 max-w-[90%] pointer-events-none">
            {{ project.description }}
          </p>
        </div>
      </a>
    </div>

    <div class="mb-8">
      <h3 class="text-2xl font-semibold mb-6 flex items-center gap-3 text-white">
        <svg class="w-6 h-6 text-purple-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 12h14M5 12a2 2 0 01-2-2V6a2 2 0 012-2h14a2 2 0 012 2v4a2 2 0 01-2 2M5 12a2 2 0 00-2 2v4a2 2 0 002 2h14a2 2 0 002-2v-4a2 2 0 00-2-2m-2-4h.01M17 16h.01" />
        </svg>
        DevOps & Infrastructure
      </h3>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 relative z-10">
      <a 
        v-for="project in devopsProjects" 
        :key="project.id" 
        :href="project.link"
        target="_blank"
        rel="noopener noreferrer"
        class="group relative overflow-hidden rounded-2xl bg-gray-900 border border-white/5 transition-all duration-500 hover:-translate-y-2 hover:shadow-[0_20px_40px_-10px_rgba(255,255,255,0.05)] cursor-pointer block"
      >
        <div class="relative w-full aspect-[4/3] overflow-hidden">
          <div class="absolute inset-0 bg-black/40 group-hover:bg-transparent transition-colors duration-500 z-10"></div>
          <img 
            :src="project.image" 
            :alt="project.title" 
            class="w-full h-full object-cover origin-center transform group-hover:scale-105 transition-transform duration-700 ease-out"
          />
        </div>

        <div class="absolute inset-x-0 bottom-0 h-1/2 bg-gradient-to-t from-black via-black/90 to-transparent z-10 opacity-90 group-hover:opacity-100 transition-opacity duration-500 pointer-events-none"></div>

        <div class="absolute bottom-0 left-0 p-6 z-20 transform translate-y-4 group-hover:translate-y-0 transition-transform duration-500">
          <span class="text-purple-400 font-semibold text-xs tracking-wider uppercase mb-1 block">{{ project.category }}</span>
          <h3 class="text-xl font-bold text-white mb-2 flex items-center gap-2">
            {{ project.title }}
            <svg class="w-4 h-4 text-gray-400 opacity-0 group-hover:opacity-100 -translate-x-2 group-hover:translate-x-0 transition-all duration-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14" />
            </svg>
          </h3>
          <p class="text-sm text-gray-300 font-light opacity-0 group-hover:opacity-100 transition-opacity duration-500 delay-100 max-w-[90%] pointer-events-none">
            {{ project.description }}
          </p>
        </div>
      </a>
    </div>

  </section>
</template>

<style scoped>

</style>
