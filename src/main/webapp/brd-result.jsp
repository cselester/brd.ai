<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
String brdContent  = (String) session.getAttribute("generatedBRD");
String projectName = (String) session.getAttribute("brdProjectName");
String editError   = (String) session.getAttribute("editError");
String editSuccess = (String) session.getAttribute("editSuccess");
if (brdContent == null) { response.sendRedirect("generate-brd.jsp"); return; }
if (editError   != null) session.removeAttribute("editError");
if (editSuccess != null) session.removeAttribute("editSuccess");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><%= projectName %> — BRD</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@300&family=Inter:wght@300;400&display=swap" rel="stylesheet">
<style>
:root {
  --color-forest-green: #0f3e17;
  --color-cream-canvas: #fffefc;
  --color-mint-glaze: #b1dbb8;
  --color-slate-mist: #b6ced5;
  --color-keylime-wash: #e1f4df;
  --color-mint-kiss: #cfe7d3;
  --color-border-grey: #e5e7eb;
  --color-ink-text: #222222;
  --color-dark-charcoal: #333333;
  --font-body: 'Inter', ui-sans-serif, system-ui, sans-serif;
  --font-display: 'Playfair Display', serif;
  --radius-cards: 14px;
  --radius-buttons: 14px;
  --radius-badges: 999px;
}
* { box-sizing: border-box; margin: 0; padding: 0; }
body {
  font-family: var(--font-body);
  background: var(--color-cream-canvas);
  color: var(--color-ink-text);
  min-height: 100vh;
  font-size: 14px;
  line-height: 1.5;
  letter-spacing: -0.42px;
}

/* NAV */
nav {
  display: flex; align-items: center; justify-content: space-between;
  padding: 14px 42px;
  border-bottom: 1px solid var(--color-border-grey);
  background: var(--color-cream-canvas);
  position: sticky; top: 0; z-index: 200;
}
.nav-left { display: flex; align-items: center; gap: 14px; }
.nav-brand { display: flex; align-items: center; gap: 10px; text-decoration: none; }
.nav-logo {
  width: 28px; height: 28px;
  background: var(--color-forest-green);
  border-radius: 7px;
  display: flex; align-items: center; justify-content: center;
  color: var(--color-cream-canvas); font-size: 14px;
}
.nav-title {
  font-family: var(--font-display);
  font-weight: 300; font-size: 16px;
  color: var(--color-forest-green); letter-spacing: -0.48px;
}
.nav-sep { color: var(--color-border-grey); font-size: 18px; }
.nav-project {
  font-size: 14px; font-weight: 400;
  color: var(--color-ink-text); letter-spacing: -0.42px;
}
.nav-badge {
  background: var(--color-keylime-wash);
  color: var(--color-forest-green);
  border: 1px solid var(--color-mint-glaze);
  padding: 4px 12px;
  border-radius: var(--radius-badges);
  font-size: 11px; font-weight: 400; letter-spacing: -0.33px;
}
.nav-right { display: flex; gap: 9px; }
.btn-sm {
  padding: 7px 14px;
  border-radius: var(--radius-buttons);
  font-family: var(--font-body);
  font-size: 13px; font-weight: 400;
  cursor: pointer; border: none;
  letter-spacing: -0.39px;
  transition: all 0.15s;
}
.btn-outline {
  background: transparent;
  border: 1px solid var(--color-border-grey);
  color: var(--color-dark-charcoal);
}
.btn-outline:hover { background: var(--color-keylime-wash); border-color: var(--color-mint-glaze); color: var(--color-forest-green); }
.btn-filled {
  background: var(--color-forest-green);
  color: var(--color-cream-canvas);
}
.btn-filled:hover { opacity: 0.88; }

/* LAYOUT */
.layout {
  display: grid;
  grid-template-columns: 1fr 340px;
  min-height: calc(100vh - 57px);
}

/* DOC PANEL */
.doc-panel {
  padding: 42px;
  overflow-y: auto;
  border-right: 1px solid var(--color-border-grey);
}

.doc-meta {
  display: flex; align-items: center; gap: 14px;
  margin-bottom: 28px;
}
.doc-meta-label {
  font-size: 11px; font-weight: 400;
  text-transform: uppercase; letter-spacing: 0.5px;
  color: var(--color-forest-green); opacity: 0.6;
}
.doc-meta-divider { color: var(--color-border-grey); }

.doc-title {
  font-family: var(--font-display);
  font-weight: 300;
  font-size: 28px;
  line-height: 1.3;
  letter-spacing: -0.84px;
  color: var(--color-forest-green);
  margin-bottom: 28px;
  padding-bottom: 21px;
  border-bottom: 1px solid var(--color-border-grey);
}

.brd-body {
  background: var(--color-keylime-wash);
  border-radius: var(--radius-cards);
  border: 1px solid var(--color-mint-glaze);
  padding: 42px;
  line-height: 1.8;
  font-size: 14px;
  color: var(--color-dark-charcoal);
  font-weight: 300;
}
.brd-body h2 {
  font-family: var(--font-display);
  font-weight: 300;
  font-size: 18px;
  color: var(--color-forest-green);
  margin: 28px 0 10px;
  padding-bottom: 7px;
  border-bottom: 1px solid var(--color-mint-glaze);
  letter-spacing: -0.54px;
}
.brd-body h2:first-child { margin-top: 0; }
.brd-body ul { padding-left: 20px; margin: 8px 0 14px; }
.brd-body li { margin-bottom: 6px; }
.brd-body p { margin-bottom: 12px; }

/* EDIT PANEL */
.edit-panel {
  background: var(--color-mint-kiss);
  border-left: 1px solid var(--color-mint-glaze);
  padding: 28px 21px;
  display: flex; flex-direction: column; gap: 21px;
  overflow-y: auto;
}

.edit-section-title {
  font-size: 11px; font-weight: 400;
  text-transform: uppercase; letter-spacing: 0.5px;
  color: var(--color-forest-green); opacity: 0.65;
}

.alert-sm {
  padding: 11px 14px;
  border-radius: var(--radius-cards);
  font-size: 13px; line-height: 1.5;
  display: flex; gap: 8px; align-items: flex-start;
}
.alert-success { background: var(--color-keylime-wash); border: 1px solid var(--color-mint-glaze); color: var(--color-forest-green); }
.alert-error { background: #fef2f2; border: 1px solid #fecaca; color: #dc2626; }

/* Chips */
.chips-label { font-size: 11px; color: var(--color-dark-charcoal); opacity: 0.6; margin-bottom: 8px; }
.chips { display: flex; flex-wrap: wrap; gap: 7px; }
.chip {
  background: var(--color-cream-canvas);
  border: 1px solid var(--color-border-grey);
  color: var(--color-dark-charcoal);
  padding: 6px 12px;
  border-radius: var(--radius-badges);
  font-size: 12px; font-weight: 300; cursor: pointer;
  transition: all 0.15s; letter-spacing: -0.36px;
}
.chip:hover {
  background: var(--color-keylime-wash);
  border-color: var(--color-mint-glaze);
  color: var(--color-forest-green);
}

.divider { border: none; border-top: 1px solid var(--color-mint-glaze); }

/* Textarea */
.edit-textarea {
  width: 100%;
  background: var(--color-cream-canvas);
  border: 1px solid var(--color-border-grey);
  border-radius: var(--radius-buttons);
  color: var(--color-ink-text);
  font-family: var(--font-body);
  font-size: 14px; font-weight: 300;
  letter-spacing: -0.42px;
  padding: 12px 14px;
  resize: vertical; min-height: 100px;
  outline: none; line-height: 1.6;
  transition: border-color 0.2s, box-shadow 0.2s;
}
.edit-textarea:focus {
  border-color: var(--color-forest-green);
  box-shadow: 0 0 0 3px rgba(15,62,23,0.08);
}
.edit-textarea::placeholder { color: #bbb; }

.char-hint { text-align: right; font-size: 11px; color: var(--color-dark-charcoal); opacity: 0.45; margin-top: 4px; }

.btn-apply {
  width: 100%;
  padding: 12px 18px;
  background: var(--color-forest-green);
  color: var(--color-cream-canvas);
  border: none; border-radius: var(--radius-buttons);
  font-family: var(--font-body);
  font-size: 14px; font-weight: 400; letter-spacing: -0.42px;
  cursor: pointer; transition: opacity 0.2s;
  display: flex; align-items: center; justify-content: center; gap: 8px;
}
.btn-apply:hover { opacity: 0.88; }
.btn-apply:disabled { opacity: 0.5; cursor: not-allowed; }

.spinner {
  display: none; width: 14px; height: 14px;
  border: 2px solid rgba(255,255,255,0.35);
  border-top-color: #fff; border-radius: 50%;
  animation: spin 0.7s linear infinite;
}
@keyframes spin { to { transform: rotate(360deg); } }

/* History */
.history { display: flex; flex-direction: column; gap: 7px; }
.history-item {
  background: var(--color-cream-canvas);
  border: 1px solid var(--color-border-grey);
  border-radius: var(--radius-cards);
  padding: 9px 12px;
  font-size: 12px; font-weight: 300;
  color: var(--color-dark-charcoal);
  display: flex; justify-content: space-between; align-items: flex-start; gap: 8px;
  letter-spacing: -0.36px;
}
.history-item span { flex: 1; line-height: 1.5; }
.history-empty { font-size: 12px; color: var(--color-dark-charcoal); opacity: 0.4; text-align: center; padding: 8px 0; }

@media print {
  nav, .edit-panel { display: none !important; }
  .layout { grid-template-columns: 1fr; }
  .brd-body { background: white; border: none; color: black; }
  .brd-body h2 { color: var(--color-forest-green); border-color: #ddd; }
}

@media (max-width: 900px) {
  .layout { grid-template-columns: 1fr; }
  .doc-panel { border-right: none; border-bottom: 1px solid var(--color-border-grey); }
  nav { padding: 12px 21px; }
  .nav-sep, .nav-project { display: none; }
}
</style>
</head>
<body>

<nav>
  <div class="nav-left">
    <a href="generate-brd.jsp" class="nav-brand">
      <div class="nav-logo">📄</div>
      <span class="nav-title">BRD Generator</span>
    </a>
    <span class="nav-sep">/</span>
    <span class="nav-project"><%= projectName %></span>
    <span class="nav-badge">BRD</span>
  </div>
  <div class="nav-right">
    <button class="btn-sm btn-outline" onclick="window.print()">Print</button>
    <button class="btn-sm btn-filled" onclick="copyBRD(this)">Copy</button>
  </div>
</nav>

<div class="layout">

  <!-- LEFT: DOCUMENT -->
  <div class="doc-panel">
    <div class="doc-meta">
      <span class="doc-meta-label">Business Requirements Document</span>
      <span class="doc-meta-divider">·</span>
      <span class="doc-meta-label">Generated by AI</span>
    </div>
    <div class="doc-title"><%= projectName %></div>
    <div class="brd-body" id="brdBody">
      <%= brdContent %>
    </div>
  </div>

  <!-- RIGHT: EDIT -->
  <div class="edit-panel">

    <div class="edit-section-title">✦ Edit with AI</div>

    <% if (editSuccess != null) { %>
    <div class="alert-sm alert-success">✓ <%= editSuccess %></div>
    <% } %>
    <% if (editError != null) { %>
    <div class="alert-sm alert-error">⚠ <%= editError %></div>
    <% } %>

    <div>
      <div class="chips-label">Quick edits</div>
      <div class="chips">
        <span class="chip" onclick="setInstr('Add payment gateway requirement')">+ Payment gateway</span>
        <span class="chip" onclick="setInstr('Add user authentication and login requirements')">+ Authentication</span>
        <span class="chip" onclick="setInstr('Add mobile app support requirement')">+ Mobile support</span>
        <span class="chip" onclick="setInstr('Add data security and encryption requirements')">+ Security</span>
        <span class="chip" onclick="setInstr('Add third-party API integration requirement')">+ API integration</span>
        <span class="chip" onclick="setInstr('Make the tone more formal and professional')">Formal tone</span>
        <span class="chip" onclick="setInstr('Add performance and scalability requirements')">+ Performance</span>
        <span class="chip" onclick="setInstr('Expand the Executive Summary section')">Expand summary</span>
      </div>
    </div>

    <hr class="divider">

    <form action="EditBRDServlet" method="post" onsubmit="return onEdit()">
      <input type="hidden" name="existingBRD" id="existingBRD">
      <input type="hidden" name="projectName" value="<%= projectName %>">

      <textarea class="edit-textarea" name="userInstruction" id="instr"
        placeholder="Describe your change…&#10;e.g. Add payment gateway requirement so users can make payments"
        maxlength="500" oninput="updateIC()"></textarea>
      <div class="char-hint"><span id="ic">0</span>/500</div>

      <br>

      <button type="submit" class="btn-apply" id="applyBtn">
        <span class="spinner" id="sp"></span>
        <span id="applyTxt">Apply Edit</span>
      </button>
    </form>

    <hr class="divider">

    <div class="edit-section-title">History</div>
    <div class="history" id="historyList">
      <div class="history-empty" id="historyEmpty">No edits yet</div>
    </div>

  </div>
</div>

<script>
const brdBody = document.getElementById('brdBody');

function setInstr(t) {
  const ta = document.getElementById('instr');
  ta.value = t; ta.focus(); updateIC();
}
function updateIC() {
  document.getElementById('ic').textContent = document.getElementById('instr').value.length;
}
function onEdit() {
  const v = document.getElementById('instr').value.trim();
  if (!v) { alert('Please enter an instruction.'); return false; }
  const h = JSON.parse(localStorage.getItem('brdHistory') || '[]');
  h.unshift({ text: v, time: new Date().toLocaleTimeString() });
  localStorage.setItem('brdHistory', JSON.stringify(h.slice(0,10)));
  document.getElementById('existingBRD').value = brdBody.innerHTML;
  document.getElementById('sp').style.display = 'block';
  document.getElementById('applyTxt').textContent = 'Applying…';
  document.getElementById('applyBtn').disabled = true;
  return true;
}
function copyBRD(btn) {
  navigator.clipboard.writeText(brdBody.innerText).then(() => {
    btn.textContent = '✓ Copied';
    setTimeout(() => btn.textContent = 'Copy', 2000);
  });
}
function renderHistory() {
  const h = JSON.parse(localStorage.getItem('brdHistory') || '[]');
  if (!h.length) return;
  const list = document.getElementById('historyList');
  document.getElementById('historyEmpty').style.display = 'none';
  h.forEach(item => {
    const d = document.createElement('div');
    d.className = 'history-item';
    d.innerHTML = `<span>"${item.text}"</span><small style="color:#aaa;white-space:nowrap">${item.time}</small>`;
    list.appendChild(d);
  });
}
renderHistory();
</script>
</body>
</html>
