"""把 OpenSCAD 匯出的 STL 組成一個多零件、多色的 3MF。
用法: python3 make_3mf.py  -> export/box2A_birthday.3mf
"""
import zipfile, struct, re, os

def load_stl(path):
    data = open(path, 'rb').read()
    tris = []
    if data[:5] == b'solid' and b'facet' in data[:300]:
        v = [tuple(map(float, m)) for m in re.findall(rb'vertex\s+(\S+)\s+(\S+)\s+(\S+)', data)]
        tris = [v[i:i+3] for i in range(0, len(v), 3)]
    else:
        n = struct.unpack('<I', data[80:84])[0]
        for i in range(n):
            f = struct.unpack('<12f', data[84+i*50: 84+i*50+48])
            tris.append([f[3:6], f[6:9], f[9:12]])
    verts, idx, out = {}, [], []
    for t in tris:
        ids = []
        for p in t:
            k = tuple(round(c, 5) for c in p)
            if k not in verts:
                verts[k] = len(verts)
            ids.append(verts[k])
        if len(set(ids)) == 3:
            out.append(ids)
    return list(verts), out

def bbox(v):
    return [min(p[i] for p in v) for i in range(3)], [max(p[i] for p in v) for i in range(3)]

def mesh_xml(v, t, dx=0, dy=0, dz=0):
    vs = ''.join(f'<vertex x="{p[0]+dx:.5f}" y="{p[1]+dy:.5f}" z="{p[2]+dz:.5f}"/>' for p in v)
    ts = ''.join(f'<triangle v1="{a}" v2="{b}" v3="{c}"/>' for a, b, c in t)
    return f'<mesh><vertices>{vs}</vertices><triangles>{ts}</triangles></mesh>'

base = load_stl('export/box2A_base.stl')
lid = load_stl('export/box2A_lid.stl')
txt = load_stl('export/box2A_lidtext.stl')

# 版面：盒身在前，上蓋在後，間隔 10mm；全部移到正值座標
(bmin, bmax) = bbox(base[0]); (lmin, lmax) = bbox(lid[0] + txt[0])
ox = 20 - bmin[0]; oy = 20 - bmin[1]
lid_dy = oy + (bmax[1] - bmin[1]) + 10 - lmin[1] + bmin[1]
lid_dx = ox

model = f'''<?xml version="1.0" encoding="UTF-8"?>
<model unit="millimeter" xml:lang="en-US" xmlns="http://schemas.microsoft.com/3dmanufacturing/core/2015/02">
 <metadata name="Title">Ruler gift box - sliding lid - HAPPY BIRTHDAY</metadata>
 <resources>
  <basematerials id="1">
   <base name="Box (mustard)" displaycolor="#E9C46AFF"/>
   <base name="Lid (dark teal)" displaycolor="#264653FF"/>
   <base name="Text (white)" displaycolor="#FFFFFFFF"/>
  </basematerials>
  <object id="2" type="model" name="Box body" pid="1" pindex="0">{mesh_xml(*base, ox, oy, -bmin[2])}</object>
  <object id="3" type="model" name="Lid" pid="1" pindex="1">{mesh_xml(*lid, lid_dx, lid_dy, -lmin[2])}</object>
  <object id="4" type="model" name="Lid text (white)" pid="1" pindex="2">{mesh_xml(*txt, lid_dx, lid_dy, -lmin[2])}</object>
  <object id="5" type="model" name="Lid + HAPPY BIRTHDAY">
   <components><component objectid="3"/><component objectid="4"/></components>
  </object>
 </resources>
 <build>
  <item objectid="2"/>
  <item objectid="5"/>
 </build>
</model>'''

ct = '''<?xml version="1.0" encoding="UTF-8"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
 <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
 <Default Extension="model" ContentType="application/vnd.ms-package.3dmanufacturing-3dmodel+xml"/>
</Types>'''
rels = '''<?xml version="1.0" encoding="UTF-8"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
 <Relationship Target="/3D/3dmodel.model" Id="rel0" Type="http://schemas.microsoft.com/3dmanufacturing/2013/01/3dmodel"/>
</Relationships>'''
out = 'export/box2A_birthday.3mf'
with zipfile.ZipFile(out, 'w', zipfile.ZIP_DEFLATED) as z:
    z.writestr('[Content_Types].xml', ct)
    z.writestr('_rels/.rels', rels)
    z.writestr('3D/3dmodel.model', model)
print(out, os.path.getsize(out), 'bytes;', 'tris:', len(base[1]), len(lid[1]), len(txt[1]))
print('base bbox', [round(b-a,2) for a,b in zip(*bbox(base[0]))], 'lid bbox', [round(b-a,2) for a,b in zip(*bbox(lid[0]+txt[0]))])
