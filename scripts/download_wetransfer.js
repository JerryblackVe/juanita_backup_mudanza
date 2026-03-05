#!/usr/bin/env node
const { chromium } = require('playwright');

const url = 'https://wetransfer.com/downloads/c41b9f045a29b90faddae9030a81d31520260302025941/14ab62c103ac289ffc33c0508490640820260302030033/ad4832?trk=TRN_TDL_01&utm_campaign=TRN_TDL_01&utm_medium=email&utm_source=sendgrid';
const downloadPath = '/tmp/nuevo_skill.zip';

(async () => {
  console.log('Iniciando navegador...');
  const browser = await chromium.launch({ 
    headless: true,
    executablePath: '/usr/bin/google-chrome'
  });
  const context = await browser.newContext({ acceptDownloads: true });
  const page = await context.newPage();

  console.log('Cargando WeTransfer...');
  await page.goto(url, { waitUntil: 'domcontentloaded', timeout: 60000 });
  
  console.log('Esperando que cargue (5s)...');
  await page.waitForTimeout(5000);

  // Buscar botón "Get your files" o similar
  const buttons = await page.$$('button');
  console.log(`Botones encontrados: ${buttons.length}`);
  
  for (let i = 0; i < buttons.length; i++) {
    const text = await buttons[i].textContent();
    console.log(`  [${i}]: ${text?.trim() || '(vacío)'}`);
  }

  // Buscar botón de descarga
  const downloadBtn = await page.$('button:has-text("Get your files"), button:has-text("Download"), a:has-text("Download")');
  
  if (downloadBtn) {
    console.log('Botón encontrado. Haciendo clic...');
    const [download] = await Promise.all([
      page.waitForEvent('download', { timeout: 60000 }),
      downloadBtn.click()
    ]);
    
    await download.saveAs(downloadPath);
    console.log(`✅ Descargado: ${downloadPath}`);
    await browser.close();
    return;
  }

  // Si no hay botón visible, puede que la descarga inicie automáticamente
  console.log('Esperando descarga automática (10s)...');
  try {
    const download = await page.waitForEvent('download', { timeout: 10000 });
    await download.saveAs(downloadPath);
    console.log(`✅ Descargado automáticamente: ${downloadPath}`);
  } catch (e) {
    console.log('No hubo descarga automática');
  }

  await browser.close();
  console.log('Navegador cerrado.');
})();
