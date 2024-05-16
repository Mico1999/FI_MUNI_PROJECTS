import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import svgr from 'vite-plugin-svgr';
import { VitePWA } from 'vite-plugin-pwa';

// https://vitejs.dev/config/
export default defineConfig({
	plugins: [
		react(),
		svgr(),
		VitePWA({
			registerType: 'autoUpdate',
			includeAssets: ['to-do.svg', 'to-do.png'],
			manifest: {
				short_name: 'TODO App',
				name: 'TODO App',
				description: 'A simple TODO App',
				theme_color: '#8c1aff',
				background_color: 'dark',
				icons: [
					{
						src: '/to-do.svg',
						type: 'image/svg+xml',
						sizes: '48x48 192x192 512x512'
					}
				]
			}
		})
	]
});
