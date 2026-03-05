#!/usr/bin/env node
const { chromium } = require('playwright');

const url = 'https://weur.sendallfiles.com/d/weura001da0pzCBSh5XG23yOVTAIj8#s=PL-rpt72HMKGlX1NU2eHpACHI--EXB4ZC5q-8wAD4Zc';
const downloadPath = '/tmp/nuevo_skill.zip';

(async () => {
  console.log('Iniciando navegador...');
  const browser = await chromium.launch({ 
    headless: true,
    executablePath: '/usr/bin/google-chrome'
  });
  const context = await browser.newContext({ acceptDownloads: true });
  const page = await context.newPage();

  console.log('Cargando página de SendAllFiles...');
  await page.goto(url, { waitUntil: 'domcontentloaded', timeout: 90000 });

  console.log('Esperando que JavaScript procese el hash (10s)...');
  await page.waitForTimeout(10000);

  // Buscar botones de descarga
  const downloadBtns = await page.$$('button, a');
  console.log(`Elementos clickeables encontrados: ${downloadBtns.length}`);
  
  for (let i = 0; i < Math.min(downloadBtns.length, 10); i++) {
    const text = await downloadBtns[i].textContent();
    console.log(`  [${i}]: ${text || '(sin texto)'}`);
  }

  // Buscar botón específico de descarga
  const downloadButton = await page.$('button:has-text("Download"), button:has-text("Download file"), a:has-text("Download")');
  
  if (downloadButton) {
    console.log('Botón de descarga encontrado. Haciendo clic...');
    const [download] = await Promise.all([
      page.waitForEvent('download', { timeout: 30000 }),
      downloadButton.click()
    ]);
    
    await download.saveAs(downloadPath);
    console.log(`✅ Archivo descargado a: ${downloadPath}`);
  } else {
    console.log('⚠️ No se encontró botón de descarga visible');
  }

  await browser.close();
  console.log('Navegador cerrado.');
})();
