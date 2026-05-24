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
<title>Generate BRD | AI BRD Generator</title>
<style>
  * { box-sizing: border-box; margin: 0; padding: 0; }
  body {
    font-family: 'Segoe UI', system-ui, sans-serif;
    background: linear-gradient(135deg, #0f0c29 0%, #302b63 50%, #24243e 100%);
    min-height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 40px 20px;
  }
  .container { width: 100%; max-width: 520px; }
  .back-link {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    color: rgba(255,255,255,0.5);
    text-decoration: none;
    font-size: 14px;
    margin-bottom: 24px;
    transition: color 0.2s;
  }
  .back-link:hover { color: #a78bfc; }
  .card {
    background: rgba(255,255,255,0.05);
    border: 1px solid rgba(255,255,255,0.12);
    border-radius: 20px;
    padding: 40px;
    backdrop-filter: blur(20px);
  }
  .icon {
    width: 60px;
    height: 60px;
    background: linear-gradient(135deg, #7c3aed, #4f46e5);
    border-radius: 16px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 28px;
    margin-bottom: 20px;
  }
  h1 {
    color: #fff;
    font-size: 1.8rem;
    font-weight: 700;
    margin-bottom: 8px;
  }
  p.subtitle {
    color: rgba(255,255,255,0.5);
    font-size: 14px;
    margin-bottom: 28px;
    line-height: 1.6;
  }
  .alert {
    padding: 14px 18px;
    border-radius: 12px;
    margin-bottom: 24px;
    font-size: 14px;
    background: rgba(239,68,68,0.15);
    border: 1px solid rgba(239,68,68,0.3);
    color: #f87121;
    display: flex;
    gap: 10px;
  }
  label {
    display: block;
    color: rgba(255,255,255,0.7);
    font-size: 13px;
    font-weight: 600;
    letter-spacing: 0.5px;
    text-transform: uppercase;
    margin-bottom: 8px;
  }
  input[type="text"] {
    width: 100%;
    background: rgba(255,255,255,0.08);
    border: 1px solid rgba(255,255,255,0.15);
    border-radius: 10px;
    color: #fff;
    font-size: 15px;
    padding: 13px 16px;
    outline: none;
    font-family: inherit;
    transition: border-color 0.2s, box-shadow 0.2s;
    margin-bottom: 20px;
  }
  input[type="text"]:focus {
    border-color: #7c3aed;
    box-shadow: 0 0 0 3px rgba(124,58,237,0.2);
  }
  ::placeholder { color: rgba(255,255,255,0.3); }
  .btn {
    width: 100%;
    padding: 14px;
    border: none;
    border-radius: 12px;
    font-size: 16px;
    font-weight: 600;
    cursor: pointer;
    background: linear-gradient(135deg, #7c3aed, #4f46e5);
    color: #fff;
    box-shadow: 0 4px 15px rgba(124,58,237,0.4);
    transition: all 0.2s;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
  }
  .btn:hover {
    transform: translateY(-1px);
    box-shadow: 0 6px 20px rgba(124,58,237,0.5);
  }
  .btn:disabled {
    opacity: 0.7;
    cursor: not-allowed;
    transform: none;
  }
  .spinner {
    display: none;
    width: 18px;
    height: 18px;
    border: 2px solid rgba(255,255,255,0.3);
    border-top-color: #fff;
    border-radius: 50%;
    animation: spin 0.8s linear infinite;
  }
  @keyframes spin { to { transform: rotate(360deg); } }
</style>
</head>
<body>
<div class="container">
  <a href="index.jsp" class="back-link">← Back to Upload</a>
  <div class="card">
    <div class="icon">📄</div>
    <h1>Generate BRD</h1>
    <p class="subtitle">Enter your project name to generate a professional Business Requirements Document using AI.</p>

    <% if (errorMsg != null) { %>
    <div class="alert">⚠ <%= errorMsg %></div>
    <% } %>

    <form action="GenerateBRDServlet" method="post" onsubmit="onSubmit(this)">
      <label>Project Name *</label>
      <input type="text" name="projectName" placeholder="Enter the project name" required autofocus>
      <button type="submit" class="btn" id="generateBtn">
        <span class="spinner" id="spinner"></span>
        <span id="btnText">Generate Document</span>
      </button>
    </form>
  </div>
</div>
<script>
function onSubmit(form) {
  document.getElementById('spinner').style.display = 'block';
  document.getElementById('btnText').textContent = 'Generating...';
  document.getElementById('generateBtn').disabled = true;
}
</script>
</body>
</html>
