const fs = require('fs');
const c = fs.readFileSync('src/components/mentor/mentor-user-sessions-tab.tsx', 'utf8');
const comm = '{/* Account | Socials */}';
let pos = c.indexOf(comm);
let tp = pos;
let cnt = 1;
while (pos !== -1 && cnt < 3) {
  pos = c.indexOf(comm, pos + 1);
  if (pos !== -1) { tp = pos; cnt++; }
}
console.log('Inserting at:', tp);
const btn = '\n                      {/* Join Now */}\n                      <div style={{ display: "flex", justifyContent: "flex-end", marginTop: "12px" }}>\n                        <button onClick={(e) => { e.stopPropagation(); handleJoinNow(s.id); }} style={{ backgroundColor: "var(--fgColor-default)", color: "var(--bgColor-default)", border: "1px solid var(--fgColor-default)", borderRadius: "4px", padding: "0 20px", height: "36px", cursor: "pointer", fontWeight: 500, fontFamily: "var(--font-sans)", fontSize: "0.875rem", whiteSpace: "nowrap", transition: "opacity 0.15s ease" }} onMouseEnter={(e) => { e.currentTarget.style.opacity = "0.85"; }} onMouseLeave={(e) => { e.currentTarget.style.opacity = "1"; }}>Join Now</button></div>\n                    ';
const result = c.slice(0, tp) + btn + c.slice(tp);
fs.writeFileSync('src/components/mentor/mentor-user-sessions-tab.tsx', result, 'utf8');
console.log('Done');
