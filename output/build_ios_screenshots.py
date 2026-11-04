"""Re-render the supplied editable store artwork with iPhone chrome."""
from pathlib import Path
import json
import shutil
import subprocess
import sys
from PIL import Image, ImageOps, ImageDraw

ORIGINAL = Path(r'F:\Codebases\eDemand\eDemand Apps v5.2.0\eDemand Apps v5.2.0\eDemand Customer\eDemand\store_screenshots')
OUT = Path(__file__).resolve().parent / 'ios'
SOURCE = OUT / 'source'
SOURCE.mkdir(parents=True, exist_ok=True)
shutil.copytree(ORIGINAL / 'source', SOURCE, dirs_exist_ok=True)
subprocess.run([sys.executable, str(SOURCE / 'gen.py')], check=True)
subprocess.run([sys.executable, str(SOURCE / 'screens.py')], check=True)

CSS = '''
html,body,.canvas{height:2348.0597014925px!important}
.phone-wrap{top:610px!important;transform:translateX(-50%) scale(1.8)!important}
.phone{border-radius:62px!important;padding:12px!important}
.screen{border-radius:50px!important}
.phone:before{right:-3px;top:185px;height:77px;background:#454650}
.phone:after{content:"";position:absolute;left:-3px;top:150px;width:3px;height:105px;border-radius:2px;background:linear-gradient(#454650 0 39%,transparent 39% 52%,#454650 52% 100%)}
.punch{top:10px!important;width:124px!important;height:35px!important;margin-left:-62px!important;border-radius:22px!important;background:#000!important;box-shadow:none!important;z-index:100!important}
.punch:after{content:"";position:absolute;right:12px;top:12px;width:10px;height:10px;border-radius:50%;background:radial-gradient(circle at 38% 38%,#15253b,#070b12 65%);border:1px solid #11151d}
.statusbar{height:60px!important;padding:0 26px 0 30px!important;font-family:Arial,sans-serif!important}
.statusbar>span:first-child{font-family:Arial,sans-serif!important;font-size:16px!important;font-weight:600!important;letter-spacing:0!important}
.gesture{height:30px!important;align-items:flex-end!important;padding-bottom:8px!important;background:#fff!important}
.gesture span{width:134px!important;height:5px!important;border-radius:4px!important;margin-top:0!important;background:#111!important;opacity:1!important}
.float-svc{left:650px!important;top:1780px!important}
'''

ADAPT = '''() => {
 const screen = document.querySelector('.screen');
 const home = !!screen.querySelector('.header');
 const extra = home ? 20 : 32;
 // Preserve the existing content layout while reserving the iPhone top safe area.
 for(const child of screen.children){
   if(child.classList.contains('punch') || child.classList.contains('gesture')) continue;
   const s = getComputedStyle(child);
   const top = parseFloat(s.top);
   if(s.position==='absolute' && Number.isFinite(top) && top>0 && s.bottom==='auto')
     child.style.top = (top+extra)+'px';
 }
 if(home){
   const spacer=screen.querySelector('.scroll>div');
   spacer.style.height=(parseFloat(getComputedStyle(spacer).height)+extra)+'px';
   screen.querySelector('.gesture').style.position='relative';
 }
 // Put bottom controls above the iOS home indicator safe area.
 for(const child of screen.children){
   if(child.classList.contains('gesture') || child.classList.contains('punch')) continue;
   const s=getComputedStyle(child);
   if(s.position==='absolute' && s.bottom==='18px') child.style.bottom='30px';
 }
 // iOS Wi-Fi uses curved arcs rather than Android's filled wedge.
 for(const bar of screen.querySelectorAll('.statusbar')){
   const svgs=bar.querySelectorAll('svg');
   if(svgs.length>=3){
     const old=svgs[1];
     const color=old.querySelector('path')?.getAttribute('fill') || '#1A1A1A';
     old.setAttribute('viewBox','0 0 18 14');
     old.setAttribute('width','18');old.setAttribute('height','14');
     old.innerHTML=`<path d="M1 4.3a12 12 0 0 1 16 0M4 7.5a7.5 7.5 0 0 1 10 0M7 10.5a3 3 0 0 1 4 0" fill="none" stroke="${color}" stroke-width="2"/><circle cx="9" cy="13" r="1" fill="${color}"/>`;
   }
 }
}'''

names=['01_home','02_provider','03_service','04_checkout','05_booking','06_bookings','07_chat','08_request']
sizes=[(1206,2622),(1320,2868)]
report=[]
for name in names:
    html=SOURCE / ('home.html' if name=='01_home' else name+'.html')
    content=html.read_text(encoding='utf-8')
    content=content.replace('</head>',f'<style>{CSS}</style></head>')
    content=content.replace('</body>',f'<script>({ADAPT})();</script></body>')
    html.write_text(content,encoding='utf-8')
if '--prepare-only' in sys.argv:
    print('Prepared eight iPhone HTML compositions:',SOURCE)
    raise SystemExit(0)
config=OUT/'render_config.json'
config.write_text(json.dumps(dict(out=str(OUT),source=str(SOURCE),css=CSS,adapt=ADAPT,names=names,sizes=sizes)),encoding='utf-8')
if '--reuse-existing' not in sys.argv:
    subprocess.run(['node',str(Path(__file__).with_name('render_ios.cjs')),str(config)],check=True)
for width,height in sizes:
    for name in names:
        path=OUT/f'iphone_{width}x{height}'/(name+'_en.png')
        with Image.open(path) as im:
            if im.width != width or abs(im.height-height)>1:
                raise RuntimeError(f'Unexpected screenshot dimensions: {path}: {im.size}')
            rgb=im.convert('RGB')
            if rgb.height<height:
                # Fractional CSS clips can lose one device pixel. Extend only
                # the final background row, preserving all artwork pixels.
                fixed=Image.new('RGB',(width,height))
                fixed.paste(rgb,(0,0))
                fixed.paste(rgb.crop((0,rgb.height-1,width,rgb.height)),(0,rgb.height))
                rgb=fixed
            elif rgb.height>height:
                rgb=rgb.crop((0,0,width,height))
            rgb.save(path)
        with Image.open(path) as verified:
            if verified.size!=(width,height) or verified.mode!='RGB':
                raise RuntimeError(f'Invalid final export: {path}')
        report.append({'file':str(path.relative_to(OUT)),'width':width,'height':height,'mode':'RGB'})

preview=Image.new('RGB',(1200,1350),'#e8e9ef')
d=ImageDraw.Draw(preview)
for i,name in enumerate(names):
    with Image.open(OUT/'iphone_1206x2622'/(name+'_en.png')) as im:
        thumb=ImageOps.contain(im,(280,610))
        x=(i%4)*300+10;y=(i//4)*675+30
        preview.paste(thumb,(x,y))
        d.text((x,y-18),name,fill='#222')
preview.save(OUT/'preview.jpg',quality=92)
(OUT/'validation.json').write_text(json.dumps(report,indent=2),encoding='utf-8')
(OUT/'README.txt').write_text('Khidma Plus - iPhone App Store artwork\n\n8 screenshots in each size folder, in the original order.\niphone_1206x2622: Dynamic Island medium display.\niphone_1320x2868: Dynamic Island large display.\nPNG, opaque RGB, no alpha channel.\n\nThese are marketing compositions re-rendered from the supplied HTML/CSS source with iPhone chrome; they are not captures from a running iOS device.\nOriginal Android artwork is unchanged.\n\nApple specification checked 2026-10-30:\nhttps://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications/\n',encoding='utf-8')
print('COMPLETE',OUT,flush=True)
if '--install' in sys.argv:
    target=ORIGINAL/'ios'
    if target.exists():
        raise RuntimeError(f'Refusing to overwrite existing folder: {target}')
    shutil.copytree(OUT,target)
    print('INSTALLED',target,flush=True)
