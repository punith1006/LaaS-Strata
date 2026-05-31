const fs = require('fs');
const path = 'src/components/home/mentor-sessions-tab-content.tsx';
let c = fs.readFileSync(path, 'utf8');

// Unique marker for LiveSessionSection
const marker = '{formatRemaining(s.startedAt, s.durationMinutes)}';
const mPos = c.indexOf(marker);
if (mPos === -1) { console.log('ERROR: marker not found'); process.exit(1); }

// Find the identity bar grid closing that comes after this marker
// Pattern: the identity bar grid closes with </div> then newline then whitespace then the 2-Column Grid comment
const gridPattern = '</div>\n\n                      {/* 2-Column Grid: Account | Socials */}';
const gridPos = c.indexOf(gridPattern, mPos);
if (gridPos === -1) { console.log('ERROR: grid pattern not found'); process.exit(1); }

// The identity bar grid closing </div> is at gridPos. Let's find the </div> that closes the right column block
// Right before the grid pattern, there's the right column block closing.
// The right column block has: )} followed by blank line, then the grid pattern
// But the button should be inserted AFTER the right column block AND after the )} that closes the conditional,
// right before the 2-Column Grid comment.

// Insert button text before the grid pattern
const buttonHtml = 
  '                        {/* Join Now */}\n' +
  '                        <button\n' +
  '                          onClick={(e) => { e.stopPropagation(); handleJoinNow(s.id); }}\n' +
  '                          style={{\n' +
  '                            backgroundColor: "var(--fgColor-default)",\n' +
  '                            color: "var(--bgColor-default)",\n' +
  '                            border: "1px solid var(--fgColor-default)",\n' +
  '                            borderRadius: "4px",\n' +
  '                            padding: "0 20px",\n' +
  '                            height: "36px",\n' +
  '                            cursor: "pointer",\n' +
  '                            fontWeight: 500,\n' +
  '                            fontFamily: "var(--font-sans)",\n' +
  '                            fontSize: "0.875rem",\n' +
  '                            whiteSpace: "nowrap",\n' +
  '                            transition: "opacity 0.15s ease",\n' +
  '                          }}\n' +
  '                          onMouseEnter={(e) => { e.currentTarget.style.opacity = "0.85"; }}\n' +
  '                          onMouseLeave={(e) => { e.currentTarget.style.opacity = "1"; }}\n' +
  '                        >\n' +
  '                          Join Now\n' +
  '                        </button>\n' +
  '                      ';
  
// Insert the button BEFORE the </div> that closes the identity bar grid
// We need to find the right closing </div> - it's the one at gridPos
// We insert before gridPos, inside the grid but before its closing
  
const before = c.substring(0, gridPos);
const after = c.substring(gridPos);
const result = before + buttonHtml + after;

fs.writeFileSync(path, result, 'utf8');
console.log('Done. Inserted button at position:', gridPos);
