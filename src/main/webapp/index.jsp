<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
String successProject = (String) session.getAttribute("uploadSuccess");
String errorMsg = (String) session.getAttribute("uploadError");
if (successProject != null) session.removeAttribute("uploadSuccess");
if (errorMsg != null) session.removeAttribute("uploadError");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>BRD Generator — Upload</title>
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
  --card-padding: 42px;
  --element-gap: 21px;
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
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 18px 42px;
  border-bottom: 1px solid var(--color-border-grey);
  background: var(--color-cream-canvas);
  position: sticky;
  top: 0;
  z-index: 100;
}

.nav-brand {
  display: flex;
  align-items: center;
  gap: 10px;
  text-decoration: none;
}

.nav-logo {
  width: 32px; height: 32px;
  background: var(--color-forest-green);
  border-radius: 8px;
  display: flex; align-items: center; justify-content: center;
  color: var(--color-cream-canvas);
  font-size: 16px;
}

.nav-title {
  font-family: var(--font-display);
  font-weight: 300;
  font-size: 18px;
  color: var(--color-forest-green);
  letter-spacing: -0.54px;
}

.nav-pill {
  background: var(--color-cream-canvas);
  color: var(--color-forest-green);
  border: 1px solid var(--color-border-grey);
  padding: 9px 18px;
  border-radius: var(--radius-badges);
  font-size: 12px;
  font-weight: 400;
  letter-spacing: -0.36px;
  text-decoration: none;
  transition: background 0.2s;
}
.nav-pill:hover { background: var(--color-keylime-wash); }

/* PAGE */
.page {
  max-width: 1100px;
  margin: 0 auto;
  padding: 56px 42px;
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 42px;
  align-items: start;
}

/* LEFT HERO */
.hero {
  padding-top: 14px;
}

.hero-badge {
  display: inline-block;
  background: var(--color-keylime-wash);
  color: var(--color-forest-green);
  border: 1px solid var(--color-mint-glaze);
  padding: 7px 14px;
  border-radius: var(--radius-badges);
  font-size: 12px;
  font-weight: 400;
  letter-spacing: -0.36px;
  margin-bottom: 21px;
}

.hero h1 {
  font-family: var(--font-display);
  font-weight: 300;
  font-size: 40px;
  line-height: 1.05;
  letter-spacing: -0.4px;
  color: var(--color-forest-green);
  margin-bottom: 18px;
}

.hero p {
  font-size: 18px;
  font-weight: 300;
  line-height: 1.5;
  letter-spacing: -0.54px;
  color: var(--color-dark-charcoal);
  margin-bottom: 35px;
  max-width: 380px;
}

.steps {
  display: flex;
  flex-direction: column;
  gap: 14px;
}

.step {
  display: flex;
  align-items: flex-start;
  gap: 14px;
  padding: 18px 21px;
  background: var(--color-keylime-wash);
  border-radius: var(--radius-cards);
  border: 1px solid var(--color-mint-glaze);
}

.step-num {
  width: 28px; height: 28px;
  background: var(--color-forest-green);
  color: var(--color-cream-canvas);
  border-radius: 50%;
  display: flex; align-items: center; justify-content: center;
  font-size: 12px;
  font-weight: 400;
  flex-shrink: 0;
}

.step-text strong {
  display: block;
  color: var(--color-forest-green);
  font-size: 14px;
  font-weight: 400;
  margin-bottom: 2px;
}

.step-text span {
  color: var(--color-dark-charcoal);
  font-size: 12px;
  font-weight: 300;
}

/* FORM CARD */
.form-card {
  background: var(--color-mint-kiss);
  border-radius: var(--radius-cards);
  padding: var(--card-padding);
  border: 1px solid var(--color-mint-glaze);
}

.form-card h2 {
  font-family: var(--font-display);
  font-weight: 300;
  font-size: 28px;
  line-height: 1.3;
  letter-spacing: -0.84px;
  color: var(--color-forest-green);
  margin-bottom: 28px;
}

.alert {
  padding: 14px 18px;
  border-radius: var(--radius-cards);
  font-size: 14px;
  margin-bottom: 21px;
  line-height: 1.6;
}

.alert-success {
  background: var(--color-keylime-wash);
  border: 1px solid var(--color-mint-glaze);
  color: var(--color-forest-green);
}

.alert-error {
  background: #fef2f2;
  border: 1px solid #fecaca;
  color: #dc2626;
}

.form-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: var(--element-gap);
}

.form-group {
  margin-bottom: var(--element-gap);
}

label {
  display: block;
  font-size: 12px;
  font-weight: 400;
  letter-spacing: -0.36px;
  color: var(--color-forest-green);
  margin-bottom: 7px;
  text-transform: uppercase;
}

label .req { color: #dc2626; margin-left: 2px; }

select, input[type="text"], textarea {
  width: 100%;
  background: var(--color-cream-canvas);
  border: 1px solid var(--color-border-grey);
  border-radius: var(--radius-buttons);
  color: var(--color-ink-text);
  font-family: var(--font-body);
  font-size: 14px;
  font-weight: 300;
  letter-spacing: -0.42px;
  padding: 11px 14px;
  outline: none;
  transition: border-color 0.2s, box-shadow 0.2s;
  -webkit-appearance: none;
}

select:focus, input[type="text"]:focus, textarea:focus {
  border-color: var(--color-forest-green);
  box-shadow: 0 0 0 3px rgba(15,62,23,0.08);
}

select { background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%230f3e17' d='M6 8L1 3h10z'/%3E%3C/svg%3E"); background-repeat: no-repeat; background-position: right 12px center; padding-right: 32px; cursor: pointer; }

textarea { resize: vertical; min-height: 130px; line-height: 1.6; }

::placeholder { color: #aaa; }

.char-hint {
  text-align: right;
  font-size: 11px;
  color: var(--color-dark-charcoal);
  margin-top: 4px;
  opacity: 0.5;
}

.btn-primary {
  width: 100%;
  padding: 14px 21px;
  background: var(--color-forest-green);
  color: var(--color-cream-canvas);
  border: none;
  border-radius: var(--radius-buttons);
  font-family: var(--font-body);
  font-size: 14px;
  font-weight: 400;
  letter-spacing: -0.42px;
  cursor: pointer;
  transition: opacity 0.2s, transform 0.15s;
  margin-top: 7px;
}

.btn-primary:hover { opacity: 0.88; transform: translateY(-1px); }
.btn-primary:active { transform: translateY(0); }

.form-footer {
  margin-top: 21px;
  padding-top: 21px;
  border-top: 1px solid var(--color-border-grey);
  text-align: center;
  font-size: 13px;
  color: var(--color-dark-charcoal);
}

.form-footer a {
  color: var(--color-forest-green);
  font-weight: 400;
  text-decoration: none;
}
.form-footer a:hover { text-decoration: underline; }

@media (max-width: 768px) {
  .page { grid-template-columns: 1fr; padding: 28px 21px; }
  .form-row { grid-template-columns: 1fr; }
  nav { padding: 14px 21px; }
  .hero h1 { font-size: 32px; }
}
</style>
</head>
<body>

<nav>
  <a href="index.jsp" class="nav-brand">
    <div class="nav-logo">📄</div>
    <span class="nav-title">BRD Generator</span>
  </a>
  <a href="generate-brd.jsp" class="nav-pill">Generate BRD →</a>
</nav>

<div class="page">

  <!-- LEFT -->
  <div class="hero">
    <div class="hero-badge">AI Powered · Groq LLaMA</div>
    <h1>Turn conversations into requirements</h1>
    <p>Upload emails, meeting notes, and messages. Our AI transforms them into professional Business Requirement Documents.</p>

    <div class="steps">
      <div class="step">
        <div class="step-num">1</div>
        <div class="step-text">
          <strong>Upload communications</strong>
          <span>Paste emails, Slack messages, or meeting notes from any stakeholder</span>
        </div>
      </div>
      <div class="step">
        <div class="step-num">2</div>
        <div class="step-text">
          <strong>Generate your BRD</strong>
          <span>AI analyses all communications and produces a structured document</span>
        </div>
      </div>
      <div class="step">
        <div class="step-num">3</div>
        <div class="step-text">
          <strong>Refine with natural language</strong>
          <span>Edit the document by typing plain English instructions</span>
        </div>
      </div>
    </div>
  </div>

  <!-- RIGHT FORM -->
  <div class="form-card">
    <h2>Upload communication</h2>

    <% if (successProject != null) { %>
    <div class="alert alert-success">✓ Communication saved for <strong><%= successProject %></strong>. Upload more or generate the BRD.</div>
    <% } %>

    <% if (errorMsg != null) { %>
    <div class="alert alert-error">⚠ <%= errorMsg %></div>
    <% } %>

    <form action="UploadServlet" method="post" onsubmit="return validate()">

      <div class="form-row">
        <div class="form-group">
          <label>Source type</label>
          <select name="sourceType">
            <option value="Email">Email</option>
            <option value="Slack">Slack</option>
            <option value="Meeting">Meeting notes</option>
            <option value="Document">Document</option>
            <option value="Call">Call notes</option>
          </select>
        </div>
        <div class="form-group">
          <label>Sender name</label>
          <input type="text" name="senderName" placeholder="e.g. John Smith" maxlength="100">
        </div>
      </div>

      <div class="form-group">
        <label>Project name <span class="req">*</span></label>
        <input type="text" name="projectName" id="projectName" placeholder="e.g. Customer Portal v2" maxlength="100" required>
      </div>

      <div class="form-group">
        <label>Content <span class="req">*</span></label>
        <textarea name="content" id="content" placeholder="Paste email, meeting notes, or message content here…" maxlength="10000" required oninput="updateCount()"></textarea>
        <div class="char-hint"><span id="cc">0</span> / 10,000</div>
      </div>

      <button type="submit" class="btn-primary">Upload Communication</button>
    </form>

    <div class="form-footer">
      Ready to build your document? <a href="generate-brd.jsp">Generate BRD →</a>
    </div>
  </div>

</div>

<script>
function updateCount() {
  document.getElementById('cc').textContent = document.getElementById('content').value.length;
}
function validate() {
  if (!document.getElementById('projectName').value.trim()) { alert('Please enter a project name.'); return false; }
  if (!document.getElementById('content').value.trim()) { alert('Please enter content.'); return false; }
  return true;
}
</script>
</body>
</html>
