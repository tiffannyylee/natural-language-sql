"""Generate an SVG schema diagram from setup.sql — no dependencies required."""
import re

# --- Parse setup.sql ---
with open("setup.sql") as f:
    sql = f.read()

tables = {}
foreign_keys = []

for match in re.finditer(
    r"CREATE TABLE (\w+)\s*\((.*?)\);", sql, re.DOTALL
):
    table_name = match.group(1)
    body = match.group(2)
    columns = []
    for line in body.split("\n"):
        line = line.strip().rstrip(",")
        if not line:
            continue
        fk = re.match(r"FOREIGN KEY \((\w+)\) REFERENCES (\w+)\((\w+)\)", line)
        if fk:
            foreign_keys.append((table_name, fk.group(1), fk.group(2), fk.group(3)))
            continue
        if line.upper().startswith(("CHECK", "UNIQUE", "PRIMARY KEY(")):
            continue
        col_match = re.match(r"(\w+)\s+([\w()]+)(.*)", line)
        if col_match:
            name = col_match.group(1)
            dtype = col_match.group(2)
            rest = col_match.group(3)
            pk = "PRIMARY" in rest.upper()
            nn = "NOT NULL" in rest.upper()
            uq = "UNIQUE" in rest.upper()
            flags = []
            if pk:
                flags.append("PK")
            if nn and not pk:
                flags.append("NN")
            if uq:
                flags.append("UQ")
            columns.append((name, dtype, flags))
    tables[table_name] = columns

# --- Layout ---
col_w = 240
header_h = 32
row_h = 22
pad_x = 60
pad_y = 50

# Arrange in a grid: 4 columns
grid_cols = 4
positions = {}
table_names = list(tables.keys())
for i, t in enumerate(table_names):
    gx = i % grid_cols
    gy = i // grid_cols
    x = pad_x + gx * (col_w + pad_x)
    y = pad_y + gy * 260
    positions[t] = (x, y)

def table_height(t):
    return header_h + len(tables[t]) * row_h + 6

def escape(s):
    return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")

# --- SVG generation ---
max_x = max(x + col_w for x, _ in positions.values()) + pad_x
max_y = max(y + table_height(t) for t, (_, y) in positions.items()) + pad_y
svg = []
svg.append(f'<svg xmlns="http://www.w3.org/2000/svg" width="{max_x}" height="{max_y}" font-family="Segoe UI, Helvetica, Arial, sans-serif" font-size="12">')
svg.append('<defs><style>')
svg.append('  .header { fill: #4A90D9; } .header-text { fill: white; font-weight: bold; font-size: 13px; }')
svg.append('  .col-name { fill: #222; } .col-type { fill: #888; font-size: 11px; }')
svg.append('  .col-flag { fill: #D9534F; font-size: 10px; font-weight: bold; }')
svg.append('  .table-bg { fill: white; stroke: #ccc; stroke-width: 1; rx: 6; }')
svg.append('  .fk-line { stroke: #D9534F; stroke-width: 1.5; fill: none; marker-end: url(#arrow); }')
svg.append('</style>')
svg.append('<marker id="arrow" viewBox="0 0 10 10" refX="10" refY="5" markerWidth="8" markerHeight="8" orient="auto-start-reverse">')
svg.append('  <path d="M 0 0 L 10 5 L 0 10 z" fill="#D9534F"/>')
svg.append('</marker></defs>')
svg.append(f'<rect width="{max_x}" height="{max_y}" fill="#F7F7F7"/>')

# Draw tables
for t, cols in tables.items():
    x, y = positions[t]
    h = table_height(t)
    svg.append(f'<rect x="{x}" y="{y}" width="{col_w}" height="{h}" class="table-bg"/>')
    svg.append(f'<rect x="{x}" y="{y}" width="{col_w}" height="{header_h}" class="header" rx="6"/>')
    # square off bottom corners of header
    svg.append(f'<rect x="{x}" y="{y+header_h-8}" width="{col_w}" height="8" class="header"/>')
    svg.append(f'<text x="{x + col_w//2}" y="{y + 21}" text-anchor="middle" class="header-text">{escape(t)}</text>')
    for i, (cname, ctype, flags) in enumerate(cols):
        cy = y + header_h + 4 + i * row_h + 15
        flag_str = " " + ",".join(flags) if flags else ""
        svg.append(f'<text x="{x+10}" y="{cy}" class="col-name">{escape(cname)}</text>')
        svg.append(f'<text x="{x+140}" y="{cy}" class="col-type">{escape(ctype)}</text>')
        if flag_str.strip():
            svg.append(f'<text x="{x+210}" y="{cy}" class="col-flag">{escape(flag_str.strip())}</text>')

# Draw FK relationships with curved lines
for src_table, src_col, tgt_table, tgt_col in foreign_keys:
    sx, sy = positions[src_table]
    tx, ty = positions[tgt_table]
    # find row index
    src_idx = next(i for i, (c, *_) in enumerate(tables[src_table]) if c == src_col)
    tgt_idx = next(i for i, (c, *_) in enumerate(tables[tgt_table]) if c == tgt_col)
    # connection points
    src_cy = sy + header_h + 4 + src_idx * row_h + 10
    tgt_cy = ty + header_h + 4 + tgt_idx * row_h + 10

    # decide which side to connect from
    if sx > tx + col_w:  # src is to the right
        x1, x2 = sx, tx + col_w
    elif tx > sx + col_w:  # src is to the left
        x1, x2 = sx + col_w, tx
    else:  # same column — go out the sides
        x1 = sx + col_w
        x2 = tx + col_w
    mid_x = (x1 + x2) / 2
    svg.append(f'<path d="M {x1} {src_cy} C {mid_x} {src_cy}, {mid_x} {tgt_cy}, {x2} {tgt_cy}" class="fk-line"/>')

svg.append('</svg>')

out = "schema.svg"
with open(out, "w") as f:
    f.write("\n".join(svg))
print(f"Schema diagram saved to {out}")
