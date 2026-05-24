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
<title>AI BRD Generator</title>
<style>
  * { box-sizing: border-box; margin: 0; padding: 0; }

  body {
    font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
    background: linear-gradient(135deg, #0f0c29 0%, #302b63 50%, #24243e 100%);
    min-height: 100vh;
    display: flex;
    align-items: flex-start;
    justify-content: center;
    padding: 40px 20px;
  }

  .container {
    width: 100%;
    max-width: 700px;
  }

  .header {
    text-align: center;
    margin-bottom: 32px;
    color: white;
  }

  .header .badge {
    display: inline-block;
    background: rgba(255,255,255,0.15);
    border: 1px solid rgba(255,255,255,0.25);
    color: #a78bfa;
    font-size: 12px;
    font-weight: 600;
    letter-spacing: 2px;
    text-transform: uppercase;
    padding: 4px 14px;
    border-radius: 20px;
    margin-bottom: 16px;
  }

  .header h1 {
    font-size: 2.4rem;
    font-weight: 700;
    background: linear-gradient(90deg, #a78bfa, #60a5fa);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    margin-bottom: 8px;
  }

  .header p {
    color: rgba(255,255,255,0.5);
    font-size: 0.95rem;
  }

  .card {
    background: rgba(255,255,255,0.05);
    border: 1px solid rgba(255,255,255,0.12);
    border-radius: 20px;
    padding: 36px;
    backdrop-filter: blur(20px);
  }

  .alert {
    padding: 14px 18px;
    border-radius: 12px;
    margin-bottom: 24px;
    font-size: 14px;
    display: flex;
    align-items: center;
    gap: 10px;
  }

  .alert-success {
    background: rgba(16, 185, 129, 0.15);
    border: 1px solid rgba(16, 185, 129, 0.3);
    color: #34d399;
  }

  .alert-error {
    background: rgba(239, 68, 68, 0.15);
    border: 1px solid rgba(239, 68, 68, 0.3);
    color: #f87171;
  }

  .form-group {
    margin-bottom: 22px;
  }

  label {
    display: block;
    color: rgba(255,255,255,0.7);
    font-size: 13px;
    font-weight: 600;
    letter-spacing: 0.5px;
    margin-bottom: 8px;
    text-transform: uppercase;
  }

  label span.required {
    color: #f87171;
    margin-left: 3px;
  }

  select, input[type="text"], textarea {
    width: 100%;
    background: rgba(255,255,255,0.08);
    border: 1px solid rgba(255,255,255,0.15);
    border-radius: 10px;
    color: white;
    font-size: 15px;
    padding: 12px 16px;
    outline: none;
    transition: border-color 0.2s, background 0.2s;
    font-family: inherit;
  }

  select:focus, input[type="text"]:focus, textarea:focus {
    border-color: #7c3aed;
    background: rgba(255,255,255,0.12);
    box-shadow: 0 0 0 3px rgba(124,58,237,0.2);
  }

  select option {
    background: #1e1b4b;
  }

  textarea {
    resize: vertical;
    min-height: 150px;
    line-height: 1.6;
  }

  ::placeholder { color: rgba(255,255,255,0.3); }

  .form-row {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 16px;
  }

  .btn {
    width: 100%;
    padding: 14px;
    border: none;
    border-radius: 12px;
    font-size: 16px;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.2s;
    letter-spacing: 0.3px;
  }

  .btn-primary {
    background: linear-gradient(135deg, #7c3aed, #4f46e5);
    color: white;
    box-shadow: 0 4px 15px rgba(124,58,237,0.4);
  }

  .btn-primary:hover {
    transform: translateY(-1px);
    box-shadow: 0 6px 20px rgba(124,58,237,0.5);
  }

  .btn-primary:active { transform: translateY(0); }

  .divider {
    border: none;
    border-top: 1px solid rgba(255,255,255,0.1);
    margin: 28px 0;
  }

  .secondary-action {
    text-align: center;
    color: rgba(255,255,255,0.5);
    font-size: 14px;
  }

  .secondary-action a {
    color: #a78bfa;
    text-decoration: none;
    font-weight: 600;
  }

  .secondary-action a:hover { text-decoration: underline; }

  .char-count {
    text-align: right;
    font-size: 12px;
    color: rgba(255,255,255,0.3);
    margin-top: 5px;
  }

  @media (max-width: 520px) {
    .form-row { grid-template-columns: 1fr; }
    .header h1 { font-size: 1.8rem; }
    .card { padding: 24px; }
  }
</style>
</head>
<body>
<div class="container">
  <div class="header">
    <div class="badge">AI Powered</div>
    <h1>BRD Generator</h1>
    <p>Upload communications to generate professional Business Requirement Documents</p>
  </div>

  <div class="card">

    <% if (successProject != null) { %>
    <div class="alert alert-success">
      <span>✓</span>
      <span>Communication uploaded for <strong><%= successProject %></strong>. Add more or generate the BRD.</span>
    </div>
    <% } %>

    <% if (errorMsg != null) { %>
    <div class="alert alert-error">
      <span>✕</span>
      <span><%= errorMsg %></span>
    </div>
    <% } %>

    <form action="UploadServlet" method="post" onsubmit="return validateForm()">

      <div class="form-row">
        <div class="form-group">
          <label>Source Type</label>
          <select name="sourceType">
            <option value="Email">📧 Email</option>
            <option value="Slack">💬 Slack</option>
            <option value="Meeting">🎙️ Meeting Notes</option>
            <option value="Document">📄 Document</option>
            <option value="Call">📞 Call Notes</option>
          </select>
        </div>

        <div class="form-group">
          <label>Sender Name</label>
          <input type="text" name="senderName" placeholder="e.g. John Smith" maxlength="100">
        </div>
      </div>

      <div class="form-group">
        <label>Project Name <span class="required">*</span></label>
        <input type="text" name="projectName" id="projectName" placeholder="e.g. Customer Portal v2" maxlength="100" required>
      </div>

      <div class="form-group">
        <label>Communication Content <span class="required">*</span></label>
        <textarea name="content" id="content" placeholder="Paste the email, meeting notes, or message content here..." maxlength="10000" required oninput="updateCount()"></textarea>
        <div class="char-count"><span id="charCount">0</span> / 10,000</div>
      </div>

      <button type="submit" class="btn btn-primary">
        Upload Communication
      </button>
    </form>

    <hr class="divider">

    <div class="secondary-action">
      Ready to generate? &nbsp;
      <a href="generate-brd.jsp">Generate BRD →</a>
    </div>

  </div>
</div>

<script>
function updateCount() {
  const ta = document.getElementById('content');
  document.getElementById('charCount').textContent = ta.value.length;
}

function validateForm() {
  const project = document.getElementById('projectName').value.trim();
  const content = document.getElementById('content').value.trim();
  if (!project) { alert('Please enter a project name.'); return false; }
  if (!content) { alert('Please enter some content.'); return false; }
  return true;
}
</script>
</body>
</html>
