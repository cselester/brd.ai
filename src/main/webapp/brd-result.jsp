<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
String brdContent  = (String) session.getAttribute("generatedBRD");
String projectName = (String) session.getAttribute("brdProjectName");
String editError   = (String) session.getAttribute("editError");
String editSuccess = (String) session.getAttribute("editSuccess");

if (brdContent == null) {
    response.sendRedirect("generate-brd.jsp");
    return;
}

// Clear one-time flash messages
if (editError   != null) session.removeAttribute("editError");
if (editSuccess != null) session.removeAttribute("editSuccess");

// Keep BRD + project in session so editing works across refreshes
// (they'll be cleared when user navigates away)
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><%= projectName %> — BRD</title>
<style>
  * { box-sizing: border-box; margin: 0; padding: 0; }

  body {
    font-family: 'Segoe UI', system-ui, sans-serif;
    background: #0f0e17;
    min-height: 100vh;
    color: #e2e8f0;
  }

  /* ── TOP BAR ── */
  .topbar {
    background: rgba(255,255,255,0.04);
    border-bottom: 1px solid rgba(255,255,255,0.1);
    padding: 14px 32px;
    display: flex;
    align-items: center;
    justify-content: space-between;
    position: sticky;
    top: 0;
    z-index: 200;
    backdrop-filter: blur(12px);
  }
  .topbar-left { display: flex; align-items: center; gap: 14px; }
  .topbar a {
    color: rgba(255,255,255,0.45);
    text-decoration: none;
    font-size: 13px;
  }
  .topbar a:hover { color: #a78bfa; }
  .topbar h1 { font-size: 0.95rem; font-weight: 600; color: #fff; }
  .badge {
    background: rgba(167,139,250,0.15);
    color: #a78bfa;
    border: 1px solid rgba(167,139,250,0.3);
    padding: 2px 10px;
    border-radius: 20px;
    font-size: 11px;
    font-weight: 700;
    letter-spacing: 0.5px;
    text-transform: uppercase;
  }
  .topbar-right { display: flex; gap: 8px; }

  /* ── BUTTONS ── */
  .btn {
    padding: 8px 16px;
    border-radius: 8px;
    font-size: 13px;
    font-weight: 600;
    cursor: pointer;
    border: none;
    transition: all 0.2s;
    display: inline-flex;
    align-items: center;
    gap: 6px;
  }
  .btn-outline {
    background: transparent;
    border: 1px solid rgba(255,255,255,0.18);
    color: rgba(255,255,255,0.65);
  }
  .btn-outline:hover { background: rgba(255,255,255,0.08); color: #fff; }
  .btn-primary {
    background: linear-gradient(135deg, #7c3aed, #4f46e5);
    color: #fff;
    box-shadow: 0 3px 12px rgba(124,58,237,0.35);
  }
  .btn-primary:hover { opacity: 0.9; transform: translateY(-1px); }
  .btn-primary:disabled { opacity: 0.55; cursor: not-allowed; transform: none; }
  .btn-ghost {
    background: transparent;
    color: rgba(255,255,255,0.4);
    border: none;
    padding: 6px 10px;
  }
  .btn-ghost:hover { color: #f87171; }

  /* ── LAYOUT ── */
  .page {
    display: grid;
    grid-template-columns: 1fr 360px;
    gap: 0;
    min-height: calc(100vh - 57px);
  }

  /* ── BRD DOCUMENT PANEL ── */
  .doc-panel {
    padding: 36px 40px 80px;
    overflow-y: auto;
    border-right: 1px solid rgba(255,255,255,0.06);
  }

  .doc-header {
    margin-bottom: 28px;
    padding: 24px 28px;
    background: linear-gradient(135deg, rgba(124,58,237,0.12), rgba(79,70,229,0.08));
    border: 1px solid rgba(124,58,237,0.22);
    border-radius: 14px;
  }
  .doc-header .label {
    text-transform: uppercase;
    font-size: 10px;
    font-weight: 700;
    letter-spacing: 2px;
    color: #a78bfa;
    margin-bottom: 6px;
  }
  .doc-header h2 { font-size: 1.4rem; color: #fff; margin-bottom: 4px; }
  .doc-header p  { color: rgba(255,255,255,0.38); font-size: 12px; }

  .brd-content {
    background: #1a1a2e;
    border: 1px solid rgba(255,255,255,0.07);
    border-radius: 14px;
    padding: 36px;
    line-height: 1.85;
    font-size: 15px;
  }
  .brd-content h2 {
    color: #a78bfa;
    font-size: 1.05rem;
    font-weight: 700;
    margin: 28px 0 10px;
    padding-bottom: 7px;
    border-bottom: 1px solid rgba(167,139,250,0.18);
  }
  .brd-content h2:first-child { margin-top: 0; }
  .brd-content ul  { padding-left: 22px; margin: 6px 0 14px; }
  .brd-content li  { margin-bottom: 5px; color: #94a3b8; }
  .brd-content p   { margin-bottom: 10px; color: #94a3b8; }
  .brd-content hr  { border: none; border-top: 1px solid rgba(255,255,255,0.07); margin: 20px 0; }

  /* ── EDIT SIDEBAR ── */
  .edit-panel {
    background: #13121f;
    display: flex;
    flex-direction: column;
    padding: 24px 20px;
    gap: 16px;
    overflow-y: auto;
  }

  .edit-panel h3 {
    font-size: 0.85rem;
    font-weight: 700;
    color: rgba(255,255,255,0.5);
    text-transform: uppercase;
    letter-spacing: 1px;
  }

  /* Flash alerts */
  .alert {
    padding: 11px 14px;
    border-radius: 10px;
    font-size: 13px;
    display: flex;
    align-items: flex-start;
    gap: 8px;
    line-height: 1.5;
  }
  .alert-success {
    background: rgba(16,185,129,0.12);
    border: 1px solid rgba(16,185,129,0.28);
    color: #34d399;
  }
  .alert-error {
    background: rgba(239,68,68,0.12);
    border: 1px solid rgba(239,68,68,0.28);
    color: #f87171;
  }

  /* Suggestions chips */
  .suggestions-label {
    font-size: 11px;
    color: rgba(255,255,255,0.35);
    margin-bottom: 6px;
  }
  .chips { display: flex; flex-wrap: wrap; gap: 7px; }
  .chip {
    background: rgba(255,255,255,0.06);
    border: 1px solid rgba(255,255,255,0.12);
    color: rgba(255,255,255,0.6);
    padding: 5px 11px;
    border-radius: 20px;
    font-size: 12px;
    cursor: pointer;
    transition: all 0.18s;
    line-height: 1.4;
  }
  .chip:hover {
    background: rgba(124,58,237,0.2);
    border-color: rgba(124,58,237,0.4);
    color: #c4b5fd;
  }

  /* Text area */
  .edit-textarea {
    width: 100%;
    background: rgba(255,255,255,0.06);
    border: 1px solid rgba(255,255,255,0.13);
    border-radius: 10px;
    color: #fff;
    font-size: 14px;
    font-family: inherit;
    padding: 12px 14px;
    resize: vertical;
    min-height: 110px;
    outline: none;
    transition: border-color 0.2s, box-shadow 0.2s;
    line-height: 1.6;
  }
  .edit-textarea:focus {
    border-color: #7c3aed;
    box-shadow: 0 0 0 3px rgba(124,58,237,0.18);
  }
  .edit-textarea::placeholder { color: rgba(255,255,255,0.25); }

  /* Spinner */
  .spinner {
    display: none;
    width: 15px; height: 15px;
    border: 2px solid rgba(255,255,255,0.3);
    border-top-color: #fff;
    border-radius: 50%;
    animation: spin 0.7s linear infinite;
    flex-shrink: 0;
  }
  @keyframes spin { to { transform: rotate(360deg); } }

  /* History log */
  .history { display: flex; flex-direction: column; gap: 8px; }
  .history-item {
    background: rgba(255,255,255,0.04);
    border: 1px solid rgba(255,255,255,0.08);
    border-radius: 8px;
    padding: 9px 12px;
    font-size: 12px;
    color: rgba(255,255,255,0.45);
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    gap: 8px;
  }
  .history-item span { flex: 1; line-height: 1.5; }
  .history-empty {
    font-size: 12px;
    color: rgba(255,255,255,0.22);
    text-align: center;
    padding: 10px 0;
  }

  .divider {
    border: none;
    border-top: 1px solid rgba(255,255,255,0.07);
    margin: 4px 0;
  }

  /* ── PRINT ── */
  @media print {
    .topbar, .edit-panel { display: none !important; }
    .page { grid-template-columns: 1fr; }
    body { background: white; color: black; }
    .brd-content { background: white; color: black; border: none; padding: 0; }
    .brd-content h2 { color: #1a237e; }
    .brd-content li, .brd-content p { color: #333; }
    .doc-header { background: #f0f0ff; border-color: #c5cae9; }
    .doc-header h2, .doc-header .label { color: #1a237e; }
    .doc-header p { color: #555; }
  }

  /* ── MOBILE ── */
  @media (max-width: 768px) {
    .page { grid-template-columns: 1fr; }
    .doc-panel { border-right: none; border-bottom: 1px solid rgba(255,255,255,0.06); padding: 20px; }
    .edit-panel { padding: 20px; }
    .topbar { padding: 12px 16px; }
  }
</style>
</head>
<body>

<!-- TOP BAR -->
<div class="topbar">
  <div class="topbar-left">
    <a href="generate-brd.jsp">← Back</a>
    <h1><%= projectName %></h1>
    <span class="badge">BRD</span>
  </div>
  <div class="topbar-right">
    <button class="btn btn-outline" onclick="window.print()">🖨 Print</button>
    <button class="btn btn-outline" onclick="copyBRD(this)">Copy</button>
  </div>
</div>

<div class="page">

  <!-- LEFT: BRD DOCUMENT -->
  <div class="doc-panel">
    <div class="doc-header">
      <div class="label">Business Requirements Document</div>
      <h2><%= projectName %></h2>
      <p>Generated by AI &nbsp;·&nbsp; Use the editor on the right to refine</p>
    </div>
    <div class="brd-content" id="brdBody">
      <%= brdContent %>
    </div>
  </div>

  <!-- RIGHT: EDIT PANEL -->
  <div class="edit-panel">

    <h3>✏ Edit with AI</h3>

    <!-- Flash messages -->
    <% if (editSuccess != null) { %>
    <div class="alert alert-success">✓ <%= editSuccess %></div>
    <% } %>
    <% if (editError != null) { %>
    <div class="alert alert-error">⚠ <%= editError %></div>
    <% } %>

    <!-- Quick suggestion chips -->
    <div>
      <div class="suggestions-label">Quick edits</div>
      <div class="chips">
        <span class="chip" onclick="setInstruction('Add payment gateway requirement')">+ Payment gateway</span>
        <span class="chip" onclick="setInstruction('Add user authentication and login requirements')">+ Authentication</span>
        <span class="chip" onclick="setInstruction('Add mobile app support requirement')">+ Mobile support</span>
        <span class="chip" onclick="setInstruction('Add data security and encryption requirements')">+ Security</span>
        <span class="chip" onclick="setInstruction('Add third-party API integration requirement')">+ API integration</span>
        <span class="chip" onclick="setInstruction('Make the tone more formal and professional')">Formal tone</span>
        <span class="chip" onclick="setInstruction('Add performance and scalability requirements')">+ Performance</span>
        <span class="chip" onclick="setInstruction('Expand the Executive Summary section')">Expand summary</span>
      </div>
    </div>

    <hr class="divider">

    <!-- Instruction input -->
    <form action="EditBRDServlet" method="post" onsubmit="return onEditSubmit()">
      <input type="hidden" name="existingBRD"  id="existingBRD"  value="<%= brdContent.replace("\"", "&quot;").replace("<", "&lt;").replace(">", "&gt;") %>">
      <input type="hidden" name="projectName"  value="<%= projectName %>">

      <textarea
        class="edit-textarea"
        name="userInstruction"
        id="userInstruction"
        placeholder="Describe your change…&#10;e.g. Add payment gateway requirement so users can make payments"
        maxlength="500"></textarea>

      <div style="text-align:right; font-size:11px; color:rgba(255,255,255,0.25); margin: 4px 0 10px;">
        <span id="instrCount">0</span>/500
      </div>

      <button type="submit" class="btn btn-primary" id="editBtn" style="width:100%;">
        <span class="spinner" id="editSpinner"></span>
        <span id="editBtnText">Apply Edit</span>
      </button>
    </form>

    <hr class="divider">

    <!-- Edit history (client-side) -->
    <h3>📋 Edit History</h3>
    <div class="history" id="historyList">
      <div class="history-empty" id="historyEmpty">No edits yet</div>
    </div>

  </div>
</div>

<script>
  // Populate hidden field with live BRD HTML for editing
  const brdBody = document.getElementById('brdBody');

  function setInstruction(text) {
    const ta = document.getElementById('userInstruction');
    ta.value = text;
    ta.focus();
    updateInstrCount();
  }

  function updateInstrCount() {
    const ta = document.getElementById('userInstruction');
    document.getElementById('instrCount').textContent = ta.value.length;
  }
  document.getElementById('userInstruction').addEventListener('input', updateInstrCount);

  function onEditSubmit() {
    const instr = document.getElementById('userInstruction').value.trim();
    if (!instr) {
      alert('Please enter an instruction.');
      return false;
    }

    // Save to local edit history
    const history = JSON.parse(localStorage.getItem('brdEditHistory') || '[]');
    history.unshift({ text: instr, time: new Date().toLocaleTimeString() });
    localStorage.setItem('brdEditHistory', JSON.stringify(history.slice(0, 10)));

    // Sync hidden field with current rendered BRD content
    document.getElementById('existingBRD').value = brdBody.innerHTML;

    // Show loading state
    document.getElementById('editSpinner').style.display = 'block';
    document.getElementById('editBtnText').textContent = 'Applying...';
    document.getElementById('editBtn').disabled = true;
    return true;
  }

  function copyBRD(btn) {
    navigator.clipboard.writeText(brdBody.innerText).then(() => {
      btn.textContent = '✓ Copied!';
      setTimeout(() => btn.textContent = 'Copy', 2000);
    });
  }

  // Render local edit history on load
  function renderHistory() {
    const history = JSON.parse(localStorage.getItem('brdEditHistory') || '[]');
    const list = document.getElementById('historyList');
    const empty = document.getElementById('historyEmpty');
    if (history.length === 0) return;
    empty.style.display = 'none';
    history.forEach(item => {
      const div = document.createElement('div');
      div.className = 'history-item';
      div.innerHTML = `<span>"${item.text}"</span><small style="color:rgba(255,255,255,0.2);white-space:nowrap">${item.time}</small>`;
      list.appendChild(div);
    });
  }
  renderHistory();
</script>
</body>
</html>
