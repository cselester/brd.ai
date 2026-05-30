<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
String errorMsg = (String) session.getAttribute("generateError");
if (errorMsg != null) session.removeAttribute("generateError");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Generate BRD — BRD Generator</title>
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
nav {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 18px 42px;
  border-bottom: 1px solid var(--color-border-grey);
  position: sticky; top: 0; z-index: 100;
  background: var(--color-cream-canvas);
}
.nav-brand { display: flex; align-items: center; gap: 10px; text-decoration: none; }
.nav-logo {
  width: 32px; height: 32px;
  background: var(--color-forest-green);
  border-radius: 8px;
  display: flex; align-items: center; justify-content: center;
  color: var(--color-cream-canvas); font-size: 16px;
}
.nav-title {
  font-family: var(--font-display);
  font-weight: 300; font-size: 18px;
  color: var(--color-forest-green); letter-spacing: -0.54px;
}
.nav-back {
  color: var(--color-dark-charcoal);
  font-size: 13px; text-decoration: none;
  display: flex; align-items: center; gap: 6px;
}
.nav-back:hover { color: var(--color-forest-green); }

.page {
  max-width: 600px;
  margin: 0 auto;
  padding: 70px 42px;
}

.eyebrow {
  font-size: 12px;
  font-weight: 400;
  letter-spacing: -0.36px;
  color: var(--color-forest-green);
  text-transform: uppercase;
  margin-bottom: 14px;
  opacity: 0.7;
}

h1 {
  font-family: var(--font-display);
  font-weight: 300;
  font-size: 40px;
  line-height: 1.05;
  letter-spacing: -0.4px;
  color: var(--color-forest-green);
  margin-bottom: 14px;
}

.subtitle {
  font-size: 16px;
  font-weight: 300;
  line-height: 1.5;
  letter-spacing: -0.48px;
  color: var(--color-dark-charcoal);
  margin-bottom: 42px;
}

.alert {
  padding: 14px 18px;
  border-radius: var(--radius-cards);
  font-size: 14px;
  margin-bottom: 28px;
  background: #fef2f2;
  border: 1px solid #fecaca;
  color: #dc2626;
  display: flex; gap: 8px; align-items: flex-start;
}

.form-card {
  background: var(--color-slate-mist);
  border-radius: var(--radius-cards);
  padding: 42px;
  border: 1px solid rgba(182,206,213,0.5);
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

input[type="text"] {
  width: 100%;
  background: var(--color-cream-canvas);
  border: 1px solid var(--color-border-grey);
  border-radius: var(--radius-buttons);
  color: var(--color-ink-text);
  font-family: var(--font-body);
  font-size: 16px;
  font-weight: 300;
  letter-spacing: -0.48px;
  padding: 14px 18px;
  outline: none;
  transition: border-color 0.2s, box-shadow 0.2s;
  margin-bottom: 21px;
}
input[type="text"]:focus {
  border-color: var(--color-forest-green);
  box-shadow: 0 0 0 3px rgba(15,62,23,0.08);
}
::placeholder { color: #bbb; }

.btn-primary {
  width: 100%;
  padding: 16px 21px;
  background: var(--color-forest-green);
  color: var(--color-cream-canvas);
  border: none;
  border-radius: var(--radius-buttons);
  font-family: var(--font-body);
  font-size: 15px;
  font-weight: 400;
  letter-spacing: -0.45px;
  cursor: pointer;
  transition: opacity 0.2s, transform 0.15s;
  display: flex; align-items: center; justify-content: center; gap: 8px;
}
.btn-primary:hover { opacity: 0.88; transform: translateY(-1px); }
.btn-primary:disabled { opacity: 0.55; cursor: not-allowed; transform: none; }

.spinner {
  display: none; width: 16px; height: 16px;
  border: 2px solid rgba(255,255,255,0.35);
  border-top-color: #fff;
  border-radius: 50%;
  animation: spin 0.7s linear infinite;
}
@keyframes spin { to { transform: rotate(360deg); } }

@media (max-width: 600px) {
  .page { padding: 42px 21px; }
  h1 { font-size: 32px; }
  nav { padding: 14px 21px; }
}
</style>
</head>
<body>
<nav>
  <a href="index.jsp" class="nav-brand">
    <div class="nav-logo">📄</div>
    <span class="nav-title">BRD Generator</span>
  </a>
  <a href="index.jsp" class="nav-back">← Upload</a>
</nav>

<div class="page">
  <div class="eyebrow">Step 2 of 3</div>
  <h1>Generate your document</h1>
  <p class="subtitle">Enter the project name you used when uploading communications. The AI will analyse everything and build the BRD.</p>

  <% if (errorMsg != null) { %>
  <div class="alert">⚠ <%= errorMsg %></div>
  <% } %>

  <div class="form-card">
    <form action="GenerateBRDServlet" method="post" onsubmit="onSubmit()">
      <label>Project name *</label>
      <input type="text" name="projectName" placeholder="e.g. Customer Portal v2" required autofocus>
      <button type="submit" class="btn-primary" id="btn">
        <span class="spinner" id="sp"></span>
        <span id="btnTxt">Generate BRD</span>
      </button>
    </form>
  </div>
</div>

<script>
function onSubmit() {
  document.getElementById('sp').style.display = 'block';
  document.getElementById('btnTxt').textContent = 'Generating…';
  document.getElementById('btn').disabled = true;
}
</script>
</body>
</html>
