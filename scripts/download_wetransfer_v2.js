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
  const context = await browser.newContext({ 
    acceptDownloads: true,
    viewport: { width: 1280, height: 720 }
  });
  const page = await context.newPage();

  console.log('Cargando WeTransfer...');
  await page.goto(url, { waitUntil: 'networkidle', timeout: 90000 });
  
  // Aceptar cookies si aparecen
  try {
    const agreeBtn = await page.$('button:has-text("I agree"), button:has-text("Accept"), button:has-text("Agree")');
    if (agreeBtn) {
      console.log('Botón de consentimiento encontrado. Clickeando...');
      await agreeBtn.click();
      await page.waitForTimeout(2000);
    }
  } catch (e) {}

  // Esperar a que aparezca el contenido de transferencia
  console.log('Esperando elementos de descarga...');
  await page.waitForTimeout(3000);

  // Tomar screenshot para debug
  await page.screenshot({ path: '/tmp/wetransfer_page.png' });
  console.log('Screenshot guardado en /tmp/wetransfer_page.png');

  // Buscar cualquier elemento relacionado con descarga
  const allLinks = await page.$$eval('a, button', els => 
    els.map((e, i) => ({ 
      index: i, 
      text: e.textContent?.trim().substring(0, 50), 
      href: e.href?.substring(0, 100),
      class: e.className?.substring(0, 50)
    }))
  );
  
  console.log('\nTodos los elementos interactivos:');
  allLinks.forEach(e => console.log(`  ${JSON.stringify(e)}`));

  // Buscar botón Get/Download
  const downloadSelectors = [
    'a[href*="download"]',
    'button:has-text("Get your files")',
    'button:has-text("Download")',
    'a:has-text("Download")',
    '[data-testid*="download"]',
    '.download__button',
    '.action__button'
  ];

  for (const selector of downloadSelectors) {
    const btn = await page.$(selector);
    if (btn) {
      console.log(`\n✅ Botón encontrado con selector: ${selector}`);
      const [download] = await Promise.all([
        page.waitForEvent('download', { timeout: 60000 }),
        btn.click()
      ]);
      
      const savedPath = '/tmp/' + download.suggestedFilename();
      await download.saveAs(savedPath);
      console.log(`✅ Archivo descargado: ${savedPath}`);
      
      await browser.close();
      return;
    }
  }

  console.log('\n⚠️ No se encontró botón de descarga');
  
  // Buscar links directos
  const html = await page.content();
  const downloadUrl = html.match(/href="([^"]+\.zip)"/);
  if (downloadUrl) {
    console.log(`URL directa encontrada: ${downloadUrl[1]}`);
  }

  await browser.close();
})();
