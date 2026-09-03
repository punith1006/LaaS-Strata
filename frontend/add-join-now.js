const fs = require('fs');
const path = 'src/components/home/mentor-sessions-tab-content.tsx';
let c = fs.readFileSync(path, 'utf8');

// 1. Find LiveSessionSection via its unique LiveActionDropdown
const anchor = '<LiveActionDropdown';
const anchorPos = c.indexOf(anchor);

// 2. Find the FIRST 2-Column Grid comment after LiveActionDropdown (LiveSessionSection is first after it)
const gridComm = '{/* 2-Column Grid: Account | Socials */}';
const gridPos = c.indexOf(gridComm, anchorPos);

// 3. Insert Join Now button before this grid comment
const buttonHtml = [
  '',
  '                      {/* Join Now */}',
  '                      <div style={{ display: "flex", justifyContent: "flex-end", marginTop: "12px" }}>',
  '                        <button',
  '                          onClick={(e) => { e.stopPropagation(); handleJoinNow(s.id); }}',
  '                          style={{',
  '                            backgroundColor: "var(--fgColor-default)",',
  '                            color: "var(--bgColor-default)",',
  '                            border: "1px solid var(--fgColor-default)",',
  '                            borderRadius: "4px",',
  '                            padding: "0 20px",',
  '                            height: "36px",',
  '                            cursor: "pointer",',
  '                            fontWeight: 500,',
  '                            fontFamily: "var(--font-sans)",',
  '                            fontSize: "0.875rem",',
  '                            whiteSpace: "nowrap",',
  '                            transition: "opacity 0.15s ease",',
  '                          }}',
  '                          onMouseEnter={(e) => { e.currentTarget.style.opacity = "0.85"; }}',
  '                          onMouseLeave={(e) => { e.currentTarget.style.opacity = "1"; }}',
  '                        >',
  '                          Join Now',
  '                        </button>',
  '                      </div>',
  '                    ',
].join('\r\n');

// Insert right before the grid comment
const result = c.slice(0, gridPos) + buttonHtml + c.slice(gridPos);
fs.writeFileSync(path, result, 'utf8');
console.log('Done. Inserted at position:', gridPos);
