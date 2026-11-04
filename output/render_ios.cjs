const fs = require('fs');
const path = require('path');
const {pathToFileURL} = require('url');
const {chromium} = require('C:/Users/admin/AppData/Local/Python/pythoncore-3.14-64/Lib/site-packages/playwright/driver/package');
(async()=>{
 const c=JSON.parse(fs.readFileSync(process.argv[2],'utf8'));
 const browser=await chromium.launch({executablePath:'C:/Program Files/Google/Chrome/Application/chrome.exe',headless:true});
 try{
 for(const [width,height] of c.sizes){
  const dest=path.join(c.out,`iphone_${width}x${height}`);fs.mkdirSync(dest,{recursive:true});
  const page=await browser.newPage({viewport:{width:1080,height:2349},deviceScaleFactor:width/1080});
  for(const name of c.names){
   const html=path.join(c.source,name==='01_home'?'home.html':name+'.html');
   await page.goto(pathToFileURL(html).href,{waitUntil:'networkidle',timeout:60000});
   await page.evaluate(()=>document.fonts.ready);
   const fonts=await page.evaluate(()=>Array.from(document.fonts).map(f=>({family:f.family,status:f.status})));
   if(!fonts.some(f=>f.family==='Outfit'&&f.status==='loaded'))throw new Error('Outfit unavailable: '+JSON.stringify(fonts));
   const missing=await page.evaluate(()=>Array.from(document.images).filter(i=>!i.complete||!i.naturalWidth).map(i=>i.src));
   if(missing.length)throw new Error('Missing images: '+missing);
   await page.screenshot({path:path.join(dest,name+'_en.png'),clip:{x:0,y:0,width:1080,height:Math.ceil(height/(width/1080))},animations:'disabled'});
   console.log(name,width,height);
  }
  await page.close();
 }
 }finally{await browser.close()}
})().catch(e=>{console.error(e);process.exitCode=1});
